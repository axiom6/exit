
class Go

  Util.Export( Go, 'ui/Go' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Go')}" class="#{@app.css('Go')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->