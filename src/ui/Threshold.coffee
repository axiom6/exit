
class Threshold

  Util.Export( Road, 'ui/Threshold' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Threshold')}" class="#{@app.css('Threshold')}"></div>"""

  layout:() ->

  show;() ->

  hide:() ->