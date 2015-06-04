

class Model

  Util.Export( Model, 'app/Model' )

  constructor:( @app, @stream, @rest ) ->
    @Data        = Util.Import( 'app/Data' )  # We occasionally need to key of some static data at this point of the project
    @Trip        = Util.Import( 'app/Trip' )
    @first       = true                       # Implies we have not acquired enough data to get started
    @source      = '?'
    @destination = '?'
    @trips       = {}
    @resetCompletionStatus()
    @milePostsComplete           = false
    @milePostsCompleteWithError  = false
    @segments           = []
    @conditions         = []
    @deals              = []
    @forecasts          = {}
    @forecastsPending    = 0
    @forecastsCount     = 0
    @milePosts          = []
    @segmentIds         = @Data.WestSegmentIds  # CDOT road speed segment for Demo I70 West from 6th Ave to East Vail
    @segmentIdsReturned = []                    # Accumulate by doSegments()

  ready:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Source',      (source)      => @onSource(      source      ) )
    @stream.subscribe( 'Destination', (destination) => @onDestination( destination ) )

  # A poor man's chained completion status.
  # Could be implemented better in the future with a chained Stream or a synched promise chain
  resetCompletionStatus:() ->
    @segmentsComplete            = false
    @segmentsCompleteWithError   = false
    @conditionsComplete          = false
    @conditionsCompleteWithError = false
    @dealsComplete               = false
    @dealsCompleteWithError      = false
    return

  onSource:(  source ) =>
    @source = source
    if @destination isnt '?' and @source isnt @destination
      @createTrip( @source, @destination )
    return

  onDestination:(  destination ) =>
    @destination = destination
    if @source isnt '?'  and @source isnt @destination
      @createTrip( @source, @destination )
    return

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
    switch @app.dataSource
      when 'Rest',  'RestThenLocal'  then @doTrip(      @trips[name] )
      when 'Local', 'LocalForecasts' then @doTripLocal( @trips[name] )
      else Util.error( 'Model.createTrip() unknown dataSource', @app.dataSource )
    return

  doTrip:( trip ) ->
    @resetCompletionStatus()
    @rest.segmentsByPreset(             trip.preset,        @doSegments,   @onSegmentsError   )
    @rest.conditionsBySegments(         trip.segmentIdsAll, @doConditions, @onConditionsError )
    @rest.deals( @app.dealsUI.latLon(), trip.segmentIdsAll, @doDeals,      @onDealsError      )
    @rest.milePostsFromLocal(                               @doMilePosts,  @onMilePostsError  )
    return

  doTripLocal:( trip ) ->
    @resetCompletionStatus()
    @rest.segmentsFromLocal(   trip.direction, @doSegments,   @onSegmentsError   )
    @rest.conditionsFromLocal( trip.direction, @doConditions, @onConditionsError )
    @rest.dealsFromLocal(      trip.direction, @doDeals,      @onDealsError      )
    @rest.forecastsFromLocal(                  @doForecasts,  @onForecastsError  )  if @app.dataSource is 'Local'
    @rest.milePostsFromLocal(                  @doMilePosts,  @onMilePostsError  )  if not @milePostsComplete and not @milePostsCompleteWithError
    return

# checkComplete is call three times when each status completed is changed
  # goOrNoGo is then only called once
  checkComplete:() =>
    if @segmentsComplete and @conditionsComplete and @dealsComplete and @milePostsComplete
      @launchTrip( @trip() )

  launchTrip:( trip ) ->
    @first = false
    trip.launch()
    @app.ui.changeRecommendation( trip.recommendation )
    @stream.publish( 'Trip', trip )
    if @app.dataSource isnt 'Local'
      @restForecasts( trip ) # Will punlish forecasts on Stream when completed
    return

  # Makes a rest call for each town in the Trip, and checks completion for each town
  #   so it does not have forecastComplete or forecastCompleteWithError flags
  restForecasts:( trip ) ->
    @forecastsPending  = 0
    @forecastsCount    = 0
    for own name, town of trip.towns
      date             = new Date()
      town.date        = date
      town.time        = town.date.getTime()
      #town.isoDateTime = Util.isoDateTime(date)
      @forecastsPending++
    for own name, town of trip.towns
      @rest.forecastByTown( name, town, @doTownForecast, @onTownForecastError )
    return

  doSegments:( args, segments ) =>
    trip            = @trip()
    trip.travelTime = segments.travelTime
    trip.segments   = []
    trip.segmentIds = []
    for own key, seg of segments.segments
      [id,num]  = trip.segIdNum( key )
      # Util.log( 'Model.doSegments id num', { id:id, num:num, beg:seg.StartMileMarker, end:seg.EndMileMarker } )
      if trip.segInTrip( seg )
        seg['segId'] = num
        seg.num = num
        trip.segments.  push( seg )
        trip.segmentIds.push( num )
    @segmentsComplete = true
    # Util.log( 'Model.doSegments segmenIds', trip.segmentIds )
    @checkComplete()
    return

  doConditions:( args, conditions ) =>
    @trip().conditions  = conditions
    @conditionsComplete = true
    @checkComplete()
    return

  doDeals:( args, deals ) =>
    @trip().deals = deals
    @dealsComplete = true
    @checkComplete()
    return

  doMilePosts:( args, milePosts ) =>
    @milePosts = milePosts
    @trip().milePosts = milePosts
    @milePostsComplete = true
    @checkComplete()
    return

  doForecasts:( args, forecasts ) =>
    trip = @trip()
    for own name, forecast of forecasts
      trip.forecasts[name]       = forecast
      trip.forecasts[name].index = @Trip.Towns[name].index
    @stream.publish( 'Forecasts', trip.forecasts, 'Model' )
    return

  doTownForecast:( args, forecast ) =>
    name                       = args.name
    trip                       = @trip()
    trip.forecasts[name]       = forecast
    trip.forecasts[name].index = @Trip.Towns[name].index
    @pushForecastsWhenComplete( trip.forecasts )
    return

  onSegmentsError:( obj ) =>
    Util.error( 'Model.onSegmentError()', obj )
    @segmentsCompleteWithError = true
    @errorsDetected()
    return

  onConditionsError:( obj ) =>
    Util.error( 'Model.onConditionsError()', obj )
    @conditionsCompleteWithError = true
    @errorsDetected()
    return

  onDealsError:( obj ) =>
    Util.error( 'Model.onDealsError()', obj )
    @dealsCompleteWithError = true
    @errorsDetected()
    return

  onForecastsError:( obj ) =>
    Util.error( 'Model.onForecastsError()', { name:obj.args.name } )
    return

  onTownForecastError:( obj ) =>
    name = obj.args.name
    Util.error( 'Model.townForecastError()', { name:name } )
    @publishForecastsWhenComplete( @trip().forecasts ) # We push on error because some forecasts may have made it through
    return

  publishForecastsWhenComplete:( forecasts ) ->
    @forecastsCount++
    if @forecastsCount is @forecastsPending
      @stream.publish( 'Forecasts', forecasts )
      @forecastsPending = 0 # No more pending forecasts after push
    return

  onMilePostsError:( obj ) =>
    Util.error( 'Model.onMilePostsError()', obj )
    @milePostsCompleteWithError = true
    @errorsDetected()
    return

  errorsDetected:() =>
    if( (@segmentsComplete   or @segmentsCompleteWithError)   and
        (@conditionsComplete or @conditionsCompleteWithError) and
        (@dealsComplete      or @dealsCompleteWithError)      and
        (@milePostsComplete  or @milePostsCompleteWithError)  and
         @app.dataSource is 'RestThenLocal' and @first )
      @doTripLocal( @trip() )
    else
      Util.error( 'Model.errorsDetected access data unable to proceed with trip' )
    return
