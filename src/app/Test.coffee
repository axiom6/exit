
class Test

  Util.Export( Test, 'app/Test' )

  constructor:( @app, @stream ) ->
    @rest()

  rest:() ->
    Util.log( 'Test.rest() ------------' )
    @rest     = @app.rest
    @segments = [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]
    @rest.segmentsByPreset( 1,                       @rest.logSegments   )
    @rest.conditionsBySegments(           @segments, @rest.logConditions )
    @rest.deals( [39.644407,-106.378767], @segments, @rest.logDeals      )
