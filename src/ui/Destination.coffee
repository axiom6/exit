
class Destination

  Util.Export( Destination, 'ui/Destination' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Destination')}" class="#{@app.css('Destination')}"></div>"""

  layout:() ->

  show:() ->

  hide:() ->