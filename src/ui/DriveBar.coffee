
class DriveBar

  Util.Export( DriveBar, 'ui/DriveBar' )

  constructor:( @app ) ->

  ready:() ->
    @$ = $( @html() )

  html:( name ) ->
    """<div id="#{@app.id('DriveBar',name)}" class="#{@app.css('DriveBar',name)}"></div>"""

  layout:() ->

  show:() ->

  hide:() ->