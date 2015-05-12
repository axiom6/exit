// Generated by CoffeeScript 1.9.1
(function() {
  var App;

  App = (function() {
    Util.Export(App, 'app/App');

    $(document).ready(function() {
      Util.init();
      return Util.app = new App(false, false, false);
    });

    function App(runRest, runSimulate, runTest) {
      var Advisory, Data, Deals, Destination, Go, Navigate, NoGo, Rest, Road, Simulate, Stream, Test, Threshold, Trip, UI, Weather;
      this.runRest = runRest != null ? runRest : true;
      this.runSimulate = runSimulate != null ? runSimulate : false;
      this.runTest = runTest != null ? runTest : false;
      this.dest = '';
      this.segmentsComplete = false;
      this.conditionsComplete = false;
      this.dealsComplete = false;
      this.direction = 'West';
      Stream = Util.Import('app/Stream');
      Rest = Util.Import('app/Rest');
      Data = Util.Import('app/Data');
      Go = Util.Import('ui/Go');
      NoGo = Util.Import('ui/NoGo');
      Threshold = Util.Import('ui/Threshold');
      Destination = Util.Import('ui/Destination');
      Road = Util.Import('ui/Road');
      Weather = Util.Import('ui/Weather');
      Advisory = Util.Import('ui/Advisory');
      Trip = Util.Import('ui/Trip');
      Deals = Util.Import('ui/Deals');
      Navigate = Util.Import('ui/Navigate');
      UI = Util.Import('ui/UI');
      Simulate = Util.Import('app/Simulate');
      Test = Util.Import('app/Test');
      this.stream = new Stream(this);
      this.rest = new Rest(this, this.stream);
      this.go = new Go(this, this.stream);
      this.nogo = new NoGo(this, this.stream);
      this.threshold = new Threshold(this, this.stream);
      this.destination = new Destination(this, this.stream, this.go, this.nogo, this.threshold);
      this.road = new Road(this, this.stream);
      this.weather = new Weather(this, this.stream);
      this.advisory = new Advisory(this, this.stream);
      this.trip = new Trip(this, this.stream, this.road, this.weather, this.advisory);
      this.deals = new Deals(this, this.stream);
      this.navigate = new Navigate(this, this.stream);
      this.ui = new UI(this, this.stream, this.destination, this.trip, this.deals, this.navigate);
      this.ready();
      this.postReady();
      if (this.runSimulate) {
        this.simulate = new Simulate(this, this.stream);
      }
      if (this.runTest) {
        this.test = new Test(this, this.stream);
      }
    }

    App.prototype.ready = function() {
      this.destination.ready();
      this.trip.ready();
      this.deals.ready();
      this.navigate.ready();
      return this.ui.ready();
    };

    App.prototype.postReady = function() {
      this.destination.postReady();
      return this.trip.postReady();
    };

    App.prototype.width = function() {
      return this.ui.width();
    };

    App.prototype.height = function() {
      return this.ui.height();
    };

    App.prototype.id = function(name, type) {
      if (type == null) {
        type = '';
      }
      return name + type;
    };

    App.prototype.css = function(name, type) {
      if (type == null) {
        type = '';
      }
      return name + type;
    };

    App.prototype.icon = function(name, type, fa) {
      return name + type + ' fa fa-' + fa;
    };

    App.prototype.svgId = function(name, type, svgType) {
      return this.id(name, type + svgType);
    };

    App.prototype.doDestination = function(dest) {
      var initalCompleteStatus;
      this.dest = dest;
      initalCompleteStatus = !this.runRest;
      this.segmentsComplete = initalCompleteStatus;
      this.conditionsComplete = initalCompleteStatus;
      this.dealsComplete = initalCompleteStatus;
      if (this.runRest) {
        this.rest.segmentsByPreset(1, this.trip.doSegments);
        this.rest.conditionsBySegments(this.trip.condSegs(), this.trip.doConditions);
        this.rest.deals(this.deals.latLon(), this.deals.segments(), this.deals.doDeals);
      }
      return this.checkComplete();
    };

    App.prototype.checkComplete = function() {
      if (this.segmentsComplete && this.conditionsComplete && this.dealsComplete) {
        return this.goOrNoGo(this.dest);
      }
    };

    App.prototype.goOrNoGo = function(dest) {
      this.trip.createDriveBars();
      if (dest === 'Vail' || dest === 'Winter Park') {
        return this.destination.nogo.show();
      } else {
        return this.destination.go.show();
      }
    };

    return App;

  })();

}).call(this);
