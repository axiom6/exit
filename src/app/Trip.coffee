
class Trip

  Util.Export( Trip, 'app/Trip' )

  constructor:( @app, @stream, @model, @name, @source, @destination  ) ->

    @Data           = Util.Import( 'app/Data'    )
    @Spatial        = Util.Import( 'app/Spatial' )
    @Town           = Util.Import( 'app/Town'    )

    @eta            = -1
    @travelTime     = -1 # Set by travelTime in preset Segments
    @recommendation = '?'
    @preset         = -1

    @segmentIdsAll  = []
    @segmentIds     = []
    @segments       = []
    @conditions     = []
    @deals          = []

    @begTown        = new @Town( @, @source,      'Source'      )
    @endTown        = new @Town( @, @destination, 'Destination' )
    @spatial        = new @Spatial( @app, @stream, @ )
    @direction      = @Spatial.direction( @source, @destination )
    @initByDirection( @direction )

  initByDirection:( direction ) ->
    switch direction
      when 'West'
        @preset        = 2
        @segmentIdsAll = @Data.WestSegmentIds
      when 'East'
        @preset        = 1
        @segmentIdsAll = @Data.EastSegmentIds
      # when 'North'
      # when 'South'
      else
        Util.error( 'Trip unknown direction', direction )

  begMile:() ->
    @begTown.mile

  endMile:() ->
    @endTown.mile

  segInTrip:( seg ) ->
    @spatial.segInTrip( seg )

  segIdNum:( key ) ->
    @spatial.segIdNum( key )

  launch:() ->
    @eta            = @etaFromCondtions()
    @recommendation = @makeRecommendation()
    @spatial.pushLocations()
    @spatial.mileSegs()
    @log( 'Trip.launch()' )

  etaFromCondtions:() =>
    eta = 0
    for condition in @conditions
      eta += Util.toFloat(condition.Conditions.TravelTime)
    eta

  etaHoursMins:() =>
    Util.toInt(@eta/60) + ' Hours ' + @eta%60 + ' Mins'

  makeRecommendation:( ) =>
    if @source is 'NoGo' or @destination is 'NoGo' then 'NoGo' else 'Go'

  getDealsBySegId:( segId ) ->
    segDeals = []
    for deal in @deals when @dealHasSegId( deal, segId )
      segDeals.push( deal )
    segDeals

  dealHasSegId:( deal, segId ) ->
    for seq in deal.dealData.onSegments
      return true if seq.segmentId is segId
    false

  log:( caller ) ->
    Util.dbg( caller, { source:@source, destination:@destination, direction:@direction, preset:@preset, recommendation:@recommendation, eta:@eta, travelTime:@travelTime } )
