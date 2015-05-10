
class Rest

  Util.Export( Rest, 'app/Rest' )

  constructor:( @app, @stream  ) ->
    @baseURL       = "http://104.154.46.117/"
    @segmentURL    = @baseURL + "api/segment"
    @conditionsURL = @baseURL + "api/state"
    @dealsURL      = @baseURL + "api/deals"

  segmentsByLatLon:( slat, slon, elat, elon, callback ) ->
    args = { slat:slat, slon:slon, elat:elat, elon:elon }
    url  = "#{@segmentURL}?start=#{slat},#{slon}&end=#{elat},#{elon}"
    @get( url, 'Segments', args, callback )

  segmentsByPreset:( preset, callback ) ->
    args = { preset:preset }
    url  = "#{@segmentURL}?start=1,1&end=1,1&preset=#{preset}"
    @get( url, 'Segments', args, callback )

  conditionsSegments:( segments, callback ) ->
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

  deals:( segments, lat, lon, callback ) ->
    args = { segments:segments, lat:lat, lon:lon }
    csv  = @toCsv( segments )
    url  = "#{@dealsURL}?segments=#{csv}&loc=#{lat},#{lon}"
    @get( url, 'Deals', args, callback )

  # Needs work
  accept:( userId, dealId, convert ) ->
    args = { userId:userId, dealId:dealId, convert:convert }
    url  = "#{@dealsURL}?userId=#{userId}&_id=#{dealId}&convert=#{convert}"
    @post( url, 'Accept', args, callback )

  get:( url, from, args, callback ) ->
    settings = { url:url, type:'GET', dataType:'json' } # , contentType:'text/plain'
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      @jsonParse( url, from, args, json, callback )
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

  jsonParse:( url, from, args, json, callback ) ->
    try
      objs = JSON.parse(json)
      callback( args, objs )
    catch error
      Util.error( 'Rest.jsonParse()', { url:url, from:from, args:args, error:error } )
      callback( args, json )

  toCsv:( array ) ->
    csv = ''
    for a in array
      csv += a.toString() + ','
    csv.substring( 0, csv.length-1 ) # Trim last comma

  logSegments:( args, segments ) ->
    Util.log( 'logSegments args', args )
    for i in [0...segments.length]
      segId = 'id' + args.segments[i]
      Util.log( 'logSegment', { segId:segId, name:segment.name } )

  logConditions:( args, conditions ) ->
    Util.log( 'logConditions args', args )
    for c in conditions
      cc = c.Conditions
      Util.log( '  condition', { SegmentId:c.SegmentId, TravelTime:cc.TravelTime, AverageSpeed:cc.AverageSpeed } )
      Util.log( '  weather', cc.Weather )

  logDeals:( args, deals ) ->
    Util.log( 'logDeals args', args )
    for d in deals
      dd = deals.DealData
      Util.log( '  ', { buiness:dd.businessName, description:dd.name } )