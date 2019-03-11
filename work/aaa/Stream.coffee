
class Stream

  Util.Export( Stream, 'app/Stream' )

  constructor:( @subjectNames ) ->
    Util.error( 'Stream rxjs-jquery not defined' ) if not $().bindAsObservable? # Special case
    @subjects = {}
    for name in @subjectNames
      @subjects[name] = new Rx.Subject()

  # Get a subject by name. Create a new one if need with a warning
  getSubject:( name, warn=false ) ->
    if @subjects[name]?
       @subjects[name]
    else
      Util.warn( 'Stream.getSubject() unknown subject so returning new subject for', name ) if warn
      @subjects[name] = new Rx.Subject()
    @subjects[name]

  # Publishes object on event through rxjs-jquery event for a jQuerySelector dom element
  event:( name, jQuerySelector, eventType, objectArg ) ->
    subject = @getSubject(  name )
    object  = objectArg
    onNext  = ( event ) =>
      @processEvent(  event )
      object = event.target.value  if eventType isnt 'click'
      subject.onNext( object )
    @subscribeEvent( onNext, jQuerySelector, eventType, object )
    return

  subscribe:( name, onNext ) ->
    subject = @getSubject( name, false ) # Many subscribers come before publishers
    subject.subscribe( onNext, @onError, @onComplete )
    return

  publish:( name, object ) ->
    subject = @getSubject(  name )
    subject.onNext( object )
    return

  subscribeEvent:( onNext, jqSel, eventType, object ) ->
    rxjq          = @createRxJQuery( jqSel, object )
    observable    = rxjq.bindAsObservable( eventType )
    observable.subscribe( onNext, @onError, @onComplete )
    return

  createRxJQuery:(    jQuerySelector, object ) ->
    if Util.isJQuery( jQuerySelector )
      jQuerySelector
    else if Util.isStr( jQuerySelector )
      $(jQuerySelector)
    else
      Util.error('App.Pub.createRxJQuery( jqSel )', object, typeof(jQuerySelector), 'jqSel is neither jQuery object nor selector' )
      $()

  onError:( error ) ->
    Util.error( 'Stream.onError()', error )

  onComplete:() ->
    Util.dbg(   'Stream.onComplete()', 'Completed' )



  processEvent:( event ) ->
    event?.stopPropagation()                   # Will need to look into preventDefault
    event?.preventDefault()
    return

  # RxJS Experiments
  streamFibonacci:() ->
    source = Rx.Observable.from( @fibonacci() ).take(10)
    source.subscribe( (x) -> Util.dbg( 'Text.Stream.Fibonacci()', x ) )

  # RxJS Experiments
  fibonacci:() ->
    fn1 = 1
    fn2 = 1
    while 1
      current = fn2;
      fn2 = fn1
      fn1 = fn1 + current
      yield current
