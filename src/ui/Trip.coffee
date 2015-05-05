
class Trip

  Util.Export( Trip, 'ui/Trip' )

  constructor:( @app, @stream, @road, @weather, @advisory ) ->

  ready:() ->
    @$ = $( @html() )
    @$.append( @weather.$   )
    @$.append( @road.$      )
    @$.append( @advisory.$  )

  html:() ->
    """<div id="#{@app.id('Trip')}" class="#{@app.css('Trip')}"></div>"""

  layout:() ->

  show:() -> @$.show()

  hide:() -> @$.hide()