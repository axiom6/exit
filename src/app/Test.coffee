
class Test

  Util.Export( Test, 'app/Test' )

  @array = [1,2,3,4,5,6,7,8,9]

  constructor:( @app, @stream ) ->
    #@rest()
    @streamPushTestLocation()
    #@streamFibonacci()

  rest:() ->
    Util.log( 'Test.rest() ------------' )
    @rest     = @app.rest
    @segments = [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]
    @rest.segmentsByPreset( 1,                       @rest.logSegments   )
    @rest.conditionsBySegme
    objents(           @segments, @rest.logConditions )
    @rest.deals( [39.644407,-106.378767], @segments, @rest.logDeals      )

  streamPushTestLocation:() ->
    subject = new Rx.Subject()
    subject.subscribe( (object) => @onTestLocation( object ) )
    object  = @stream.createObject('LatLon', 'Stream.Test')
    subject.onNext( object )
    return

  onTestLocation:( object ) ->
    Util.log( 'Test.Stream.onLocation()', object.content, object.from )

  streamFibonacci:() ->
    source = Rx.Observable.from( @fibonacci() ).take(10)
    source.subscribe( (x) -> Util.log( 'Text.Stream.Fibonacci()', x ) )

  fibonacci:() ->
    fn1 = 1
    fn2 = 1
    while 1
      current = fn2;
      fn2 = fn1
      fn1 = fn1 + current
      yield current