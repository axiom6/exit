
class Road

  Util.Export( Road, 'ui/Road' )

  constructor:( @app ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Road')}" class="#{@app.css('Road')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->