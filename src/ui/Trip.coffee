
class Trip

  Util.Export( Trip, 'ui/Trip' )

  constructor:( @app, @model, @advisory, @go, @nogo, @weather, @road ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Trip')}" class="#{@app.css('Trip')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->