
class Advisory

  Util.Export( Advisory, 'ui/Advisory' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Advisory')}" class="#{@app.css('Advisory')}"></div>"""

  layout:( orientation ) ->
    Util.noop( orientation )

  show:() ->

  hide:() ->