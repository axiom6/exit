
class Destination

  Util.Export( Destination, 'ui/Destination' )

  constructor:( @app, @stream, @go, @nogo, @threshold ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Destination')}" class="#{@app.css('Destination')}"></div>"""

  layout:() ->

  show:() ->

  hide:() ->