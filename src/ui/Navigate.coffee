
class Navigate

  Util.Export( Navigate, 'ui/Navigate' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )

  layout:( orientation ) ->
    Util.dbg( 'Navigate.layout()', orientation )

  html:() ->
    """<div id="#{@app.id('Navigate')}" class="#{@app.css('Navigate')}">Navigate</div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()