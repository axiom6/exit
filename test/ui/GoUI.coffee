
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
    """<div id="#{@app.id('Go')}"         class="#{@app.css('Go')}">
         <div   id="#{@app.id('GoBanner')}"     class="#{@app.css('GoBanner')}">
           <div id="#{@app.id('GoBannerText')}" class="#{@app.css('GoBannerText')}">GO</div>
         </div>
         <div id="#{@app.id('GoDeals')}"  class="#{@app.css('GoDeals')}">
           <div>11 deals at your destination</div>
           <div>get going to beat traffic!</div>
         </div>
         <div id="#{@app.id('GoDrive')}" class="#{@app.css('GoDrive')}">#{@driveBarUI.html('Go')}</div>
       </div>"""

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )
    @stream.subscribe( 'Deals',  (object) => @onDeals(object.content) )

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