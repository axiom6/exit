
class Rest

  Util.Export( Rest, 'app/Rest' )

  constructor:( @app, @stream  ) ->
    @baseURL       = "http://104.154.46.117/"
    @jessURL       = "https://exit-now-admin-jesseporter32.c9.io/"
    @currURL       = @baseURL
    @segmentURL    = @currURL + "api/segment"
    @conditionsURL = @currURL + "api/state"
    @dealsURL      = @currURL + "api/deals"
    @cors          = 'json' # jsonp for different origin

  segmentsByLatLon:( slat, slon, elat, elon, callback ) ->
    args = { slat:slat, slon:slon, elat:elat, elon:elon }
    url  = "#{@segmentURL}?start=#{slat},#{slon}&end=#{elat},#{elon}"
    @get( url, 'Segments', args, callback )

  segmentsByPreset:( preset, callback ) ->
    args = { preset:preset }
    url  = "#{@segmentURL}?start=1,1&end=1,1&preset=#{preset}"
    @get( url, 'Segments', args, callback )

  conditionsBySegments:( segments, callback ) ->
    args = { segments:segments }
    csv  = @toCsv( segments )
    url  = "#{@conditionsURL}?segments=#{csv}"
    @get( url, 'Conditions', args, callback )

  # Date is format like 01/01/2015
  conditionsBySegmentsDate:( segments, date, callback ) ->
    args = { segments:segments, date:date }
    csv  = @toCsv( segments )
    url  = "#{@conditionsURL}?segments=#{csv}&setdate=#{date}"
    @get( url, 'Conditions', args, callback )

  deals:( latlon, segments, callback ) ->
    args = { segments:segments, lat:latlon[0], lon:latlon[1] }
    csv  = @toCsv( segments )
    url  = "#{@dealsURL}?segments=#{csv}&loc=#{latlon[0]},#{latlon[1]}"
    @get( url, 'Deals', args, callback )

  dealsByUrl:( url, callback ) ->
    Util.log( 'isCall', typeof(callback), callback? )
    @get( url, 'Deals', {}, callback )

  # Needs work
  accept:( userId, dealId, convert ) ->
    args = { userId:userId, dealId:dealId, convert:convert }
    url  = "#{@dealsURL}?userId=#{userId}&_id=#{dealId}&convert=#{convert}"
    @post( url, 'Accept', args, callback )

  get:( url, from, args, callback ) ->
    settings = { url:url, type:'GET', dataType:@cors, contentType:'application/json; charset=utf-8' }
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      callback( args, json )
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
      Util.noop( errorThrown )
      Util.error( 'Rest.'+from, { url:url, args:args, text:textStatus } )
    $.ajax( settings )

  # Needs work
  post:( url, from, args, callback ) ->
    settings = { url:url, type:'POST', dataType:'jsonp' } # , contentType:'text/plain'
    settings.success = ( response, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      callback( args, response ) if callback?
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
      Util.noop( errorThrown )
      Util.error( 'Rest.'+from, { url:url, text:textStatus } )
    $.ajax( settings )

  toCsv:( array ) ->
    csv = ''
    for a in array
      csv += a.toString() + ','
    csv.substring( 0, csv.length-1 ) # Trim last comma

  logSegments:( args, obj ) =>
    segments = obj.segments
    Util.log( 'logSegments args', args )
    Util.log( 'logSegments segs', segments.length )
    for segment in segments
      [id,num] = @segIdNum( segment )
      Util.log( 'logSegment', { id:id, num:num, name:segment.name } )

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
    Util.log( 'logConditions args',  args )
    Util.log( 'logConditions conds', conditions.length )
    for c in conditions
      cc = c.Conditions
      Util.log( '  condition', { SegmentId:c.SegmentId, TravelTime:cc.TravelTime, AverageSpeed:cc.AverageSpeed } )
      Util.log( '  weather', cc.Weather )

  logDeals:( args, deals ) =>
    Util.log( 'logDeals args',  args )
    Util.log( 'logDeals deals', deals.length )
    for d in deals
      dd = d.dealData
      Util.log( '  ', { segmentId:dd.segmentId, lat:d.lat, lon:d.lon,  buiness:d.businessName, description:d.name } )

  # Deprecated
  jsonParse:( url, from, args, json, callback ) ->
    json = json.toString().replace(/(\r\n|\n|\r)/gm,"")  # Remove all line breaks
    Util.log( '--------------------------' )
    Util.log( json )
    Util.log( '--------------------------' )
    try
      objs = JSON.parse(json)
      callback( args, objs )
    catch error
      Util.error( 'Rest.jsonParse()', { url:url, from:from, args:args, error:error } )