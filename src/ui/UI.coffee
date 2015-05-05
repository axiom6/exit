
class UI

  Util.Export( UI, 'ui/UI' )

  constructor:( @app, @destination, @trip, @deals, @navigate ) ->

  ready:() ->
    @$ = $( @html() )
    $('#App').append(@$)
    @$view = @$.find('#View')
    @$view.append(@destination.$)
    @$view.append(@trip.$)
    @$view.append(@deals.$)
    @$view.append(@navigate.$)

    @$destinationIcon =  @$.find('DestinationIcon')
    @$tripIcon        =  @$.find('TripIcon')
    @$dealIcon        =  @$.find('DealIcon')
    @$namigateIcon    =  @$.find('NavigateIcon')

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