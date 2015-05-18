

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

  ready:() ->
    @subscribe()

  subscribe:() ->
    # @stream.subscribe( 'Trip', (object) => @onTrip(object.content) )

# The Trip parameter calculation process here needs to be refactored
  createTrip:( source, destination ) ->
    direction = @directionSourceDestination( source, destination )
    preset     = 2
    begSeg     = @segWest( source      )
    endSeg     = @segWest( destination )
    segmentIds = @Data.WestSegmentIds
    if direction is 'East'
      preset     = 1
      begSeg     = @segEast( source      )
      endSeg     = @segEast( destination )
      segmentIds = @Data.EastSegmentIds
    trip = { source:source, destination:destination, direction:direction, preset:preset, begSeg:begSeg, endSeg:endSeg, segmentIds:segmentIds, recommendation:'?', eta:141 }
    @doTrip( trip )
    return

  doTrip:( trip ) ->
    Util.dbg( 'Model.doTrip', trip )
    @trip = trip
    initalCompleteStatus = not @app.runRest
    @segmentsComplete    = initalCompleteStatus
    @conditionsComplete  = initalCompleteStatus
    @dealsComplete       = initalCompleteStatus
    if @app.runRest and @first
      @rest.segmentsByPreset(           trip.preset,      @doSegments   )
      @rest.conditionsBySegments(       trip.segmentIds,  @doConditions )
      @rest.deals( @app.deals.latLon(), trip.segmentIds,  @doDeals      )

  # checkComplete is call three times when each status completed is changed
  # goOrNoGo is then only called once
  checkComplete:() =>
    if @segmentsComplete and @conditionsComplete and @dealsComplete and @first
      # Push out all models together on the first full completion
      # @stream.push( 'Segments',   @trip.segments,   'Model' )
      # @stream.push( 'Conditions', @trip.conditions, 'Model' )
      # @stream.push( 'Deals',      @trip.deals,      'Model' )
      @first    = false
      @needData = false
      @launchTrip()

  launchTrip:( ) ->
    Util.dbg(  'Model.launchTrip() ', @trip.segments.segments.length )
    #Util.dbg( 'Model.launchTrip() ', @trip.segments.segments['id16'].StartMileMarker)
    @trip.eta            = Util.toFloat(@trip.segments.travelTime) # @eta( @trip )
    Util.log( 'eta', @trip.eta )
    @trip.recommendation = @recommendation( @trip )
    @logTrip( 'launchTrip()', @trip )
    @app.ui.changeRecommendation( @trip.recommendation )
    @stream.push( 'Trip', @trip, 'Model' )

  logTrip:( name, trip ) ->
    Util.dbg( 'Model.'+name, { source:trip.source, destination:trip.destination, direction:trip.direction, preset:trip.preset, begSeg:trip.begSeg, endSeg:trip.endSeg, recommendation:trip.recommendation, eta:trip.eta } )


  doSegments:( args, segments ) =>
    @trip.segments           = {}
    @trip.segments.travelTime = segments.travelTime
    @trip.segments.segments  = []
    @trip.segmentIdsReturned = []
    hasBeg = false
    hasEnd = false
    begSeg = @segTown( @trip.source      )
    endSeg = @segTown( @trip.destination )
    Util.dbg( 'begend', begSeg, endSeg )
    for own key, seg of segments.segments
      [id,num]  = @segIdNum( key )
      hasBeg = true if num is begSeg
      if hasBeg and not hasEnd
        @trip.segments.segments[id] = seg
        @trip.segmentIdsReturned.push( num )
      hasEnd = true if num is endSeg
      Util.dbg( num, begSeg, endSeg, hasBeg, hasEnd, @trip.segments.segments[id] )
    @segmentsComplete = true
    @checkComplete()

  doConditions:( args, conditions ) =>
    @trip.conditions          = conditions
    @trip.conditions.segments = args.segments
    @conditionsComplete = true
    @checkComplete()

  doDeals:( args, deals ) =>
    @trip.deals = deals
    @dealsComplete = true
    @checkComplete()

  getDealsBySegId:( segId ) ->
    segDeals = []
    for deal in @trip.deals when @dealHasSegId(deal,segId)
      segDeals.push( deal )
    segDeals

  dealHasSegId:( deal, segId ) ->
    for seq in deal.dealData.onSegments
      return true if seq.segmentId is segId
    false

  getSegmentIds:() ->
    # if @segmentIdsReturned.length > 0 then @segmentIdsReturned else @segmentIds
    if @trip? then @trip.segmentIds else []

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

  begSeg:( trip ) ->
    Util.log( 'begSeg', 'id' + trip.begSeg, trip.segments.segments['id' + trip.begSeg] )
    trip.segments.segments['id' + trip.begSeg ] # trip.segments.segments['id' + trip.segmentIdsReturned[0]]

  endSeg:( trip ) ->
    Util.log( 'endSeg', 'id' + trip.endSeg, trip.segments.segments['id' + trip.endSeg] )
    seg = trip.segments.segments['id' + trip.endSeg]
    seg = trip.segments.segments['id' + 30 ] if not seg?
    seg

  segDest:( town, i ) =>
    segTown = @Data.DestinationsSegIds[town]
    segId   = if segTown? then segTown[i] else @Data.DestinationsSegIds['NoGo'][i]
    segId

  segWest:( town ) -> @segDest( town, 0 )
  segEast:( town ) -> @segDest( town, 1 )

  segTown:( town ) -> if @trip.direction is 'West' then @segWest(town) else @segEast(town)

  directionSourceDestination:( source, destination ) =>
    Util.log( 'DirectionIndex', @Data.Destinations.indexOf(source), @Data.Destinations.indexOf(destination) )
    if @Data.Destinations.indexOf(source) <= @Data.Destinations.indexOf(destination)  then 'West' else 'East'

  eta:(trip) =>
    eta = 0
    for condition in trip.conditions
      eta += Util.toFloat(condition.Conditions.TravelTime)
    eta

  etaHoursMins:( eta ) =>
    Util.dbg( 'ETA', eta )
    Util.toInt(eta/60) + ' Hours ' + eta%60 + ' Mins'

  recommendation:( trip  ) =>
    if trip.source is 'NoGo' or trip.destination is 'NoGo' then 'NoGo' else 'Go'

  getSegments:( begSegId, endSegId, direction ) =>
    if direction is 'West' then



