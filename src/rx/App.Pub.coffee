
class Pub

  Util.loadModule( Util.paths.bower, 'rxjs/dist/',   'rx.all',   'Rx' )
  Util.loadModule( Util.paths.bower, 'rxjs-jquery/', 'rx.jquery'      )
  App = Util.Import('app/App' )
  App.Pub = Pub
  Util.Export( Pub, 'app/App.Pub' )

  constructor:( @app ) ->
    Util.error( 'App rxjs-jquery not defined' ) if not $().bindAsObservable? # Special case
    @subjects = {}
    @subjects['Select']   = new Rx.Subject()
    #@subjects['Content'] = new Rx.Subject()
    @subjects['Convey']   = new Rx.Subject()
    @subjects['Flow']     = new Rx.Subject()
    @subjects['Plane']    = new Rx.Subject()
    @subjects['About']    = new Rx.Subject()
    @subjects['Navigate'] = new Rx.Subject()
    @subjects['Settings'] = new Rx.Subject()
    @subjects['Submit']   = new Rx.Subject()

  getSubject:( prop, warn=false ) ->
    if @subjects[prop]?
       @subjects[prop]
    else
      Util.warn( 'App.Pub.getSubject() unknown subject so returning new subject for', prop ) if warn
      @subjects[prop] = new Rx.Subject()
    @subjects[prop]

  publish:( prop, jqSel, eventType, topic, from ) ->
    subject = @getSubject(  prop )
    object  = { from:from, topic:topic }
    #Util.log( 'App.Pub.publishEventToSubject.onInit', prop, object )
    onNext = ( event ) =>
      @processEvent(  event )
      object.value = event.target.value  if eventType isnt 'click'
      #Util.log( 'App.Pub.publish.onNext', prop, object )
      subject.onNext( object )
    @subscribeEvent( onNext, jqSel, eventType, object )
    subject

  # onThis does not always work with CoffeeScript class object so best to pass onNext( topic ) as a closure
  subscribe:( prop, onNext ) ->
    subject = @getSubject( prop, false ) # Many subscribers come before publishers
    subscription = subject.subscribe( onNext, @onError, @onComplete )
    subscription

  createRxJQuery:( jqSel, object ) ->
    if Util.isJQuery( jqSel )
      jqSel
    else if Util.isStr( jqSel )
      $(jqSel)
    else
      Util.error('App.Pub.createRxJQuery( jqSel )', object, typeof(jqSel), 'jqSel is neither jQuery object nor selector' )
      $()

  onError:( error ) ->
    Util.error( 'App.Pub.onError()', error )

  onComplete:() ->
    Util.log(   'App.Pub.onComplete()', 'Completed' )

  subscribeEvent:( onNext, jqSel, eventType, object ) ->
    rxjq          = @createRxJQuery( jqSel, object )
    observable    = rxjq.bindAsObservable( eventType )
    subscription  = observable.subscribe( onNext, @onError, @onComplete )
    subscription

  processEvent:( event ) ->
    event?.stopPropagation()                   # Will need to look into preventDefault
    event?.preventDefault()

  toggleNavbTocs:( jqSel, from ) ->
    onNext = ( event ) =>
      @processEvent( event )
      @app.toggleNavbTocs()
    @subscribeEvent( onNext, jqSel, 'click', 'toggleNavbTocs', from )

  drag:( jqSel ) ->

    dragTarget = @createRxJQuery( jqSel )  # Note $jQuery has to be made reative with rxjs-jquery

    # Get the three major events
    mouseup   =  dragTarget.bindAsObservable("mouseup"  ).publish().refCount()
    mousemove = $(document).bindAsObservable("mousemove").publish().refCount()
    mousedown =  dragTarget.bindAsObservable("mousedown").publish().refCount().map( (event) -> # calculate offsets when mouse down
      event.preventDefault()
      left: event.clientX - dragTarget.offset().left
      top:  event.clientY - dragTarget.offset().top  )

    # Combine mouse down with mouse move until mouse up
    mousedrag = mousedown.selectMany( (offset) ->

      # calculate offsets from mouse down to mouse moves
      mousemove.map( (pos) ->
        left: pos.clientX - offset.left
        top:  pos.clientY - offset.top
      ).takeUntil mouseup )

    # Update position
    subscription = mousedrag.subscribe( (pos) ->
      dragTarget.css( { top:pos.top, left:pos.left } )
      return )
