
class NoGo

  Util.Export( NoGo, 'ui/NoGo' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('NoGo')}" class="#{@app.css('NoGo')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->