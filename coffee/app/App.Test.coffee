

class Test

  App = Util.Import( 'app/App' )
  App.Test = Test
  Util.Export( App.Test, 'app/App.Test' )

  constructor:( @app, @stream,  @simulate, @rest, @model ) ->
    Util.log( 'App.Test.constructor' )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Trip', (trip) => @runTrip( trip ) )

  # App - not a lot of testing
  runApp:() ->

  # Stream
  runStream:() ->
    # publish
    # subscribe
    # push
    # getContent
    # createRxJQuery
    # subscribeEvent

  # Simulate  - Drive a lot of functional testing
  @runSimulate:() ->
    # generateLocationsFromMilePosts

  # Rest
  runRest:() ->
    # segmentsFromLocal:(   direction, onSuccess, onError ) ->
    # conditionsFromLocal:( direction, onSuccess, onError ) ->
    # dealsFromLocal:(      direction, onSuccess, onError ) ->
    # milePostsFromLocal:(  onSuccess, onError ) ->
    # forecastsFromLocal:(  onSuccess, onError ) ->
    # segmentsByPreset:( preset, onSuccess, onError  ) ->
    # conditionsBySegments:( segments, onSuccess, onError  ) ->
    # deals:( latlon, segments, onSuccess, onError  ) ->
    # forecastByTown:( name, town, onSuccess, onError ) ->
    # getForecast:( args, onSuccess, onError ) ->
    # forecastByLatLonTime:( lat, lon, time, onSuccess, onError ) ->
    # requestSegmentsBy:( query, onSuccess, onError  ) ->
    # requestConditionsBy:( query, onSuccess, onError  ) ->
    # requestDealsBy:( query, onSuccess, onError  ) ->
    # segmentsByLatLon:( slat, slon, elat, elon, onSuccess, onError ) ->
    # segmentsBySegments:( segments, onSuccess, onError ) ->
    # conditionsBySegmentsDate:( segments, date, onSuccess, onError ) ->
    # dealsByUrl:( url, onSuccess, onError ) ->
    # toCsv:( array ) ->
    # segIdNum:( segment ) ->

  # Model
  runModel:() ->
    # ready:() ->
    # subscribe:() ->
    # resetCompletionStatus:() ->
    # createTrip:( source, destination ) ->
    # doTrip:( trip ) ->
    # doTripLocal:( trip ) ->
    # checkComplete:() =>
    # launchTrip:( trip ) ->
    # restForecasts:( trip ) ->
    # doSegments:( args, segments ) =>
    # doConditions:( args, conditions ) =>
    # doDeals:( args, deals ) =>
    # doMilePosts:( args, milePosts ) =>
    # doForecasts:( args, forecasts ) =>
    # doTownForecast:( args, forecast ) =>
    # onSegmentsError:( obj ) =>
    # onConditionsError:( obj ) =>
    # onDealsError:( obj ) =>
    # onForecastsError:( obj ) =>
    # onTownForecastError:( obj ) =>
    # pushForecastsWhenComplete:( forecasts ) ->
    # onMilePostsError:( obj ) =>
    # errorsDetected:() =>

  # Trip
  runTrip:( trip ) ->
    # initByDirection:( direction ) ->
    # launch:() ->
    # etaFromCondtions:() =>
    # etaHoursMins:() =>
    # makeRecommendation:( ) =>
    # getDealsBySegId:( segId ) ->
    # dealHasSegId:( deal, segId ) ->

  # Spatial
  runSpatial:() ->
    # @direction:( source, destination ) ->
    # subscribe:() =>
    # onLocation:( position ) =>
    # segInTrip:( seg ) ->
    # segIdNum:( key ) ->
    # locationFromPosition:( position ) ->
    # locationFromGeo:( geo ) ->
    # pushLocations:() ->
    # pushNavLocations:() ->
    # pushGeoLocators:() ->
    # pushAddressForLatLon:( latLon ) ->
    # seg:( segNum ) ->
    # milePosts:() ->
    # mileSeg:( seg ) ->
    # mileSegs:() ->
    # mileLatLonFCC:( lat1, lon1, lat2, lon2 ) ->
    # mileLatLonSpherical:( lat1, lon1, lat2, lon2 ) ->
    # mileLatLon2:(lat1, lon1, lat2, lon2 ) ->

