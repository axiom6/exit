
class TripUI

  Util.Export( TripUI,   'ui/TripUI' )

  constructor:( @app, @stream, @road, @weather, @advisory ) ->
    @Data = Util.Import( 'app/Data' )
    @driveBarsCreated = false

  ready:() ->
    @advisory.ready()
    @road.ready()
    @weather.ready()
    @$ = $( @html() )
    @$.append( @advisory.$  )
    @$.append( @weather.$   )
    @$.append( @road.$      )

  position:() ->
    @road.position()
    @weather.position()
    @advisory.position()
    @subscribe()

  # Trip subscribe to the full Monty of change
  subscribe:() ->
    @stream.subscribe( 'Orient',      (orientation) =>        @layout(orientation) )

  layout:( orientation ) ->
    @road    .layout( orientation )
    @weather .layout( orientation )
    @advisory.layout( orientation )

  html:() ->
    """<div id="#{Util.id('Trip')}" class="#{Util.css('Trip')}"></div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()


