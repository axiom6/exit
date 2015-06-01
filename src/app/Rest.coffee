
class Rest

  Util.Export( Rest, 'app/Rest' )

  constructor:( @app, @stream  ) ->
    @Spatial       = Util.Import( 'app/Spatial' )
    @localURL      = 'http://localhost:63342/Exit-Now-App/data/exit/'
    @baseURL       = "http://104.154.46.117/"
    @jessURL       = "https://exit-now-admin-jesseporter32.c9.io/"
    @forecastIoURL = "https://api.forecast.io/forecast/"
    @forecastIoKey = '2c52a8974f127eee9de82ea06aadc7fb'
    @currURL       = @baseURL
    @segmentURL    = @currURL + "api/segment"
    @conditionsURL = @currURL + "api/state"
    @dealsURL      = @currURL + "api/deals"
    @cors          = 'json' # jsonp for different origin
    @subscribe()

  subscribe:() ->
    #@stream.subscribe( 'RequestSegments',     (object) =>  @requestSegmentsBy(   object.content ) )
    #@stream.subscribe( 'RequestConditionsBy', (object) =>  @requestConditionsBy( object.content ) )
    #@stream.subscribe( 'RequestDealsBy',      (object) =>  @requestDealsBy(      object.content ) )
    
  segmentsFromLocal:( direction, onSuccess, onError ) ->
    url  = "#{@localURL}Segments#{direction}.json"
    args = { url:url, direction:direction }
    @get( url, 'Segments', args, onSuccess, onError  )
    return

  conditionsFromLocal:( direction, onSuccess, onError ) ->
    url  = "#{@localURL}Conditions#{direction}.json"
    args = { url:url, direction:direction }
    @get( url, 'Conditions', args, onSuccess, onError  )
    return

  # At this point Deals are not queurid by direction
  dealsFromLocal:( direction, onSuccess, onError ) ->
    url  = "#{@localURL}Deals.json"
    args = { url:url, direction:direction }
    @get( url, 'Deals', args, onSuccess, onError )
    return

  milePostsFromLocal:( onSuccess, onError ) ->
    url  = "#{@localURL}I70Mileposts.json"
    args = { url:url }
    @get( url, 'Mileposts', args, onSuccess, onError )
    return

  # Like the other fromLocal methods this is plural,
  #   because it gets all the forecasts for all the towns
  forecastsFromLocal:( onSuccess, onError ) ->
    url  = "#{@localURL}Forecasts.json"
    args = { url:url }
    @get( url, 'Forecasts', args, onSuccess, onError )
    return

  segmentsByPreset:( preset, onSuccess, onError  ) ->
    args = { preset:preset }
    url  = "#{@segmentURL}?start=1,1&end=1,1&preset=#{preset}"
    @get( url, 'Segments', args, onSuccess, onError )
    return

  conditionsBySegments:( segments, onSuccess, onError  ) ->
    args = { segments:segments }
    csv  = @toCsv( segments )
    url  = "#{@conditionsURL}?segments=#{csv}"
    @get( url, 'Conditions', args, onSuccess, onError )
    return

  deals:( latlon, segments, onSuccess, onError  ) ->
    args = { segments:segments, lat:latlon[0], lon:latlon[1] }
    csv  = @toCsv( segments )
    url  = "#{@dealsURL}?segments=#{csv}&loc=#{latlon[0]},#{latlon[1]}"
    @get( url, 'Deals', args, onSuccess, onError )
    return

  # Unlike the other rest methods this is singular,
  #   because it has to be called for each towm with its town.lon town.lat and town.time
  forecastByTown:( name, town, onSuccess, onError ) ->
    args = {  name:name, town:town, lat:town.lat, lon:town.lon, time:town.time, hms:Util.toHMS(town.time) }
    #Util.dbg( 'Rest.forecastByTown', args )
    #url  = """#{@forecastIoURL}#{@forecastIoKey}}/#{town.lat},#{town.lon}"""  # ,#{town.time}
    #@get( url, 'Forecast', args, onSuccess, onError )
    @getForecast( args, onSuccess, onError )
    return

  getForecast:( args, onSuccess, onError ) ->
    town = args.town
    key = '2c52a8974f127eee9de82ea06aadc7fb'
    url = """https://api.forecast.io/forecast/#{key}/#{town.lat},#{town.lon}""" # ,#{town.isoDateTime}
    settings = { url:url, type:'GET', dataType:'jsonp', contentType:'text/plain' }
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      onSuccess( args, json )
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
      Util.noop( errorThrown )
      onError( { url:url, args:args, from:'Forecast' } )
    $.ajax( settings )


  # Unlike the other rest methods this is singular,
  #   because it has to be called for each lon lat and time
  forecastByLatLonTime:( lat, lon, time, onSuccess, onError ) ->
    args = { lat:lat, lon:lon, time:Util.toTime(time) }
    url  = """#{@forecastIoURL}#{@forecastIoKey}}/#{lat},#{lon},#{time}"""
    @get( url, 'Forecast', args, onSuccess, onError )
    return

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
    args = { slat:slat, slon:slon, elat:elat, elon:elon }
    url  = "#{@segmentURL}?start=#{slat},#{slon}&end=#{elat},#{elon}"
    @get( url, 'Segments', args, onSuccess, onError )
    return

  segmentsBySegments:( segments, onSuccess, onError ) ->
    args = { segments:segments }
    csv  = @toCsv( segments )
    url  = "#{@segmentURL}?segments=#{csv}"
    @get( url, 'Segments', args, onSuccess, onError )
    return

  # Date is format like 01/01/2015
  conditionsBySegmentsDate:( segments, date, onSuccess, onError ) ->
    args = { segments:segments, date:date }
    csv  = @toCsv( segments )
    url  = "#{@conditionsURL}?segments=#{csv}&setdate=#{date}"
    @get( url, 'Conditions', args, onSuccess, onError )
    return

  dealsByUrl:( url, onSuccess, onError ) ->
    Util.dbg( 'isCall', typeof(onSuccess), onSuccess? )
    @get( url, 'Deals', {}, onSuccess, onError  )
    return

  # Needs work
  accept:( userId, dealId, convert, onSuccess, onError ) ->
    args = { userId:userId, dealId:dealId, convert:convert }
    url  = "#{@dealsURL}?userId=#{userId}&_id=#{dealId}&convert=#{convert}"
    @post( url, 'Accept', args, onSuccess, onError )
    return

  get:( url, from, args, onSuccess, onError ) ->
    settings = { url:url, type:'GET', dataType:@cors, contentType:'application/json; charset=utf-8' }
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      onSuccess( args, json )
      return
    settings.error = ( jqXHR, textStatus, errorThrown ) =>
      Util.noop( errorThrown )
      Util.error( 'Rest.'+from, { url:url, args:args, text:textStatus } )
      onError( { url:url, args:args, from:from } )
      return
    $.ajax( settings )
    return

  # Needs work
  post:( url, from, args, onSuccess, onError ) ->
    settings = { url:url, type:'POST', dataType:'jsonp' } # , contentType:'text/plain'
    settings.success = ( response, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      onSuccess( args, response ) if onSuccess?
    settings.error = ( jqXHR, textStatus, errorThrown ) =>
      Util.noop( errorThrown )
      Util.error( 'Rest.'+from, { url:url, text:textStatus } )
      onError( { url:url, args:args, from:from } )
    $.ajax( settings )
    return

  toCsv:( array ) ->
    csv = ''
    for a in array
      csv += a.toString() + ','
    csv.substring( 0, csv.length-1 ) # Trim last comma

  segIdNum:( segment ) ->
    id  = ""
    num = 0
    for own key, obj of segment
      len = key.length
      if len >= 2 and 'id' is key.substring(0,1)
        id    = key
        num   = key.substring(0,1)
    [id,num]

  logSegments:( args, obj ) =>
    args.size = segments.length
    segments = obj.segments
    Util.dbg( 'logSegments args', args )
    for segment in segments
      [id,num] = @segIdNum( segment )
      Util.dbg( 'logSegment', { id:id, num:num, name:segment.name } )

  logConditions:( args, conditions ) =>
    args.size = conditions.length
    Util.dbg( 'logConditions args',  args )
    Util.dbg( 'logConditions conds',  )
    for c in conditions
      cc = c['Conditions']
      Util.dbg( '  condition', { SegmentId:c['SegmentId'], TravelTime:cc['TravelTime'], AverageSpeed:cc['AverageSpeed'] } )
      Util.dbg( '  weather', cc['Weather'] )

  logDeals:( args, deals ) =>
    args.size = deals.length
    Util.dbg( 'logDeals args',  args )
    for d in deals
      dd = d['dealData']
      Util.dbg( '  ', { segmentId:dd['segmentId'], lat:d['lat'], lon:d['lon'],  buiness:d['businessName'], description:d['name'] } )

  logMileposts:( args, mileposts ) =>
    args.size = mileposts.length
    Util.dbg( 'logMileposts args',  args )
    for milepost in mileposts
      Util.dbg( '  ', milepost )

  logForecasts:( args, forecasts ) =>
    args.size = forecasts.length
    Util.dbg( 'logForecasts args',  args )
    for forecast in forecasts
      Util.dbg( '  ', forecast )

  # Deprecated
  jsonParse:( url, from, args, json, onSuccess ) ->
    json = json.toString().replace(/(\r\n|\n|\r)/gm,"")  # Remove all line breaks
    Util.dbg( '--------------------------' )
    Util.dbg( json )
    Util.dbg( '--------------------------' )
    try
      objs = JSON.parse(json)
      onSuccess( args, objs )
    catch error
      Util.error( 'Rest.jsonParse()', { url:url, from:from, args:args, error:error } )

  ###
   curl 'https://api.forecast.io/forecast/2c52a8974f127eee9de82ea06aadc7fb/39.759558,-105.654065?callback=jQuery21308299770827870816_1433124323587&_=1433124323588'

  # """https://api.forecast.io/forecast/#{key}/#{loc.lat},#{loc.lon},#{loc.time}"""
  ###