
class UI

  Util.Export( UI, 'ui/UI' )

  constructor:( @app, @stream, @destination, @trip, @deals, @navigate ) ->
    @orientation = 'Portrait'
    @lastSelect  = null

  ready:() ->
    @$ = $( @html() )
    $('#App').append(@$)
    @$view = @$.find('#View')
    @$view.append(@destination.$)
    @$view.append(@trip.$)
    @$view.append(@deals.$)
    @$view.append(@navigate.$)
    @$IconsHover      =  @$.find('#IconsHover')
    @$Icons           =  @$.find('#Icons')
    @$destinationIcon =  @$.find('#DestinationIcon')
    @$tripIcon        =  @$.find('#TripIcon')
    @$dealsIcon       =  @$.find('#DealsIcon')
    @$namigateIcon    =  @$.find('#NavigateIcon')
    @$IconsHover.mouseenter( () => @$Icons.show() )
    @$Icons     .mouseleave( () => @$Icons.hide() )
    @publish()
    @subscribe()
    #@push( 'Select', 'Trip', 'UI' )
    @select( 'Destination' )

  id:(   name, type     ) -> @app.id(   name, type     )
  css:(  name, type     ) -> @app.css(  name, type     )
  icon:( name, type, fa ) -> @app.icon( name, type, fa )

  html:() ->
    """<div      id="#{@id('UI')}"                  class="#{@css('UI')}">
         <div    id="#{@id('IconsHover')}"          class="#{@css('IconsHover')}"></div>
         <div    id="#{@id('Icons')}"               class="#{@css('Icons')}">
            <div id="#{@id('Destination','Icon')}"  class="#{@css('Destination','Icon')}"><div><i class="fa fa-picture-o"></i></div></div>
            <div id="#{@id('Trip',       'Icon')}"  class="#{@css('Trip',       'Icon')}"><div><i class="fa fa-road"></i></div></div>
            <div id="#{@id('Deals',      'Icon')}"  class="#{@css('Deals',      'Icon')}"><div><i class="fa fa-trophy"></i></div></div>
            <div id="#{@id('Navigate',   'Icon')}"  class="#{@css('Navigate',   'Icon')}"><div><i class="fa fa-street-view"></i></div></div>
         </div>
         <div id="#{@id('View')}" class="#{@css('View')}"></div>
        </div>"""

  layout:( orientation ) ->
    Util.log( 'UI.layout', orientation )
    url = "img/app/phone6x12#{orientation}.png"
    $('body').css( { "background-image":"url(#{url})" } )
    $('#App').attr( 'class', "App#{orientation}" )
    @destination.layout( orientation )
    @trip.layout(  orientation )
    @deals.layout( orientation )

  show:() ->

  hide:() ->

  publish:() ->
    @stream.publish( 'Select', @$destinationIcon, 'click', 'Destination', 'UI' )
    @stream.publish( 'Select', @$tripIcon,        'click', 'Trip',        'UI' )
    @stream.publish( 'Select', @$dealsIcon,       'click', 'Deals',       'UI' )
    @stream.publish( 'Orient', @$namigateIcon,    'click', 'Orient',      'UI' )

  subscribe:() ->
    @stream.subscribe( 'Select', (object) => @select(object.topic) )
    @stream.subscribe( 'Orient', (object) => @orient() )

  push:( subject, topic, from ) ->
    @stream.push( subject, topic, from )

  select:( name ) ->
    @lastSelect.hide() if @lastSelect?
    switch name
      when 'Destination'
        @lastSelect = @destination
      when 'Trip'
        @lastSelect = @trip
      when 'Deals'
        @lastSelect = @deals
        @deals.showMeMyDeals()
      when 'Navigate'
        @lastSelect = @navigate
      else
        Util.error( "UI.select unknown name", name )
    if @lastSelect?
       @lastSelect.show()

  orient:() ->
    @orientation = if @orientation is 'Portrait' then 'Landscape' else 'Portrait'
    @layout( @orientation )

  width:()  ->
    w1 = if @$? then @$.width() else 0
    w  = 0
    if w1 is 0
      w = if @orientation is 'Portrait' then 300 else 500
    else
      w = w1
    # Util.log( 'UI.width()', w, w1 )
    w

  height:() ->
    h1 = if @$? then @$.height() else 0
    h  = 0
    if h1 is 0
      h = if @orientation is 'Portrait' then 500 else 300
    else
      h = h1
    # Util.log( 'UI.height()', h, h1 )
    h


