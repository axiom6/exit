
class NoGoUI

  Util.Export( NoGoUI, 'ui/NoGoUI' )

  constructor:( @stream ) ->
    DriveBarUI  = Util.Import( 'ui/DriveBarUI')
    @driveBarUI = new DriveBarUI( @stream, 'NoGo', @ )

  ready:() ->
    @$ = $( @html() )
    @$NoGoBanner     = @$.find('#NoGoBanner'    )
    @$NoGoBannerText = @$.find('#NoGoBannerText')
    @$NoGoDeals      = @$.find('#NoGoDeals'     )
    @driveBarUI.ready()

  position:( screen ) ->
    @driveBarUI.position( screen )
    #@noGoSize(  screen )
    @subscribe()

  html:() ->
    """<div      id="#{Util.id('NoGo')}"          class="#{Util.css('NoGo')}">
         <div   id="#{Util.id('NoGoBanner')}"     class="#{Util.css('NoGoBanner')}">
           <div id="#{Util.id('NoGoBannerText')}" class="#{Util.css('NoGoBannerText')}">NO GO</div>
         </div>
         <div id="#{Util.id('NoGoDeals')}"       class="#{Util.css('NoGoDeals')}">
           <div>50% off Hotel</div>
         </div>
         <div id="#{Util.id('NoGoDrive')}" class="#{Util.css('NoGoDrive')}">#{@driveBarUI.html('NoGo')}</div>
       </div>"""

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )
    @stream.subscribe( 'Deals',  (deals)    => @onDeals(  deals  ) )

  onScreen:( screen ) ->
    Util.noop( 'NavigateUI.onScreen()', screen )
    #@noGoSize( screen )

  onDeals:( deals ) ->
    return
    @$NoGoDeals.empty()
    html = @app.deals.goDealsHtml( deals )
    @$NoGoDeals.append( html )

  # Not used now
  noGoSize:( screen ) ->
    fontSize = if @first then screen.height * @$NoGoBanner.height() * 0.0065 else @$NoGoBanner.height() * 0.65
    #Util.dbg( '@$NoGoBanner.height()', { ah:@app.height(), gh:@$GoBanner.height(), fs:fontSize } )
    @$NoGoBannerText.css( { fontSize:fontSize+'px' })
    @first = false

  show:() -> @$.show()
  hide:() -> @$.hide()