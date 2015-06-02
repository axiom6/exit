
class Stream

  Util.Export( Stream, 'test/app/Stream' )

  constructor:( @app, @subjectNames ) ->



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
      object.content = event.target.value  if eventType isnt 'click'
      subject.onNext( object )
    @subscribeEvent( onNext, jQuerySelector, eventType, object )
    return

  subscribe:( name, onNext ) ->
    subject = @getSubject( name, false ) # Many subscribers come before publishers
    subject.subscribe( onNext, @onError, @onComplete )
    return

  push:( name, content, from ) ->
    subject = @getSubject(  name )
    object  = @createObject( content, from )
    subject.onNext( object )
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

  subscribeEvent:( onNext, jqSel, eventType, object ) ->
    rxjq          = @createRxJQuery( jqSel, object )
    observable    = rxjq.bindAsObservable( eventType )
    observable.subscribe( onNext, @onError, @onComplete )
    return

  processEvent:( event ) ->
    event?.stopPropagation()                   # Will need to look into preventDefault
    event?.preventDefault()
    return


