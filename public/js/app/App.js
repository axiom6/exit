(function() {
  var App;

  App = (function() {
    class App {
      constructor(dataSource = 'RestThenLocal') {
        var Data, DealsUI, DestinationUI, GoUI, Model, NavigateUI, Rest, Simulate, Stream, TripUI, UI, logSpec;
        this.dataSource = dataSource;
        this.subjects = ['Icons', 'Location', 'Screen', 'Source', 'Destination', 'Trip', 'Forecasts'];
        // Import Classes
        Stream = Util.Import('util/Stream');
        Rest = Util.Import('app/Rest');
        Data = Util.Import('app/Data'); // Static class with no need to instaciate
        Model = Util.Import('app/Model');
        Simulate = Util.Import('app/Simulate');
        DestinationUI = Util.Import('ui/DestinationUI');
        GoUI = Util.Import('ui/GoUI');
        TripUI = Util.Import('ui/TripUI');
        DealsUI = Util.Import('ui/DealsUI');
        NavigateUI = Util.Import('ui/NavigateUI');
        UI = Util.Import('ui/UI');
        // Instantiate main App classes
        logSpec = {
          subscribe: false,
          publish: true,
          complete: false,
          subjects: this.subjects
        };
        this.stream = new Stream(this.subjects, logSpec);
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
        // Run simulations and test if test modules presents
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
        // Jumpstart App
        this.stream.publish('Source', 'Denver');
        this.stream.publish('Destination', 'Vail');
        Util.noop(Data, this.appTest, this.uiTest);
      }

      ready() {
        this.model.ready();
        return this.ui.ready();
      }

      position(screen) {
        return this.ui.position(screen);
      }

    };

    Util.Export(App, 'app/App');

    // This kicks off everything
    $(document).ready(function() {
      Util.debug = true; // Swithes  Util.dbg() debugging on or off
      Util.init();
      return Util.app = new App('Local'); // @dataSource = 'Rest', 'RestThenLocal', 'Local', 'LocalForecasts'
    });

    return App;

  }).call(this);

}).call(this);
