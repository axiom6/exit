
class NoGoUI

  Util.Export( NoGoUI, 'ui/NoGoUI' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'NoGo', @, 'Portrait' )

  ready:() ->
    @$ = $( @html() )
    @$NoGoBanner     = @$.find('#NoGoBanner'    )
    @$NoGoBannerText = @$.find('#NoGoBannerText')
    @$NoGoDeals      = @$.find('#NoGoDeals'     )
    @driveBar.ready()

  position:() ->
    @driveBar.position()
    #@noGoSize()
    @subscribe()

  html:() ->
    """<div      id="#{@app.id('NoGo')}"          class="#{@app.css('NoGo')}">
         <div   id="#{@app.id('NoGoBanner')}"     class="#{@app.css('NoGoBanner')}">
           <div id="#{@app.id('NoGoBannerText')}" class="#{@app.css('NoGoBannerText')}">NO GO</div>
         </div>
         <div id="#{@app.id('NoGoDeals')}"       class="#{@app.css('NoGoDeals')}">
           <div>50% off Hotel</div>
         </div>
         <div id="#{@app.id('NoGoDrive')}" class="#{@app.css('NoGoDrive')}">#{@driveBar.html('NoGo')}</div>
       </div>"""

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )
    @stream.subscribe( 'Deals',  (object) => @onDeals(object.content) )

  layout:( orientation ) ->
    Util.dbg( 'NoGo.layout()', orientation )
    @noGoSize()

  onDeals:( deals ) ->
    @$NoGoDeals.empty()
    html = @app.deals.goDealsHtml( deals )
    @$NoGoDeals.append( html )

  # No use yet
  noGoSize:() ->
    fontSize = if @first then @app.height() * @$NoGoBanner.height() * 0.0065 else @$NoGoBanner.height() * 0.65
    #Util.dbg( '@$NoGoBanner.height()', { ah:@app.height(), gh:@$GoBanner.height(), fs:fontSize } )
    @$NoGoBannerText.css( { fontSize:fontSize+'px' })
    @first = false

  show:() -> @$.show()
  hide:() -> @$.hide()