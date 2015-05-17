

class Model

  Util.Export( Model, 'app/Model' )

  constructor:( @app, @stream, @rest ) ->

    @logData   = false
    @Data      = Util.Import( 'app/Data' )  # We occasionally need to key of some static data at this point of the project
    @first     = true                       # Implies we have not acquired enough data to get started
    @needData  = true
    
    # A poor man's chained completion status. 
    # Could be implemented better in the future with a chained Stream or a synched promise chain
    @segmentsComplete          = false
    @conditionsComplete        = false
    @dealsComplete             = false

    # Identifier Arrays
    @blat               = @Data.WestBegLatLon[0]
    @blon               = @Data.WestBegLatLon[1]
    @elat               = @Data.WestEndLatLon[0]
    @elon               = @Data.WestEndLatLon[1]
    @segmentIds         = @Data.WestSegmentIds  # CDOT road speed segment for Demo I70 West from 6th Ave to East Vail
    @segmentIdsReturned = []                    # Accumulate by doSegments()

    # Static data retry
    @rest.retryFroms['Segments']   = true
    @rest.retryFroms['Conditions'] = true
    @rest.retryFroms['Deals']      = true
    
    # Actual Data
    @segments           = {}                   # Road  segment geometry
    @conditions         = []                   # Speed segment with road  and weather (Forecast.io) condtions
    @deals              = []                   # Deals

  ready:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Destination', (object) => @onDestination(object.content) )

  onDestination:( dest ) ->
    Util.dbg( 'Model.onDestination', dest )
    @app.dest            = dest
    initalCompleteStatus = not @app.runRest
    @segmentsComplete    = initalCompleteStatus
    @conditionsComplete  = initalCompleteStatus
    @dealsComplete       = initalCompleteStatus
    if @app.runRest and @first
      @rest.segmentsBySegments(         @segmentIds,  @doSegments   )
      @rest.conditionsBySegments(       @segmentIds,  @doConditions )
      @rest.deals( @app.deals.latLon(), @segmentIds,  @doDeals      )

  # checkComplete is call three times when each status completed is changed
  # goOrNoGo is then only called once
  checkComplete:() =>
    if @segmentsComplete and @conditionsComplete and @dealsComplete and @first
      # Push out all models together on the first full completion
      @stream.push( 'Segments',   @segments,   'Model' )
      @stream.push( 'Conditions', @conditions, 'Model' )
      @stream.push( 'Deals',      @deals,      'Model' )
      @first    = false
      @needData = false
      @app.goOrNoGo( @dest )

  doSegments:( args, obj ) =>
    @segments   = obj.segments
    @segmentIdsReturned = []
    Util.dbg( 'logSegments args', args )
    for own key, seg of @segments
      [id,num]  = @segIdNum( key )  # name:seg[id].name
      @segmentIdsReturned.push( num )
      Util.dbg( 'logSegment', { id:id, num:num, distance:seg.Length, beg:seg.StartMileMarker, end:seg.EndMileMarker, dir:seg.Direction } ) if @logData
    Util.dbg( 'logSegment Ids', @segmentIdsReturned )  if @logData
    @segmentsComplete = true
    @checkComplete()

  doConditions:( args, conditions ) =>
    @conditions          = conditions
    @conditions.segments = args.segments
    Util.dbg( 'logConditions args',  args, conditions.length )
    if @logData
      for c in conditions
        cc = c.Conditions
        weather = cc.Weather
        cc.Weather = {}
        Util.dbg( '  condition id', SegmentId:c.SegmentId, cc )
        Util.dbg( '  weather', weather )
        cc.Weather = weather
    @conditionsComplete = true
    @checkComplete()

  doDeals:( args, deals ) =>
    @deals = deals
    Util.dbg( 'logDeals args',  args )
    if @logData
      Util.dbg( 'logDeals deals', deals.length )
      for d in deals
        dd = d.dealData
        Util.dbg( '  ', { segmentId:dd.segmentId, lat:d.lat, lon:d.lon,  buiness:d.businessName, description:d.name } )
    @dealsComplete = true
    @checkComplete()

  getDealsBySegId:( segId ) ->
    segDeals = []
    for deal in @deals when @dealHasSegId(deal,segId)
      segDeals.push( deal )
    segDeals

  dealHasSegId:( deal, segId ) ->
    for seq in deal.dealData.onSegments
      return true if seq.segmentId is segId
    false

  getSegmentIds:() ->
    # if @segmentIdsReturned.length > 0 then @segmentIdsReturned else @segmentIds
    @segmentIds

  segIdNum:( key ) ->
    id  = ""
    num = 0
    len = key.length
    if len >= 2 and 'id' is key.substring(0,2)
      id    = key
      num   = Util.toInt( key.substring(2,key.length) )
      return [id,num]
    [id,num]

  segIdNum1:( segment ) ->
    id  = ""
    num = 0
    for own key, obj of segment
      len = key.length
      if len >= 2 and 'id' is key.substring(0,2)
        id    = key
        num   = key.substring(0,1)
        return [id,num]
    [id,num]


