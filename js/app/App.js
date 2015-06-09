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
      var Data, DealsUI, DestinationUI, GoUI, Model, NavigateUI, Rest, Simulate, Stream, TripUI, UI;
      this.dataSource = dataSource != null ? dataSource : 'RestThenLocal';
      this.subjectNames = ['Icons', 'Location', 'Screen', 'Source', 'Destination', 'Trip', 'Forecasts'];
      Stream = Util.Import('app/Stream');
      Rest = Util.Import('app/Rest');
      Data = Util.Import('app/Data');
      Model = Util.Import('app/Model');
      Simulate = Util.Import('app/Simulate');
      DestinationUI = Util.Import('ui/DestinationUI');
      GoUI = Util.Import('ui/GoUI');
      TripUI = Util.Import('ui/TripUI');
      DealsUI = Util.Import('ui/DealsUI');
      NavigateUI = Util.Import('ui/NavigateUI');
      UI = Util.Import('ui/UI');
      this.stream = new Stream(this.subjectNames);
      this.rest = new Rest(this.stream);
      this.model = new Model(this.stream, this.rest, this.dataSource);
      this.destinationUI = new DestinationUI(this.stream, this.thresholdUC);
      this.goUI = new GoUI(this.stream);
      this.tripUI = new TripUI(this.stream);
      this.dealsUI = new DealsUI(this.stream);
      this.navigateUI = new NavigateUI(this.stream);
      this.ui = new UI(this.stream, this.destinationUI, this.goUI, this.tripUI, this.dealsUI, this.navigateUI);
      this.ready();
      this.position(this.ui.toScreen('Portrait'));
      this.simulate = new Simulate(this, this.stream);
      if (Util.hasModule('app/App.Test', false)) {
        $('body').css({
          "background-image": "none"
        });
        $('#App').hide();
        this.appTest = new App.Test(this, this.stream, this.simulate, this.rest, this.model);
      }
      if (Util.hasModule('ui/UI.Test', false)) {
        this.uiTest = new UI.Test(this.ui, this.trip, this.destinationUI, this.goUI, this.tripUI, this.navigateUI);
      }
      this.stream.publish('Source', 'Denver');
      this.stream.publish('Destination', 'Copper Mtn');
    }

    App.prototype.ready = function() {
      this.model.ready();
      return this.ui.ready();
    };

    App.prototype.position = function(screen) {
      return this.ui.position(screen);
    };

    return App;

  })();

}).call(this);
