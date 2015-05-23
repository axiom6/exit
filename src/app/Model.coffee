

class Model

  Util.Export( Model, 'app/Model' )

  constructor:( @app, @stream, @rest ) ->
    @Data        = Util.Import( 'app/Data' )  # We occasionally need to key of some static data at this point of the project
    @Trip        = Util.Import( 'app/Trip' )
    @first       = true                       # Implies we have not acquired enough data to get started
    @source      = '?'
    @destination = '?'
    @trips       = {}
    
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
    @stream.subscribe( 'Source',      (object) => @onSource(      object.content ) )
    @stream.subscribe( 'Destination', (object) => @onDestination( object.content ) )

  onSource:(  source ) =>
    @source = source
    if @destination isnt '?' and @source isnt @destination
      @createTrip( @source, @destination )

  onDestination:(  destination ) =>
    @destination = destination
    if @source isnt '?'  and @source isnt @destination
      @createTrip( @source, @destination )

  tripName:( source, destination ) ->
    "#{source}To#{destination}"

  trip:() ->
    @trips[ @tripName( @source, @destination ) ]

# The Trip parameter calculation process here needs to be refactored
  createTrip:( source, destination ) ->
    @source      = source
    @destination = destination
    name         = @tripName( @source, @destination )
    @trips[name] = new @Trip( @app, @stream, @, name, source, destination )
    @doTrip( @trips[name] )
    return

  doTrip:( trip ) ->
    @segmentsComplete    = false
    @conditionsComplete  = false
    @dealsComplete       = false
    @rest.segmentsByPreset(             trip.preset,        @doSegments   )
    @rest.conditionsBySegments(         trip.segmentIdsAll, @doConditions )
    @rest.deals( @app.dealsUI.latLon(), trip.segmentIdsAll, @doDeals      )

# checkComplete is call three times when each status completed is changed
  # goOrNoGo is then only called once
  checkComplete:() =>
    if @segmentsComplete and @conditionsComplete and @dealsComplete
      @first    = false
      @launchTrip()

  launchTrip:( ) ->
    trip = @trip()
    trip.launch()
    @app.ui.changeRecommendation( trip.recommendation )
    @stream.push( 'Trip', trip, 'Model' )

  doSegments:( args, segments ) =>
    @segments       = segments
    trip            = @trip()
    trip.travelTime = segments.travelTime
    trip.segments   = []
    trip.segmentIds = []
    for own key, seg of segments.segments
      [id,num]  = trip.segIdNum( key )
      # Util.log( 'Model.doSegments id num', { id:id, num:num, beg:seg.StartMileMarker, end:seg.EndMileMarker } )
      if trip.segInTrip( seg )
        seg['segId'] = num
        trip.segments.  push( seg )
        trip.segmentIds.push( num )
    @segmentsComplete = true
    # Util.log( 'Model.doSegments segmenIds', trip.segmentIds )
    @checkComplete()

  doConditions:( args, conditions ) =>
    @conditions = conditions
    @trip().conditions  = conditions
    @conditionsComplete = true
    @checkComplete()

  doDeals:( args, deals ) =>
    @deals = deals
    @trip().deals = deals
    @dealsComplete = true
    @checkComplete()


