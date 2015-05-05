
class Deals

  Util.Export( Deals, 'ui/Deals' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Deals')}" class="#{@app.css('Deals')}">Deals</div>"""

  layout:() ->

  show:() -> @$.show()

  hide:() -> @$.hide()