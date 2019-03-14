(function() {
  var Test;

  Test = (function() {
    var UI;

    class Test {
      constructor(ui, trip, destinationUI, goUI, noGoUI, tripUI, navigateUI) {
        this.ui = ui;
        this.trip = trip;
        this.destinationUI = destinationUI;
        this.goUI = goUI;
        this.noGoUI = noGoUI;
        this.tripUI = tripUI;
        this.navigateUI = navigateUI;
        Util.log('UI.Test.constructor');
      }

    };

    UI = Util.Import('ui/UI');

    UI.Test = Test;

    Util.Export(UI.Test, 'ui/UI.Test');

    return Test;

  }).call(this);

  // Trip
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// UI
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->
// orient:( orientation ) ->
// changeRecommendation:( recommendation ) ->
// select:( name ) =>
// width
// height

// DestinationUI
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// GoUI
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// TripUI
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// DealsUI
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// NavigateUI
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// ThresholdUC
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// BannerUC
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// BannerUC
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// WeatherUC
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->
// createForecastHtml:( name, w ) ->
// updateForecastHtml:( name, w ) ->

// AdivsoryUC
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->

// DriveBarUC
// html:() ->
// ready:() ->
// $ready;() ->
// position:() ->
// subscribe:() ->
// onLocation:( location ) ->
// layout:( orientation ) ->
// onTrip:( trip ) =>
// createSvg:( $, htmlId, name, ext, width, height, barTop ) ->
// createBars:( trip ) ->
// createTravelTime:( trip, g, x, y, w, h ) ->
// fillCondition:( segId, conditions ) ->
// fillSpeed:( speed ) ->
// updateFills:( trip ) ->
// rect:( trip, g, seg, segId, x0, y0, w, h, fill, stroke, thick, text ) ->
// onClick
// doSeqmentDeals:( trip, segId, mile ) ->
// updateRectFill:( segId, fill ) ->
// layout2:( orientation ) -> # Transform version
// svgWidth:()   -> if @orientation is 'Portrait' then @app.width()  * 0.92 else @app.height()
// svgHeight:()  -> if @orientation is 'Portrait' then @app.height() * 0.33 else @app.width() * 0.50
// barHeight:()  -> @svgHeight() * 0.33
// barTop:()     -> @svgHeight() * 0.50

}).call(this);
