
class Rest

  Util.Export( Rest, 'app/Rest' )

  constructor:( @app, @stream  ) ->
    @baseURL       = "http://104.154.46.117/"
    @segmentURL    = @baseURL + "api/segment"
    @conditionsURL = @baseURL + "api/state"
    @dealsURL      = @baseURL + "api/deals"

  segmentsByLatLon:( slat, slon, elat, elon, callback ) ->
    url = "#{@segmentURL}?start=#{slat},#{slon}&end=#{elat},#{elon}"
    @get( url, 'Segments', callback )

  segmentsByPreset:( preset, callback ) ->
    url = "#{@segmentURL}?start=1,1&end=1,1&preset=#{preset}"
    @get( url, 'Segments', callback )

  conditionsSegments:( segments, callback ) ->
    csv = @toCsv( segments )
    url = "#{@conditionsURL}?segments=#{csv}"
    @get( url, 'Conditions', callback )

  # Date is format like 01/01/2015
  conditionsBySegmentsDate:( segments, date, callback ) ->
    csv = @toCsv( segments )
    url = "#{@conditionsURL}?segments=#{csv}&setdate=#{date}"
    @get( url, 'Conditions', callback )

  deals:( segments, lat, lon, callback ) ->
    url = "#{@dealsURL}?segments=#{csv}&loc=#{lat},#{lon}"
    @get( url, 'Deals', callback )

  # Needs work
  accept:( userId, dealId, convert ) ->
    url = "#{@dealsURL}?userId=#{userId}&_id=#{dealId}&convert=#{convert}"
    @post( url, 'Accept', callback )

  get:( url, from, callback ) ->
    settings = { url:url, type:'GET', dataType:'jsonp', contentType:'text/plain' }
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      callback( json )
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
      Util.noop( errorThrown )
      Util.error( 'Rest.'+from, { url:url, text:textStatus } )
    $.ajax( settings )

  # Need input from Jesse
  post:( url, from, callback ) ->
    settings = { url:url, type:'POST', dataType:'jsonp', contentType:'text/plain' }
    settings.success = ( response, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      callback( response ) if callback?
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
      Util.noop( errorThrown )
      Util.error( 'Rest.'+from, { url:url, text:textStatus } )
    $.ajax( settings )

  toCsv:( array ) ->
    csv = ''
    for a in array
      csv += a.toString() + ','
    csv.substring( 0, csv.length-1 ) # Trim last comma