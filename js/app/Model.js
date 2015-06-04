// Generated by CoffeeScript 1.9.1
(function() {
  var Model,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    hasProp = {}.hasOwnProperty;

  Model = (function() {
    Util.Export(Model, 'app/Model');

    function Model(app, stream, rest) {
      this.app = app;
      this.stream = stream;
      this.rest = rest;
      this.errorsDetected = bind(this.errorsDetected, this);
      this.onMilePostsError = bind(this.onMilePostsError, this);
      this.onTownForecastError = bind(this.onTownForecastError, this);
      this.onForecastsError = bind(this.onForecastsError, this);
      this.onDealsError = bind(this.onDealsError, this);
      this.onConditionsError = bind(this.onConditionsError, this);
      this.onSegmentsError = bind(this.onSegmentsError, this);
      this.doTownForecast = bind(this.doTownForecast, this);
      this.doForecasts = bind(this.doForecasts, this);
      this.doMilePosts = bind(this.doMilePosts, this);
      this.doDeals = bind(this.doDeals, this);
      this.doConditions = bind(this.doConditions, this);
      this.doSegments = bind(this.doSegments, this);
      this.checkComplete = bind(this.checkComplete, this);
      this.onDestination = bind(this.onDestination, this);
      this.onSource = bind(this.onSource, this);
      this.Data = Util.Import('app/Data');
      this.Trip = Util.Import('app/Trip');
      this.first = true;
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
      this.segmentIds = this.Data.WestSegmentIds;
      this.segmentIdsReturned = [];
    }

    Model.prototype.ready = function() {
      return this.subscribe();
    };

    Model.prototype.subscribe = function() {
      this.stream.subscribe('Source', (function(_this) {
        return function(source) {
          return _this.onSource(source);
        };
      })(this));
      return this.stream.subscribe('Destination', (function(_this) {
        return function(destination) {
          return _this.onDestination(destination);
        };
      })(this));
    };

    Model.prototype.resetCompletionStatus = function() {
      this.segmentsComplete = false;
      this.segmentsCompleteWithError = false;
      this.conditionsComplete = false;
      this.conditionsCompleteWithError = false;
      this.dealsComplete = false;
      this.dealsCompleteWithError = false;
    };

    Model.prototype.onSource = function(source) {
      this.source = source;
      if (this.destination !== '?' && this.source !== this.destination) {
        this.createTrip(this.source, this.destination);
      }
    };

    Model.prototype.onDestination = function(destination) {
      this.destination = destination;
      if (this.source !== '?' && this.source !== this.destination) {
        this.createTrip(this.source, this.destination);
      }
    };

    Model.prototype.tripName = function(source, destination) {
      return source + "To" + destination;
    };

    Model.prototype.trip = function() {
      return this.trips[this.tripName(this.source, this.destination)];
    };

    Model.prototype.createTrip = function(source, destination) {
      var name;
      this.source = source;
      this.destination = destination;
      name = this.tripName(this.source, this.destination);
      this.trips[name] = new this.Trip(this.app, this.stream, this, name, source, destination);
      switch (this.app.dataSource) {
        case 'Rest':
        case 'RestThenLocal':
          this.doTrip(this.trips[name]);
          break;
        case 'Local':
        case 'LocalForecasts':
          this.doTripLocal(this.trips[name]);
          break;
        default:
          Util.error('Model.createTrip() unknown dataSource', this.app.dataSource);
      }
    };

    Model.prototype.doTrip = function(trip) {
      this.resetCompletionStatus();
      this.rest.segmentsByPreset(trip.preset, this.doSegments, this.onSegmentsError);
      this.rest.conditionsBySegments(trip.segmentIdsAll, this.doConditions, this.onConditionsError);
      this.rest.deals(this.app.dealsUI.latLon(), trip.segmentIdsAll, this.doDeals, this.onDealsError);
      this.rest.milePostsFromLocal(this.doMilePosts, this.onMilePostsError);
    };

    Model.prototype.doTripLocal = function(trip) {
      this.resetCompletionStatus();
      this.rest.segmentsFromLocal(trip.direction, this.doSegments, this.onSegmentsError);
      this.rest.conditionsFromLocal(trip.direction, this.doConditions, this.onConditionsError);
      this.rest.dealsFromLocal(trip.direction, this.doDeals, this.onDealsError);
      if (this.app.dataSource === 'Local') {
        this.rest.forecastsFromLocal(this.doForecasts, this.onForecastsError);
      }
      if (!this.milePostsComplete && !this.milePostsCompleteWithError) {
        this.rest.milePostsFromLocal(this.doMilePosts, this.onMilePostsError);
      }
    };

    Model.prototype.checkComplete = function() {
      if (this.segmentsComplete && this.conditionsComplete && this.dealsComplete && this.milePostsComplete) {
        return this.launchTrip(this.trip());
      }
    };

    Model.prototype.launchTrip = function(trip) {
      this.first = false;
      trip.launch();
      this.app.ui.changeRecommendation(trip.recommendation);
      this.stream.publish('Trip', trip);
      if (this.app.dataSource !== 'Local') {
        this.restForecasts(trip);
      }
    };

    Model.prototype.restForecasts = function(trip) {
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
        this.forecastsPending++;
      }
      ref1 = trip.towns;
      for (name in ref1) {
        if (!hasProp.call(ref1, name)) continue;
        town = ref1[name];
        this.rest.forecastByTown(name, town, this.doTownForecast, this.onTownForecastError);
      }
    };

    Model.prototype.doSegments = function(args, segments) {
      var id, key, num, ref, ref1, seg, trip;
      trip = this.trip();
      trip.travelTime = segments.travelTime;
      trip.segments = [];
      trip.segmentIds = [];
      ref = segments.segments;
      for (key in ref) {
        if (!hasProp.call(ref, key)) continue;
        seg = ref[key];
        ref1 = trip.segIdNum(key), id = ref1[0], num = ref1[1];
        if (trip.segInTrip(seg)) {
          seg['segId'] = num;
          seg.num = num;
          trip.segments.push(seg);
          trip.segmentIds.push(num);
        }
      }
      this.segmentsComplete = true;
      this.checkComplete();
    };

    Model.prototype.doConditions = function(args, conditions) {
      this.trip().conditions = conditions;
      this.conditionsComplete = true;
      this.checkComplete();
    };

    Model.prototype.doDeals = function(args, deals) {
      this.trip().deals = deals;
      this.dealsComplete = true;
      this.checkComplete();
    };

    Model.prototype.doMilePosts = function(args, milePosts) {
      this.milePosts = milePosts;
      this.trip().milePosts = milePosts;
      this.milePostsComplete = true;
      this.checkComplete();
    };

    Model.prototype.doForecasts = function(args, forecasts) {
      var forecast, name, trip;
      trip = this.trip();
      for (name in forecasts) {
        if (!hasProp.call(forecasts, name)) continue;
        forecast = forecasts[name];
        trip.forecasts[name] = forecast;
        trip.forecasts[name].index = this.Trip.Towns[name].index;
      }
      this.stream.publish('Forecasts', trip.forecasts, 'Model');
    };

    Model.prototype.doTownForecast = function(args, forecast) {
      var name, trip;
      name = args.name;
      trip = this.trip();
      trip.forecasts[name] = forecast;
      trip.forecasts[name].index = this.Trip.Towns[name].index;
      this.pushForecastsWhenComplete(trip.forecasts);
    };

    Model.prototype.onSegmentsError = function(obj) {
      Util.error('Model.onSegmentError()', obj);
      this.segmentsCompleteWithError = true;
      this.errorsDetected();
    };

    Model.prototype.onConditionsError = function(obj) {
      Util.error('Model.onConditionsError()', obj);
      this.conditionsCompleteWithError = true;
      this.errorsDetected();
    };

    Model.prototype.onDealsError = function(obj) {
      Util.error('Model.onDealsError()', obj);
      this.dealsCompleteWithError = true;
      this.errorsDetected();
    };

    Model.prototype.onForecastsError = function(obj) {
      Util.error('Model.onForecastsError()', {
        name: obj.args.name
      });
    };

    Model.prototype.onTownForecastError = function(obj) {
      var name;
      name = obj.args.name;
      Util.error('Model.townForecastError()', {
        name: name
      });
      this.publishForecastsWhenComplete(this.trip().forecasts);
    };

    Model.prototype.publishForecastsWhenComplete = function(forecasts) {
      this.forecastsCount++;
      if (this.forecastsCount === this.forecastsPending) {
        this.stream.publish('Forecasts', forecasts);
        this.forecastsPending = 0;
      }
    };

    Model.prototype.onMilePostsError = function(obj) {
      Util.error('Model.onMilePostsError()', obj);
      this.milePostsCompleteWithError = true;
      this.errorsDetected();
    };

    Model.prototype.errorsDetected = function() {
      if ((this.segmentsComplete || this.segmentsCompleteWithError) && (this.conditionsComplete || this.conditionsCompleteWithError) && (this.dealsComplete || this.dealsCompleteWithError) && (this.milePostsComplete || this.milePostsCompleteWithError) && this.app.dataSource === 'RestThenLocal' && this.first) {
        this.doTripLocal(this.trip());
      } else {
        Util.error('Model.errorsDetected access data unable to proceed with trip');
      }
    };

    return Model;

  })();

}).call(this);
