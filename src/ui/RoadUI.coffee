
class RoadUI

  Util.Export( RoadUI, 'ui/RoadUI' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'Road', @, 'Landscape' )

  ready:() ->
    @$ = $( @html() )
    @driveBar.ready()

  position:() ->
    @driveBar.position()
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )

  html:() ->
    """<div id="#{@app.id('Road')}" class="#{@app.css('Road')}">#{@driveBar.html('Trip')}</div>"""

  layout:( orientation ) ->
    Util.dbg( 'Road.layout()', orientation )
    @driveBar.layout( orientation )
