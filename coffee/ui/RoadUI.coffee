
class RoadUI

  Util.Export( RoadUI, 'ui/RoadUI' )

  constructor:( @app, @stream ) ->
    DriveBarUI  = Util.Import( 'ui/DriveBarUI')
    @driveBarUI = new DriveBarUI( @app, @stream, 'Road', @, 'Landscape' )

  ready:() ->
    @$ = $( @html() )
    @driveBarUI.ready()

  position:() ->
    @driveBarUI.position()
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (orientation) =>  @layout(orientation) )

  html:() ->
    """<div id="#{Util.id('Road')}" class="#{Util.css('Road')}">#{@driveBarUI.html('Trip')}</div>"""

  layout:( orientation ) ->
    Util.dbg( 'Road.layout()', orientation )
    @driveBarUI.layout( orientation )
