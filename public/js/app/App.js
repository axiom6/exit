var App;

import Util from '../util/Util.js';

import Stream from '../util/Stream.js';

import Rest from '../app/Rest.js';

import Data from '../app/Data.js';

import Model from '../app/Model.js';

import Simulate from '../app/Simulate.js';

import DestinationUI from '../ui/DestinationUI.js';

import GoUI from '../ui/GoUI.js';

import TripUI from '../ui/TripUI.js';

import DealsUI from '../ui/DealsUI.js';

import NavigateUI from '../ui/NavigateUI.js';

import UI from '../ui/UI.js';

App = (function() {
  class App {
    constructor(dataSource = 'RestThenLocal') {
      var logSpec;
      this.dataSource = dataSource;
      this.subjects = ['Icons', 'Location', 'Screen', 'Source', 'Destination', 'Trip', 'Forecasts'];
      // Instantiate main App classes
      logSpec = {
        subscribe: false,
        publish: false,
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

  // This kicks off everything
  $(document).ready(function() {
    Util.debug = true; // Swithes  Util.dbg() debugging on or off
    Util.init();
    return Util.app = new App('Local'); // @dataSource = 'Rest', 'RestThenLocal', 'Local', 'LocalForecasts'
  });

  return App;

}).call(this);

export default App;
