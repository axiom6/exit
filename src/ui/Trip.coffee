
class Trip

  Util.Export( Trip, 'ui/Trip' )

  constructor:( @app, @stream, @road, @weather, @advisory, @driveBar ) ->

  ready:() ->
    @advisory.ready()
    @road.ready()
    @weather.ready()
    @$ = $( @html() )
    @$.append( @advisory.$  )
    @$.append( @weather.$   )
    @$.append( @road.$      )

  html:() ->
    """<div id="#{@app.id('Trip')}" class="#{@app.css('Trip')}">#{@driveBar.html('Trip')}</div>"""

  layout:() ->

  show:() -> @$.show()

  hide:() -> @$.hide()