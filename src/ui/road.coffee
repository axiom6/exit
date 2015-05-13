
class Road

  Util.Export( Road, 'ui/Road' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'Road' )

  ready:() ->
    @$ = $( @html() )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )

  html:() ->
    """<div id="#{@app.id('Road')}" class="#{@app.css('Road')}">#{@driveBar.html('Trip')}</div>"""

  postReady:() ->
    @driveBar.postReady()

  layout:( orientation ) ->
    Util.log( 'Road.layout()', orientation )

  show:() -> @$.show()
  hide:() -> @$.hide()