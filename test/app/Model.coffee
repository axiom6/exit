

class Model

  Util.Export( Model, 'test/app/Model' )

  constructor:( @app, @stream, @rest ) ->

  ready:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Source',      (object) => @onSource(      object.content ) )
    @stream.subscribe( 'Destination', (object) => @onDestination( object.content ) )

  # A poor man's chained completion status.
  # Could be implemented better in the future with a chained Stream or a synched promise chain
  resetCompletionStatus:() ->
    return

# The Trip parameter calculation process here needs to be refactored
  createTrip:( source, destination ) ->

    return

  doTrip:( trip ) ->
    return

  doTripLocal:( trip ) ->
    return

# checkComplete is call three times when each status completed is changed
  # goOrNoGo is then only called once
  checkComplete:() =>


  launchTrip:( trip ) ->
    return

  # Makes a rest call for each town in the Trip, and checks completion for each town
  #   so it does not have forecastComplete or forecastCompleteWithError flags
  restForecasts:( trip ) ->
    return

  doSegments:( args, segments ) =>
    return

  doConditions:( args, conditions ) =>
    return

  doDeals:( args, deals ) =>
    return

  doMilePosts:( args, milePosts ) =>
    return

  doForecasts:( args, forecasts ) =>
    return

  doTownForecast:( args, forecast ) =>
    return

  onSegmentsError:( obj ) =>
    return

  onConditionsError:( obj ) =>
    return

  onDealsError:( obj ) =>
    return

  onForecastsError:( obj ) =>
    return

  onTownForecastError:( obj ) =>
    return

  pushForecastsWhenComplete:( forecasts ) ->
    return

  onMilePostsError:( obj ) =>
    return

  errorsDetected:() =>
    return
