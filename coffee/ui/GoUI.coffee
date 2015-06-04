
class GoUI

  Util.Export( GoUI, 'ui/GoUI' )

  constructor:( @app, @stream ) ->
    DriveBarUI  = Util.Import( 'ui/DriveBarUI')
    @driveBarUI = new DriveBarUI( @app, @stream, 'Go', @, 'Portrait' )
    @first = true

  ready:() ->
    @$ = $( @html() )
    @$GoBanner     = @$.find('#GoBanner'    )
    @$GoBannerText = @$.find('#GoBannerText')
    @$GoDeals      = @$.find('#GoDeals'     )
    @driveBarUI.ready()

  position:() ->
    @driveBarUI.position()
    @goSize()
    @subscribe()

  html:() ->
    """<div id="#{Util.id('Go')}"         class="#{Util.css('Go')}">
         <div   id="#{Util.id('GoBanner')}"     class="#{Util.css('GoBanner')}">
           <div id="#{Util.id('GoBannerText')}" class="#{Util.css('GoBannerText')}">GO</div>
         </div>
         <div id="#{Util.id('GoDeals')}"  class="#{Util.css('GoDeals')}">
           <div>11 deals at your destination</div>
           <div>get going to beat traffic!</div>
         </div>
         <div id="#{Util.id('GoDrive')}" class="#{Util.css('GoDrive')}">#{@driveBarUI.html('Go')}</div>
       </div>"""

  subscribe:() ->
    @stream.subscribe( 'Orient', (orientation) => @layout(orientation) )
    @stream.subscribe( 'Deals',  (deals)       => @onDeals(deals)      )

  layout:( orientation ) ->
    Util.dbg( 'Go.layout()', orientation )
    @goSize()

  onDeals:( deals ) ->
    @$GoDeals.empty()
    html = @app.deals.goDealsHtml( deals )
    @$GoDeals.append( html )

  goSize:() ->
    fontSize = if @first then @app.height() * @$GoBanner.height() * 0.0065 else @$GoBanner.height() * 0.65
    #Util.dbg( '@$GoBanner.height()', { ah:@app.height(), gh:@$GoBanner.height(), fs:fontSize } )
    @$GoBannerText.css( { fontSize:fontSize+'px' })
    @first = false

  show:() -> @$.show()
  hide:() -> @$.hide()