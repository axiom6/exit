
class Trip

  Util.Export( Trip, 'ui/Trip' )

  constructor:( @app, @advisory, @go, @nogo, @weather, @road ) ->

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