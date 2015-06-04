
class RoadUI

  Util.Export( RoadUI, 'ui/RoadUI' )

  constructor:( @stream ) ->
    DriveBarUI  = Util.Import( 'ui/DriveBarUI')
    @driveBarUI = new DriveBarUI( @stream, 'Road', @  )

  ready:() ->
    @$ = $( @html() )
    @driveBarUI.ready()

  position:( screen ) ->
    # Util.dbg( 'RoadUI.position()', screen )
    @driveBarUI.position( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )

  html:() ->
    """<div id="#{Util.id('Road')}" class="#{Util.css('Road')}">#{@driveBarUI.html('Trip')}</div>"""

  onScreen:( screen ) ->
    Util.noop( 'RoadUI.screen()', screen )
