// Generated by CoffeeScript 1.9.1
(function() {
  var App;

  App = (function() {
    Util.Export(App, 'app/App');

    $(document).ready(function() {
      Util.init();
      Util.app = new App(true, false);
      Util.log('App Created');
    });

    function App(runSimulate, runTest) {
      var Advisory, Deals, Destination, Go, Navigate, NoGo, Road, Simulate, Stream, Test, Threshold, Trip, UI, Weather;
      if (runSimulate == null) {
        runSimulate = false;
      }
      if (runTest == null) {
        runTest = false;
      }
      Stream = Util.Import('app/Stream');
      if (runSimulate) {
        Simulate = Util.Import('app/Simulate');
      }
      if (runTest) {
        Test = Util.Import('app/Test');
      }
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
      this.stream = new Stream(this);
      if (runSimulate) {
        this.simulate = new Simulate(this);
      }
      if (runTest) {
        this.test = new Test(this);
      }
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
    }

    App.prototype.ready = function() {
      this.destination.ready();
      this.advisory.ready();
      this.go.ready();
      this.road.ready();
      this.weather.ready();
      this.trip.ready();
      this.deals.ready();
      this.navigate.ready();
      return this.ui.ready();
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

    return App;

  })();

}).call(this);
