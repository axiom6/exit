
class TripUI

  Util.Export( TripUI,   'ui/TripUI' )

  constructor:( @stream ) ->
    WeatherUC     = Util.Import( 'uc/WeatherUC'  )
    AdvisoryUC    = Util.Import( 'uc/AdvisoryUC' )
    DriveBarUC    = Util.Import( 'uc/DriveBarUC' )
    @weatherUC    = new WeatherUC(  @stream, 'Trip', [0,  0, 100, 45], [0,  0, 100, 45] )
    @advisoryUC   = new AdvisoryUC( @stream, 'Trip', [0, 45, 100, 10], [0, 45, 100, 10] )
    @driveBarUC   = new DriveBarUC( @stream, 'Trip', [0, 55, 100, 45], [0, 55, 100, 45] )

  ready:() ->
    @weatherUC.ready()
    @advisoryUC.ready()
    @driveBarUC.ready()
    @$ = $( @html() )
    @$.append( @weatherUC.$, @advisoryUC.$, @driveBarUC.$ )

  position:( screen ) ->
    @weatherUI.position(  screen )
    @advisoryUI.position( screen )
    @driveBarUC.position( screen )
    @subscribe()

  # Trip subscribe to the full Monty of change
  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )

  # All positioning happens in the components
  onScreen:( screen ) ->
    Util.noop( 'TripUI.onScreen()', screen )

  html:() ->
    """<div id="#{Util.id('TripUI')}" class="#{Util.css('TripUI')}"></div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()


