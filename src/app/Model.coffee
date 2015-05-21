

class Model

  Util.Export( Model, 'app/Model' )

  constructor:( @app, @stream, @rest ) ->

    @logData     = false
    @Data        = Util.Import( 'app/Data' )  # We occasionally need to key of some static data at this point of the project
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
    @createTrip( @source, @destination ) if @destination isnt '?'

  onDestination:(  destination ) =>
    @destination = destination
    @createTrip( @source, @destination ) if @source isnt '?'

  tripName:( source, destination ) ->
    "#{source}To#{destination}"

  trip:() ->
    @trips[ @tripName( @source, @destination ) ]

# The Trip parameter calculation process here needs to be refactored
  createTrip:( source, destination ) ->
    @source      = source
    @destination = destination
    name         = @tripName( @source, @destination )
    @trips[name] = new Trip( @app, @stream, @model, name, source, destination )
    @doTrip( @trips[name] )
    return

  doTrip:( trip ) ->
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
      @launchTrip()

  launchTrip:( ) ->
    trip = @trip()
    trip.launch()
    @app.ui.changeRecommendation( @trip.recommendation )
    @stream.push( 'Trip', @trip, 'Model' )

  doSegments:( args, segments ) =>
    trip            = @trip()
    trip.travelTime = segments.travelTime
    trip.segments   = []
    trip.segmentIds = []
    for own key, seg of segments.segments when trip.spatial.segInTrip( seg, trip )
      [id,num]  = trip.spatial.segIdNum( key )
      trip.segments.  push( seg )
      trip.segmentIds.push( num )
    @segmentsComplete = true
    @checkComplete()

  doConditions:( args, conditions ) =>
    @trip().conditions    = conditions
    @conditionsComplete = true
    @checkComplete()

  doDeals:( args, deals ) =>
    @trip().deals = deals
    @dealsComplete = true
    @checkComplete()


