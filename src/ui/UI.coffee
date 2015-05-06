
class UI

  Util.Export( UI, 'ui/UI' )

  constructor:( @app, @stream, @destination, @trip, @deals, @navigate ) ->

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
    @lastSelect       = null
    @orientation      = 'Portrait'
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
    """<div    id="#{@id('UI')}"                  class="#{@css('UI')}">
         <div  id="#{@id('IconsHover')}"          class="#{@css('IconsHover')}"></div>
         <div  id="#{@id('Icons')}"               class="#{@css('Icons')}">
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
      when 'Destination' then @lastSelect = @destination
      when 'Trip'        then @lastSelect = @trip
      when 'Deals'       then @lastSelect = @deals
      when 'Navigate'    then @lastSelect = @navigate
      else Util.error( "UI.select unknown name", name )
    if @lastSelect?
       @lastSelect.show()
       Util.log( name, 'Selected')

  orient:() ->
    @orientation = if @orientation is 'Portrait' then 'Landscape' else 'Portrait'
    @layout( @orientation )
