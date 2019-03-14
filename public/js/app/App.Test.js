(function() {
  var Test;

  Test = (function() {
    var App;

    class Test {
      constructor(app, stream, simulate, rest, model) {
        this.app = app;
        this.stream = stream;
        this.simulate = simulate;
        this.rest = rest;
        this.model = model;
        Util.log('App.Test.constructor');
        this.subscribe();
      }

      subscribe() {
        return this.stream.subscribe('Trip', 'App.Test', (trip) => {
          return this.runTrip(trip);
        });
      }

      // App - not a lot of testing
      runApp() {}

      // Stream
      runStream() {}

      // publish
      // subscribe
      // push
      // getContent
      // createRxJQuery
      // subscribeEvent

      // Simulate  - Drive a lot of functional testing
      static runSimulate() {}

      // generateLocationsFromMilePosts

      // Rest
      runRest() {}

      // segmentsFromLocal:(   direction, onSuccess, onError ) ->
      // conditionsFromLocal:( direction, onSuccess, onError ) ->
      // dealsFromLocal:(      direction, onSuccess, onError ) ->
      // milePostsFromLocal:(  onSuccess, onError ) ->
      // forecastsFromLocal:(  onSuccess, onError ) ->
      // segmentsByPreset:( preset, onSuccess, onError  ) ->
      // conditionsBySegments:( segments, onSuccess, onError  ) ->
      // deals:( latlon, segments, onSuccess, onError  ) ->
      // forecastByTown:( name, town, onSuccess, onError ) ->
      // getForecast:( args, onSuccess, onError ) ->
      // forecastByLatLonTime:( lat, lon, time, onSuccess, onError ) ->
      // requestSegmentsBy:( query, onSuccess, onError  ) ->
      // requestConditionsBy:( query, onSuccess, onError  ) ->
      // requestDealsBy:( query, onSuccess, onError  ) ->
      // segmentsByLatLon:( slat, slon, elat, elon, onSuccess, onError ) ->
      // segmentsBySegments:( segments, onSuccess, onError ) ->
      // conditionsBySegmentsDate:( segments, date, onSuccess, onError ) ->
      // dealsByUrl:( url, onSuccess, onError ) ->
      // toCsv:( array ) ->
      // segIdNum:( segment ) ->

      // Model
      runModel() {}

      // ready:() ->
      // subscribe:() ->
      // resetCompletionStatus:() ->
      // createTrip:( source, destination ) ->
      // doTrip:( trip ) ->
      // doTripLocal:( trip ) ->
      // checkComplete:() =>
      // launchTrip:( trip ) ->
      // restForecasts:( trip ) ->
      // doSegments:( args, segments ) =>
      // doConditions:( args, conditions ) =>
      // doDeals:( args, deals ) =>
      // doMilePosts:( args, milePosts ) =>
      // doForecasts:( args, forecasts ) =>
      // doTownForecast:( args, forecast ) =>
      // onSegmentsError:( obj ) =>
      // onConditionsError:( obj ) =>
      // onDealsError:( obj ) =>
      // onForecastsError:( obj ) =>
      // onTownForecastError:( obj ) =>
      // pushForecastsWhenComplete:( forecasts ) ->
      // onMilePostsError:( obj ) =>
      // errorsDetected:() =>

      // Trip
      runTrip(trip) {}

      // initByDirection:( direction ) ->
      // launch:() ->
      // etaFromCondtions:() =>
      // etaHoursMins:() =>
      // makeRecommendation:( ) =>
      // getDealsBySegId:( segId ) ->
      // dealHasSegId:( deal, segId ) ->

      // Spatial
      runSpatial() {}

    };

    App = Util.Import('app/App');

    App.Test = Test;

    Util.Export(App.Test, 'app/App.Test');

    return Test;

  }).call(this);

  // @direction:( source, destination ) ->
// subscribe:() =>
// onLocation:( position ) =>
// segInTrip:( seg ) ->
// segIdNum:( key ) ->
// locationFromPosition:( position ) ->
// locationFromGeo:( geo ) ->
// pushLocations:() ->
// pushNavLocations:() ->
// pushGeoLocators:() ->
// pushAddressForLatLon:( latLon ) ->
// seg:( segNum ) ->
// milePosts:() ->
// mileSeg:( seg ) ->
// mileSegs:() ->
// mileLatLonFCC:( lat1, lon1, lat2, lon2 ) ->
// mileLatLonSpherical:( lat1, lon1, lat2, lon2 ) ->
// mileLatLon2:(lat1, lon1, lat2, lon2 ) ->

}).call(this);
