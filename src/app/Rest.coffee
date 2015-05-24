
class Rest

  Util.Export( Rest, 'app/Rest' )

  constructor:( @app, @stream  ) ->
    @Spatial       = Util.Import( 'app/Spatial' )
    @localURL      = 'http://localhost:63342/Exit-Now-App/data/exit/'
    @baseURL       = "http://104.154.46.117/"
    @jessURL       = "https://exit-now-admin-jesseporter32.c9.io/"
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

  logSegments:( args, obj ) =>
    segments = obj.segments
    Util.dbg( 'logSegments args', args )
    Util.dbg( 'logSegments segs', segments.length )
    for segment in segments
      [id,num] = @segIdNum( segment )
      Util.dbg( 'logSegment', { id:id, num:num, name:segment.name } )

  segIdNum:( segment ) ->
    id  = ""
    num = 0
    for own key, obj of segment
      len = key.length
      if len >= 2 and 'id' is key.substring(0,1)
        id    = key
        num   = key.substring(0,1)
    [id,num]

  logConditions:( args, conditions ) =>
    Util.dbg( 'logConditions args',  args )
    Util.dbg( 'logConditions conds', conditions.length )
    for c in conditions
      cc = c.Conditions
      Util.dbg( '  condition', { SegmentId:c.SegmentId, TravelTime:cc.TravelTime, AverageSpeed:cc.AverageSpeed } )
      Util.dbg( '  weather', cc.Weather )

  logDeals:( args, deals ) =>
    Util.dbg( 'logDeals args',  args )
    Util.dbg( 'logDeals deals', deals.length )
    for d in deals
      dd = d.dealData
      Util.dbg( '  ', { segmentId:dd.segmentId, lat:d.lat, lon:d.lon,  buiness:d.businessName, description:d.name } )

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