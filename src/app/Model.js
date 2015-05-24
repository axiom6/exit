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
      this.onDealsError = bind(this.onDealsError, this);
      this.onConditionsError = bind(this.onConditionsError, this);
      this.onSegmentsError = bind(this.onSegmentsError, this);
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
      this.resetAllCompletionStatus();
      this.segmentIds = this.Data.WestSegmentIds;
      this.segmentIdsReturned = [];
    }

    Model.prototype.ready = function() {
      return this.subscribe();
    };

    Model.prototype.subscribe = function() {
      this.stream.subscribe('Source', (function(_this) {
        return function(object) {
          return _this.onSource(object.content);
        };
      })(this));
      return this.stream.subscribe('Destination', (function(_this) {
        return function(object) {
          return _this.onDestination(object.content);
        };
      })(this));
    };

    Model.prototype.resetAllCompletionStatus = function() {
      this.segmentsComplete = false;
      this.segmentsCompleteWithError = false;
      this.conditionsComplete = false;
      this.conditionsCompleteWithError = false;
      this.dealsComplete = false;
      return this.dealsCompleteWithError = false;
    };

    Model.prototype.onSource = function(source) {
      this.source = source;
      if (this.destination !== '?' && this.source !== this.destination) {
        return this.createTrip(this.source, this.destination);
      }
    };

    Model.prototype.onDestination = function(destination) {
      this.destination = destination;
      if (this.source !== '?' && this.source !== this.destination) {
        return this.createTrip(this.source, this.destination);
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
          this.doTripLocal(this.trips[name]);
          break;
        default:
          Util.error('Model.createTrip() unknown dataSource', this.app.dataSource);
      }
    };

    Model.prototype.doTrip = function(trip) {
      this.resetAllCompletionStatus();
      this.rest.segmentsByPreset(trip.preset, this.doSegments, this.onSegmentsError);
      this.rest.conditionsBySegments(trip.segmentIdsAll, this.doConditions, this.onConditionsError);
      return this.rest.deals(this.app.dealsUI.latLon(), trip.segmentIdsAll, this.doDeals, this.onDealsError);
    };

    Model.prototype.doTripLocal = function(trip) {
      this.resetAllCompletionStatus();
      this.rest.segmentsFromLocal(trip.direction, this.doSegments, this.onSegmentsError);
      this.rest.conditionsFromLocal(trip.direction, this.doConditions, this.onConditionsError);
      return this.rest.dealsFromLocal(trip.direction, this.doDeals, this.onDealsError);
    };

    Model.prototype.checkComplete = function() {
      if (this.segmentsComplete && this.conditionsComplete && this.dealsComplete) {
        return this.launchTrip(this.trip());
      }
    };

    Model.prototype.launchTrip = function(trip) {
      this.first = false;
      trip.launch();
      this.app.ui.changeRecommendation(trip.recommendation);
      return this.stream.push('Trip', trip, 'Model');
    };

    Model.prototype.doSegments = function(args, segments) {
      var id, key, num, ref, ref1, seg, trip;
      this.segments = segments;
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
          trip.segments.push(seg);
          trip.segmentIds.push(num);
        }
      }
      this.segmentsComplete = true;
      return this.checkComplete();
    };

    Model.prototype.doConditions = function(args, conditions) {
      this.conditions = conditions;
      this.trip().conditions = conditions;
      this.conditionsComplete = true;
      return this.checkComplete();
    };

    Model.prototype.doDeals = function(args, deals) {
      this.deals = deals;
      this.trip().deals = deals;
      this.dealsComplete = true;
      return this.checkComplete();
    };

    Model.prototype.onSegmentsError = function(obj) {
      Util.error('Model.onSegmentError()', obj);
      this.segmentsCompleteWithError = true;
      return this.errorsDetected();
    };

    Model.prototype.onConditionsError = function(obj) {
      Util.error('Model.onConditionsError()', obj);
      this.conditionsCompleteWithError = true;
      return this.errorsDetected();
    };

    Model.prototype.onDealsError = function(obj) {
      Util.error('Model.onDealsError()', obj);
      this.dealsCompleteWithError = true;
      return this.errorsDetected();
    };

    Model.prototype.errorsDetected = function() {
      if ((this.segmentsComplete || this.segmentsCompleteWithError) && (this.conditionsComplete || this.conditionsCompleteWithError) && (this.dealsComplete || this.dealsCompleteWithError) && this.app.dataSource === 'RestThenLocal' && this.first) {
        return this.doTripLocal(this.trip());
      } else {
        return Util.error('Model.errorsDetected access data unable to proceed with trip');
      }
    };

    return Model;

  })();

}).call(this);
