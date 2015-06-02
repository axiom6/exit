// Generated by CoffeeScript 1.9.1
(function() {
  var Trip,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Trip = (function() {
    Util.Export(Trip, 'test/app/Trip');

    function Trip(app, stream, model, name, source, destination) {
      this.app = app;
      this.stream = stream;
      this.model = model;
      this.name = name;
      this.source = source;
      this.destination = destination;
      this.makeRecommendation = bind(this.makeRecommendation, this);
      this.etaHoursMins = bind(this.etaHoursMins, this);
      this.etaFromCondtions = bind(this.etaFromCondtions, this);
    }

    Trip.prototype.initByDirection = function(direction) {
      switch (direction) {
        case 'West':
          this.preset = 2;
          return this.segmentIdsAll = this.Data.WestSegmentIds;
        case 'East':
          this.preset = 1;
          return this.segmentIdsAll = this.Data.EastSegmentIds;
        default:
          return Util.error('Trip unknown direction', direction);
      }
    };

    Trip.prototype.begMile = function() {
      return this.begTown.mile;
    };

    Trip.prototype.endMile = function() {
      return this.endTown.mile;
    };

    Trip.prototype.segInTrip = function(seg) {
      return this.spatial.segInTrip(seg);
    };

    Trip.prototype.segIdNum = function(key) {
      return this.spatial.segIdNum(key);
    };

    Trip.prototype.launch = function() {
      this.eta = this.etaFromCondtions();
      this.recommendation = this.makeRecommendation();
      return this.log('Trip.launch()');
    };

    Trip.prototype.etaFromCondtions = function() {
      var condition, eta, i, len, ref;
      eta = 0;
      ref = this.conditions;
      for (i = 0, len = ref.length; i < len; i++) {
        condition = ref[i];
        eta += Util.toFloat(condition.Conditions.TravelTime);
      }
      return eta;
    };

    Trip.prototype.etaHoursMins = function() {
      return Util.toInt(this.eta / 60) + ' Hours ' + this.eta % 60 + ' Mins';
    };

    Trip.prototype.makeRecommendation = function() {
      if (this.source === 'NoGo' || this.destination === 'NoGo') {
        return 'NoGo';
      } else {
        return 'Go';
      }
    };

    Trip.prototype.getDealsBySegId = function(segId) {
      var deal, i, len, ref, segDeals;
      segDeals = [];
      ref = this.deals;
      for (i = 0, len = ref.length; i < len; i++) {
        deal = ref[i];
        if (this.dealHasSegId(deal, segId)) {
          segDeals.push(deal);
        }
      }
      return segDeals;
    };

    Trip.prototype.dealHasSegId = function(deal, segId) {
      var i, len, ref, seq;
      ref = deal.dealData.onSegments;
      for (i = 0, len = ref.length; i < len; i++) {
        seq = ref[i];
        if (seq.segmentId === segId) {
          return true;
        }
      }
      return false;
    };

    Trip.prototype.log = function(caller) {
      return Util.dbg(caller, {
        source: this.source,
        destination: this.destination,
        direction: this.direction,
        preset: this.preset,
        recommendation: this.recommendation,
        eta: this.eta,
        travelTime: this.travelTime
      });
    };

    return Trip;

  })();

}).call(this);
