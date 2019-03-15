var Model,
  hasProp = {}.hasOwnProperty;

import Util from '../util/Util.js';

import Data from '../app/Data.js';

import Trip from '../app/Trip.js';

Model = class Model {
  constructor(stream, rest, dataSource) {
    this.onSource = this.onSource.bind(this);
    this.onDestination = this.onDestination.bind(this);
    // checkComplete is call three times when each status completed is changed
    // goOrNoGo is then only called once
    this.checkComplete = this.checkComplete.bind(this);
    this.doSegments = this.doSegments.bind(this);
    this.doConditions = this.doConditions.bind(this);
    this.doDeals = this.doDeals.bind(this);
    this.doMilePosts = this.doMilePosts.bind(this);
    this.doForecasts = this.doForecasts.bind(this);
    this.doTownForecast = this.doTownForecast.bind(this);
    this.onSegmentsError = this.onSegmentsError.bind(this);
    this.onConditionsError = this.onConditionsError.bind(this);
    this.onDealsError = this.onDealsError.bind(this);
    this.onForecastsError = this.onForecastsError.bind(this);
    this.onTownForecastError = this.onTownForecastError.bind(this);
    this.onMilePostsError = this.onMilePostsError.bind(this);
    this.errorsDetected = this.errorsDetected.bind(this);
    this.stream = stream;
    this.rest = rest;
    this.dataSource = dataSource;
    this.first = true; // Implies we have not acquired enough data to get started
    this.source = '?';
    this.destination = '?';
    this.trips = {};
    this.resetCompletionStatus();
    this.milePostsComplete = false;
    this.milePostsCompleteWithError = false;
    this.segments = [];
    this.conditions = [];
    this.deals = [];
    this.forecasts = {};
    this.forecastsPending = 0;
    this.forecastsCount = 0;
    this.milePosts = [];
    this.segmentIds = Data.WestSegmentIds; // CDOT road speed segment for Demo I70 West from 6th Ave to East Vail
    this.segmentIdsReturned = []; // Accumulate by doSegments()
    Util.noop(this.forecastsPending, this.segmentIds, this.segmentIdsReturned);
  }

  ready() {
    return this.subscribe();
  }

  subscribe() {
    this.stream.subscribe('Source', 'Model', (source) => {
      return this.onSource(source);
    });
    return this.stream.subscribe('Destination', 'Model', (destination) => {
      return this.onDestination(destination);
    });
  }

  // A poor man's chained completion status.
  // Could be implemented better in the future with a chained Stream or a synched promise chain
  resetCompletionStatus() {
    this.segmentsComplete = false;
    this.segmentsCompleteWithError = false;
    this.conditionsComplete = false;
    this.conditionsCompleteWithError = false;
    this.dealsComplete = false;
    this.dealsCompleteWithError = false;
  }

  onSource(source) {
    this.source = source;
    if (this.destination !== '?' && this.source !== this.destination) {
      this.createTrip(this.source, this.destination);
    }
  }

  onDestination(destination) {
    this.destination = destination;
    if (this.source !== '?' && this.source !== this.destination) {
      this.createTrip(this.source, this.destination);
    }
  }

  tripName(source, destination) {
    return `${source}To${destination}`;
  }

  trip() {
    return this.trips[this.tripName(this.source, this.destination)];
  }

  // The Trip parameter calculation process here needs to be refactored
  createTrip(source, destination) {
    var name;
    this.source = source;
    this.destination = destination;
    name = this.tripName(this.source, this.destination);
    this.trips[name] = new Trip(this.stream, this, name, source, destination);
    switch (this.dataSource) {
      case 'Rest':
      case 'RestThenLocal':
        this.doTrip(this.trips[name]);
        break;
      case 'Local':
      case 'LocalForecasts':
        this.doTripLocal(this.trips[name]);
        break;
      default:
        console.error('Model.createTrip() unknown dataSource', this.dataSource);
    }
  }

  doTrip(trip) {
    this.resetCompletionStatus();
    this.rest.segmentsByPreset(trip.preset, this.doSegments, this.onSegmentsError);
    this.rest.conditionsBySegments(trip.segmentIdsAll, this.doConditions, this.onConditionsError);
    this.rest.deals(this.app.dealsUI.latLon(), trip.segmentIdsAll, this.doDeals, this.onDealsError);
    this.rest.milePostsFromLocal(this.doMilePosts, this.onMilePostsError);
  }

  doTripLocal(trip) {
    this.resetCompletionStatus();
    this.rest.segmentsFromLocal(trip.direction, this.doSegments, this.onSegmentsError);
    this.rest.conditionsFromLocal(trip.direction, this.doConditions, this.onConditionsError);
    this.rest.dealsFromLocal(trip.direction, this.doDeals, this.onDealsError);
    if (this.dataSource === 'Local') {
      this.rest.forecastsFromLocal(this.doForecasts, this.onForecastsError);
    }
    if (!this.milePostsComplete && !this.milePostsCompleteWithError) {
      this.rest.milePostsFromLocal(this.doMilePosts, this.onMilePostsError);
    }
  }

  checkComplete() {
    if (this.segmentsComplete && this.conditionsComplete && this.dealsComplete && this.milePostsComplete) {
      return this.launchTrip(this.trip());
    }
  }

  launchTrip(trip) {
    this.first = false;
    trip.launch();
    this.stream.publish('Trip', trip);
    if (this.dataSource !== 'Local') {
      this.restForecasts(trip); // Will punlish forecasts on Stream when completed
    }
  }

  // Makes a rest call for each town in the Trip, and checks completion for each town
  //   so it does not have forecastComplete or forecastCompleteWithError flags
  restForecasts(trip) {
    var date, name, ref, ref1, town;
    this.forecastsPending = 0;
    this.forecastsCount = 0;
    ref = trip.towns;
    for (name in ref) {
      if (!hasProp.call(ref, name)) continue;
      town = ref[name];
      date = new Date();
      town.date = date;
      town.time = town.date.getTime();
      //town.isoDateTime = Util.isoDateTime(date)
      this.forecastsPending++;
    }
    ref1 = trip.towns;
    for (name in ref1) {
      if (!hasProp.call(ref1, name)) continue;
      town = ref1[name];
      this.rest.forecastByTown(name, town, this.doTownForecast, this.onTownForecastError);
    }
  }

  doSegments(args, segments) {
    var id, key, num, ref, seg, trip;
    trip = this.trip();
    trip.travelTime = segments.travelTime;
    trip.segments = [];
    trip.segmentIds = [];
    ref = segments.segments;
    for (key in ref) {
      if (!hasProp.call(ref, key)) continue;
      seg = ref[key];
      id = 0;
      num = 0;
      [id, num] = trip.segIdNum(key);
      // console.log( 'Model.doSegments id num', { id:id, num:num, beg:seg.StartMileMarker, end:seg.EndMileMarker } )
      if (trip.segInTrip(seg)) {
        seg['segId'] = num;
        seg.num = num;
        trip.segments.push(seg);
        trip.segmentIds.push(num);
      }
    }
    this.segmentsComplete = true;
    // console.log( 'Model.doSegments segmenIds', trip.segmentIds )
    this.checkComplete();
  }

  doConditions(args, conditions) {
    this.trip().conditions = conditions;
    this.conditionsComplete = true;
    this.checkComplete();
  }

  doDeals(args, deals) {
    this.trip().deals = deals;
    this.dealsComplete = true;
    this.checkComplete();
  }

  doMilePosts(args, milePosts) {
    this.milePosts = milePosts;
    this.trip().milePosts = milePosts;
    this.milePostsComplete = true;
    this.checkComplete();
  }

  doForecasts(args, forecasts) {
    var forecast, name, trip;
    trip = this.trip();
    for (name in forecasts) {
      if (!hasProp.call(forecasts, name)) continue;
      forecast = forecasts[name];
      trip.forecasts[name] = forecast;
      trip.forecasts[name].index = Trip.Towns[name].index;
    }
    this.stream.publish('Forecasts', trip.forecasts, 'Model');
  }

  doTownForecast(args, forecast) {
    var name, trip;
    name = args.name;
    trip = this.trip();
    trip.forecasts[name] = forecast;
    trip.forecasts[name].index = Trip.Towns[name].index;
    this.publishForecastsWhenComplete(trip.forecasts);
  }

  onSegmentsError(obj) {
    console.error('Model.onSegmentError()', obj);
    this.segmentsCompleteWithError = true;
    this.errorsDetected();
  }

  onConditionsError(obj) {
    console.error('Model.onConditionsError()', obj);
    this.conditionsCompleteWithError = true;
    this.errorsDetected();
  }

  onDealsError(obj) {
    console.error('Model.onDealsError()', obj);
    this.dealsCompleteWithError = true;
    this.errorsDetected();
  }

  onForecastsError(obj) {
    console.error('Model.onForecastsError()', {
      name: obj.args.name
    });
  }

  onTownForecastError(obj) {
    var name;
    name = obj.args.name;
    console.error('Model.townForecastError()', {
      name: name
    });
    this.publishForecastsWhenComplete(this.trip().forecasts); // We push on error because some forecasts may have made it through
  }

  publishForecastsWhenComplete(forecasts) {
    this.forecastsCount++;
    if (this.forecastsCount === this.forecastsPending) {
      this.stream.publish('Forecasts', forecasts);
      this.forecastsPending = 0; // No more pending forecasts after push
    }
  }

  onMilePostsError(obj) {
    console.error('Model.onMilePostsError()', obj);
    this.milePostsCompleteWithError = true;
    this.errorsDetected();
  }

  errorsDetected() {
    if ((this.segmentsComplete || this.segmentsCompleteWithError) && (this.conditionsComplete || this.conditionsCompleteWithError) && (this.dealsComplete || this.dealsCompleteWithError) && (this.milePostsComplete || this.milePostsCompleteWithError) && this.dataSource === 'RestThenLocal' && this.first) {
      this.doTripLocal(this.trip());
    } else {
      console.error('Model.errorsDetected access data unable to proceed with trip');
    }
  }

};

export default Model;
