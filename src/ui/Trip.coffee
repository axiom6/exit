
class Trip

  Util.Export( Trip, 'ui/Trip' )

  constructor:( @app, @road, @weather, @advisory ) ->

  ready:() ->
    @$ = $( @html() )
    @$.append( @advisory.$  )
    @$.append( @go.$        )
    @$.append( @nogo.$      )
    @$.append( @weather.$   )
    @$.append( @road.$      )

  html:() ->
    """<div id="#{@app.id('Trip')}" class="#{@app.css('Trip')}"></div>"""

  layout:() ->

  show:() ->

  hide:() ->