
class Stream

  Util.Export( Stream, 'app/Stream' )

  constructor:( @app ) ->
    Util.error( 'Stream rxjs-jquery not defined' ) if not $().bindAsObservable? # Special case
    @subjects = {}
    @subjects['Select']              = new Rx.Subject()
    @subjects['Orient']              = new Rx.Subject()
    @subjects['Destination']         = new Rx.Subject()
    @subjects['Location']            = new Rx.Subject()
    @subjects['Segments']            = new Rx.Subject()
    @subjects['Deals']               = new Rx.Subject()
    @subjects['Conditions']          = new Rx.Subject()
    @subjects['RequestSegmentBy']    = new Rx.Subject()
    @subjects['RequestConditionsBy'] = new Rx.Subject()
    @subjects['RequestDealsBy']      = new Rx.Subject()
    @test1()
    @test2()

  fibonacci:() ->
    fn1 = 1
    fn2 = 1
    while (1)
      current = fn2;
      fn2 = fn1
      fn1 = fn1 + current
      yield current

  test2:() ->
    source    = Rx.Observable.from(@fibonacci()).take(10)
    subject   = @getSubject( 'Location' )
    subscribe = source.subscribe(subject) #subscribe( (x) -> Util.log('fib',x) )
    Util.noop( subscribe )

  test1:() ->
    array = [1,2,3,4,5,6,7,8,9]
    @subjects[  'TestLocation'] = new Rx.Subject()
    @subscribe( 'TextLocation', (object) => @onTestLocation( object.content ) )
    @push(      'TestLocation', 'LatLon', 'Stream.Test')

  push:( name, content, from) ->
    object  = @createObject( content, from )
    source  = Rx.Observable.from( object )

    subject = @getSubject( name )
    source.subscribe(subject)
    return

  onTestLocation:( content ) ->
    Util.log( 'Stream.onLocation()', content )

  # Get a subject by name. Create a new one if need with a warning
  getSubject:( name, warn=false ) ->
    if @subjects[name]?
       @subjects[name]
    else
      Util.warn( 'App.Pub.getSubject() unknown subject so returning new subject for', name ) if warn
      @subjects[name] = new Rx.Subject()
    @subjects[name]

  # Create object payload in a uniform way for subject
  # Note 'from' is just for debugging
  createObject:( content, from ) ->
    { from:from, content:content }

  # Convience method for validating and extracting an object's content
  getContent:( object ) ->
    content = {}
    if not object?
      Util.error( 'Stream.getContent() object null or undefined' )
    else if not object.content?
      from = if object.from? then from else 'unknown'
      Util.error( 'Stream.getContent() content null or undefined from', from )
    else
      content = object.content
    content

  # Publishes object through rxjs-jquery event for a jQuerySelector dom element
  publish:( name, jQuerySelector, eventType, content, from ) ->
    subject = @getSubject(  name )
    object  = @createObject( content, from )
    onNext = ( event ) =>
      @processEvent(  event )
      object.value = event.target.value  if eventType isnt 'click'
      subject.onNext( object )
    @subscribeEvent( onNext, jQuerySelector, eventType, object )
    subject

  # onThis does not always work with CoffeeScript class object so best to pass onNext( content ) as a closure
  subscribe:( name, onNext ) ->
    subject = @getSubject( name, false ) # Many subscribers come before publishers
    subscription = subject.subscribe( onNext, @onError, @onComplete )
    subscription

  # Push and ubject onto a subject
  push1:( name, content, src ) ->
    object     = @createObject( content, src )
    Rx.Observable.from(s)
    subject    = @getSubject(  name )
    observable = subject.asObservable()

    observable.publish( object )

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
    Util.log(   'Stream.onComplete()', 'Completed' )

  subscribeEvent:( onNext, jqSel, eventType, object ) ->
    rxjq          = @createRxJQuery( jqSel, object )
    observable    = rxjq.bindAsObservable( eventType )
    subscription  = observable.subscribe( onNext, @onError, @onComplete )
    subscription

  processEvent:( event ) ->
    event?.stopPropagation()                   # Will need to look into preventDefault
    event?.preventDefault()
