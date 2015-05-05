
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
    @$destinationIcon =  @$.find('#DestinationIcon')
    @$tripIcon        =  @$.find('#TripIcon')
    @$dealsIcon       =  @$.find('#DealsIcon')
    @$namigateIcon    =  @$.find('#NavigateIcon')
    @lastSelect       = null
    @publish()
    @subscribe()
    #@push( 'Select', 'Trip', 'UI' )
    @select( 'Trip' )



  id:(   name, type     ) -> @app.id(   name, type     )
  css:(  name, type     ) -> @app.css(  name, type     )
  icon:( name, type, fa ) -> @app.icon( name, type, fa )

  html:() ->
    """<div    id="#{@id('UI')}"                  class="#{@css('UI')}">
         <div  id="#{@id('Icons')}"               class="#{@css('Icons')}">
            <i id="#{@id('Destination','Icon')}"  class="#{@icon('Destination','Icon','picture-o')}"></i>
            <i id="#{@id('Trip',       'Icon')}"  class="#{@icon('Trip',       'Icon','road')}"></i>
            <i id="#{@id('Deals',      'Icon')}"  class="#{@icon('Deals',      'Icon','trophy')}"></i>
            <i id="#{@id('Navigate',   'Icon')}"  class="#{@icon('Navigate',   'Icon','street-view')}"></i>
         </div>
         <div id="#{@id('View')}" class="#{@css('View')}"></div>
        </div>"""

  layout:() ->

  show:() ->

  hide:() ->

  publish:() ->
    @stream.publish( 'Select', @$destinationIcon, 'click', 'Destination', 'UI' )
    @stream.publish( 'Select', @$tripIcon,        'click', 'Trip',        'UI' )
    @stream.publish( 'Select', @$dealsIcon,       'click', 'Deals',       'UI' )
    @stream.publish( 'Select', @$namigateIcon,    'click', 'Navigate',    'UI' )

  subscribe:() ->
    @stream.subscribe( 'Select', (object) => @select(object.topic) )

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
    return