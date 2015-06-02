
class NoGoUI

  Util.Export( NoGoUI, 'ui/NoGoUI' )

  constructor:( @app, @stream ) ->
    DriveBarUI  = Util.Import( 'ui/DriveBarUI')
    @driveBarUI = new DriveBarUI( @app, @stream, 'NoGo', @, 'Portrait' )

  ready:() ->
    @$ = $( @html() )
    @$NoGoBanner     = @$.find('#NoGoBanner'    )
    @$NoGoBannerText = @$.find('#NoGoBannerText')
    @$NoGoDeals      = @$.find('#NoGoDeals'     )
    @driveBarUI.ready()

  position:() ->
    @driveBarUI.position()
    #@noGoSize()
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