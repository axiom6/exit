
class Weather

  Util.Export( Road, 'ui/Weather' )

  constructor:( @app ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Weather')}" class="#{@app.css('Weather')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->