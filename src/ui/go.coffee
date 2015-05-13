
class Go

  Util.Export( Go, 'ui/Go' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'Go' )
    @first = true

  ready:() ->
    @$ = $( @html() )
    @$GoBanner     = @$.find('#GoBanner'    )
    @$GoBannerText = @$.find('#GoBannerText')
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )
    @stream.subscribe( 'Deals',  (object) => @onDeals(object.content) )


  layout:( orientation ) ->
    Util.log( 'Go.layout()', orientation )
    @goSize()
    #@driveBar.layout( orientation ) # Not needed

  onDeals:( deals ) ->
    for deal in deals
      Util.log( 'Go.onDeals()', deal )

  html:() ->
    """<div id="#{@app.id('Go')}"         class="#{@app.css('Go')}">
         <div   id="#{@app.id('GoBanner')}"     class="#{@app.css('GoBanner')}">
           <div id="#{@app.id('GoBannerText')}" class="#{@app.css('GoBannerText')}">GO</div>
         </div>
         <div id="#{@app.id('GoDeals')}"  class="#{@app.css('GoDeals')}">
           <div>11 deals at your destination</div>
           <div>get going to beat traffic!</div>
         </div>
         <div id="#{@app.id('GoDrive')}" class="#{@app.css('GoDrive')}">#{@driveBar.html('Go')}</div>
       </div>"""

  postReady:() ->
    @driveBar.postReady()
    @goSize()

  goSize:() ->
    fontSize = if @first then @app.height() * @$GoBanner.height() * 0.0065 else @$GoBanner.height() * 0.65
    Util.log( '@$GoBanner.height()', { ah:@app.height(), gh:@$GoBanner.height(), fs:fontSize } )
    @$GoBannerText.css( { fontSize:fontSize+'px' })
    @first = false


  show:() -> @$.show()
  hide:() -> @$.hide()