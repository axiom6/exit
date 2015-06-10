
class GoUI

  Util.Export( GoUI, 'ui/GoUI' )

  constructor:( @stream ) ->
    BannerUC    = Util.Import( 'uc/BannerUC'  )
    DealsUC     = Util.Import( 'uc/DealsUC'   )
    DriveBarUC  = Util.Import( 'uc/DriveBarUC')
    @bannerUC   = new BannerUC(   @stream, 'Go', [4, 4,92,16], [ 4,  4, 46, 46] )
    @dealsUC    = new DealsUC(    @stream, 'Go', [4,24,92,42], [50,  4, 46, 46] )
    @driveBarUC = new DriveBarUC( @stream, 'Go', [4,66,92,30], [ 4, 54, 92, 42] )
    @first = true

  ready:() ->
    @bannerUC.ready()
    @dealsUC.ready()
    @driveBarUC.ready()
    @$ = $( @html() )
    @$.append( @bannerUC.$, @dealsUC.$, @driveBarUC.$ )

  position:( screen ) ->
    @bannerUC  .position( screen )
    @dealsUC   .position( screen )
    @driveBarUC.position( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen) => @onScreen( screen ) )
    @stream.subscribe( 'Trip',   (trip)   => @onTrip(   trip   ) )

  onScreen:( screen ) ->
    Util.noop( 'GoUI.screen()', screen )

  onTrip:( trip ) ->
    Util.noop('GoUI.onTrip()',   trip.recommendation )

  html:() ->
    """<div id="#{Util.id('GoUI')}" class="#{Util.css('GoUI')}"></div>"""

  show:() -> @$.show()
  hide:() -> @$.hide()