

class Rest

  Util.Export( Rest, 'test/app/Rest' )

  constructor:( @app, @stream  ) ->

  segmentsFromLocal:(   direction, onSuccess, onError ) ->
  conditionsFromLocal:( direction, onSuccess, onError ) ->
  dealsFromLocal:(      direction, onSuccess, onError ) ->
  milePostsFromLocal:(  onSuccess, onError ) ->
  forecastsFromLocal:(  onSuccess, onError ) ->

  segmentsByPreset:( preset, onSuccess, onError  ) ->

  conditionsBySegments:( segments, onSuccess, onError  ) ->

  deals:( latlon, segments, onSuccess, onError  ) ->
  forecastByTown:( name, town, onSuccess, onError ) ->

  getForecast:( args, onSuccess, onError ) ->

  forecastByLatLonTime:( lat, lon, time, onSuccess, onError ) ->

  requestSegmentsBy:( query, onSuccess, onError  ) ->
    Util.noop( 'Stream.requestSegmentsBy', query, onSuccess, onError )
    return

  requestConditionsBy:( query, onSuccess, onError  ) ->
    Util.noop( 'Stream.requestConditionsBy', query, onSuccess, onError )
    return

  requestDealsBy:( query, onSuccess, onError  ) ->
    Util.noop( 'Stream.requestDealsBy', query, onSuccess, onError )
    return

  segmentsByLatLon:( slat, slon, elat, elon, onSuccess, onError ) ->

  segmentsBySegments:( segments, onSuccess, onError ) ->

  conditionsBySegmentsDate:( segments, date, onSuccess, onError ) ->


  dealsByUrl:( url, onSuccess, onError ) ->

  toCsv:( array ) ->

  segIdNum:( segment ) ->
