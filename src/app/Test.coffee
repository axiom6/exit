
class Test

  Util.Export( Test, 'app/Test' )

  constructor:( @app, @stream ) ->
    @rest()

  rest:() ->
    Util.log( 'Test.rest() ------------' )
    @rest = @app.rest
    @rest.segmentsByPreset(   1, Util.log )
    @rest.conditionsSegments( [23,24,25,270], Util.log )
    @rest.deals(              [23,24,25,270], 39.716707,-105.696435, Util.log )

