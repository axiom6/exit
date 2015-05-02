
class Advisory

  Util.Export( Road, 'ui/Advisory' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Advisory')}" class="#{@app.css('Advisory')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->