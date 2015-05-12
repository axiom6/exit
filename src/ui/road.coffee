
class Road

  Util.Export( Road, 'ui/Road' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'Road' )

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Road')}" class="#{@app.css('Road')}">#{@driveBar.html('Trip')}</div>"""

  postReady:() ->
    @driveBar.postReady()

  layout:( orientation ) ->
    @driveBar.layout( orientation )

  show:() -> @$.show()
  hide:() -> @$.hide()