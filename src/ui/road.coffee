
class Road

  Util.Export( Road, 'ui/Road' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'Road', @ )

  ready:() ->
    @$ = $( @html() )
    @driveBar.ready()

  postReady:() ->
    @driveBar.postReady()
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )

  html:() ->
    """<div id="#{@app.id('Road')}" class="#{@app.css('Road')}">#{@driveBar.html('Trip')}</div>"""

  layout:( orientation ) ->
    Util.dbg( 'Road.layout()', orientation )
    @driveBar.layout( orientation )
