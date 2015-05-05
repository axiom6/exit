
class Navigate

  Util.Export( Navigate, 'ui/Navigate' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Navigate')}" class="#{@app.css('Navigate')}">Navigate</div>"""

  layout:() ->

  show:() -> @$.show()

  hide:() -> @$.hide()