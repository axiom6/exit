
class GoUI

  Util.Export( GoUI, 'ui/GoUI' )

  constructor:( @stream ) ->
    BannerUC    = Util.Import( 'uc/BannerUC'  )
    DealsUC     = Util.Import( 'uc/DealsUC'   )
    DriveBarUC  = Util.Import( 'uc/DriveBarUC')
    @bannerUC   = new BannerUC(   @stream, 'Go', [4, 4,92,29], [ 4,  4, 46, 46] )
    @dealsUC    = new DealsUC(    @stream, 'Go', [4,33,92,29], [50,  4, 46, 46] )
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
    @goSize(  screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen) => @onScreen( screen ) )
    @stream.subscribe( 'Trio',   (trip)   => @onTrip(   trip   ) )
    @stream.subscribe( 'Deals',  (deals)  => @onDeals(  deals  ) )

  onScreen:( screen ) ->
    Util.noop( 'GoUI.screen()', screen )
    @goSize( screen )

  onTrip:( trip ) ->
    @bannerUC.$.text( trip.recommendation )
    klass = if trip.recommendation is 'Go' then 'GoBanner' else 'NoGoBanner'
    @bannerUC.$.attr('class', klass )

  onDeals:( deals ) ->
    return
    @$GoDeals.empty()
    html = @app.deals.goDealsHtml( deals )
    @$GoDeals.append( html )

  html:() ->
    """<div id="#{Util.id('GoUI')}" class="#{Util.css('GoUI')}"></div>"""


  goSize:( screen ) ->
    fontSize = if @first then screen.height * @$GoBanner.height() * 0.0065 else @$GoBanner.height() * 0.65
    #Util.dbg( '@$GoBanner.height()', { ah:@app.height(), gh:@$GoBanner.height(), fs:fontSize } )
    @$GoBannerText.css( { fontSize:fontSize+'px' })
    @first = false

  show:() -> @$.show()
  hide:() -> @$.hide()