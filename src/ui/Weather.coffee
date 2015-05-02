
class Weather

  Util.Export( Weather, 'ui/Weather' )

  constructor:( @app ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Weather')}" class="#{@app.css('Weather')}"></div>"""

  layout:() ->

  show:() ->

  hide:() ->