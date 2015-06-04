// Generated by CoffeeScript 1.9.1
(function() {
  var App;

  App = (function() {
    Util.Export(App, 'app/App');

    $(document).ready(function() {
      Util.debug = true;
      Util.init();
      return Util.app = new App('Local');
    });

    function App(dataSource) {
      var AdvisoryUI, Data, DealsUI, DestinationUI, GoUI, Model, NavigateUI, NoGoUI, Rest, RoadUI, Simulate, Stream, ThresholdUI, TripUI, UI, WeatherUI;
      this.dataSource = dataSource != null ? dataSource : 'RestThenLocal';
      this.subjectNames = ['Select', 'Location', 'Orient', 'Source', 'Destination', 'Trip', 'Forecasts', 'App'];
      Stream = Util.Import('app/Stream');
      Rest = Util.Import('app/Rest');
      Data = Util.Import('app/Data');
      Model = Util.Import('app/Model');
      GoUI = Util.Import('ui/GoUI');
      NoGoUI = Util.Import('ui/NoGoUI');
      ThresholdUI = Util.Import('ui/ThresholdUI');
      DestinationUI = Util.Import('ui/DestinationUI');
      RoadUI = Util.Import('ui/RoadUI');
      WeatherUI = Util.Import('ui/WeatherUI');
      AdvisoryUI = Util.Import('ui/AdvisoryUI');
      TripUI = Util.Import('ui/TripUI');
      DealsUI = Util.Import('ui/DealsUI');
      NavigateUI = Util.Import('ui/NavigateUI');
      UI = Util.Import('ui/UI');
      Simulate = Util.Import('app/Simulate');
      this.stream = new Stream(this, this.subjectNames);
      this.rest = new Rest(this, this.stream);
      this.model = new Model(this, this.stream, this.rest);
      this.goUI = new GoUI(this, this.stream);
      this.nogoUI = new NoGoUI(this, this.stream);
      this.thresholdUI = new ThresholdUI(this, this.stream);
      this.destinationUI = new DestinationUI(this, this.stream, this.thresholdUI);
      this.roadUI = new RoadUI(this, this.stream);
      this.weatherUI = new WeatherUI(this, this.stream);
      this.advisoryUI = new AdvisoryUI(this, this.stream);
      this.tripUI = new TripUI(this, this.stream, this.roadUI, this.weatherUI, this.advisoryUI);
      this.dealsUI = new DealsUI(this, this.stream);
      this.navigateUI = new NavigateUI(this, this.stream);
      this.ui = new UI(this, this.stream, this.destinationUI, this.goUI, this.nogoUI, this.tripUI, this.dealsUI, this.navigateUI);
      this.ready();
      this.position();
      this.simulate = new Simulate(this, this.stream);
      if (Util.hasModule('app/App.Test', false)) {
        $('body').css({
          "background-image": "none"
        });
        $('#App').hide();
        this.appTest = new App.Test(this, this.stream, this.simulate, this.rest, this.model);
      }
      if (Util.hasModule('ui/UI.Test', false)) {
        this.uiTest = new UI.Test(this.ui, this.adivsoryUI, this.dealsUI, this.destinationUI, this.driveBarUI, this.goUI, this.noGoUI, this.roadUI, this.thresholdUI, this.trip, this.weatherUI, this.navigateUI);
      }
      this.stream.publish('Source', 'Denver');
      this.stream.publish('Destination', 'Vail');
    }

    App.prototype.ready = function() {
      this.model.ready();
      this.destinationUI.ready();
      this.goUI.ready();
      this.nogoUI.ready();
      this.tripUI.ready();
      this.dealsUI.ready();
      this.navigateUI.ready();
      return this.ui.ready();
    };

    App.prototype.position = function() {
      this.destinationUI.position();
      this.goUI.position();
      this.nogoUI.position();
      this.tripUI.position();
      this.dealsUI.position();
      return this.navigateUI.position();
    };

    App.prototype.width = function() {
      return this.ui.width();
    };

    App.prototype.height = function() {
      return this.ui.height();
    };

    return App;

  })();

}).call(this);
