
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
    @stream.subscribe( 'Orient',      (object) =>        @layout(object.content) )

  layout:( orientation ) ->
    @road    .layout( orientation )
    @weather .layout( orientation )
    @advisory.layout( orientation )

  html:() ->
    """<div id="#{@app.id('Trip')}" class="#{@app.css('Trip')}"></div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()


