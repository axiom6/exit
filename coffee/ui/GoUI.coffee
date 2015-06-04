
class GoUI

  Util.Export( GoUI, 'ui/GoUI' )

  constructor:( @stream ) ->
    DriveBarUI  = Util.Import( 'ui/DriveBarUI')
    @driveBarUI = new DriveBarUI( @stream, 'Go', @ )
    @first = true

  ready:() ->
    @$ = $( @html() )
    @$GoBanner     = @$.find('#GoBanner'    )
    @$GoBannerText = @$.find('#GoBannerText')
    @$GoDeals      = @$.find('#GoDeals'     )
    @driveBarUI.ready()

  position:( screen ) ->
    @driveBarUI.position( screen )
    @goSize(  screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )
    @stream.subscribe( 'Deals',  (deals)    => @onDeals(  deals  ) )

  onScreen:( screen ) ->
    Util.noop( 'GoUI.screen()', screen )
    @goSize( screen )

  goSize:( screen ) ->
    fontSize = if @first then screen.height * @$GoBanner.height() * 0.0065 else @$GoBanner.height() * 0.65
    #Util.dbg( '@$GoBanner.height()', { ah:@app.height(), gh:@$GoBanner.height(), fs:fontSize } )
    @$GoBannerText.css( { fontSize:fontSize+'px' })
    @first = false

  onDeals:( deals ) ->
    return
    @$GoDeals.empty()
    html = @app.deals.goDealsHtml( deals )
    @$GoDeals.append( html )

  html:() ->
    """<div id="#{Util.id('Go')}"               class="#{Util.css('Go')}">
         <div   id="#{Util.id('GoBanner')}"     class="#{Util.css('GoBanner')}">
           <div id="#{Util.id('GoBannerText')}" class="#{Util.css('GoBannerText')}">GO</div>
         </div>
         <div id="#{Util.id('GoDeals')}"  class="#{Util.css('GoDeals')}">
           <div>11 deals at your destination</div>
           <div>get going to beat traffic!</div>
         </div>
         <div id="#{Util.id('GoDrive')}" class="#{Util.css('GoDrive')}">#{@driveBarUI.html('Go')}</div>
       </div>"""


  show:() -> @$.show()
  hide:() -> @$.hide()