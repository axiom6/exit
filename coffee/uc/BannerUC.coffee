
class BannerUC

  Util.Export( BannerUC, 'uc/BannerUC' )

  constructor:( @stream, @role, @port, @land ) ->
    @screen         = {}
    @recommendation = '?'

  ready:() ->
    @$ = $( @html() )
    @$bannerText = @$.find('#BannerText')

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (location)  => @onLocation( location ) )
    @stream.subscribe( 'Screen',   (screen)    => @onScreen(   screen   ) )
    @stream.subscribe( 'Trip',     (trip)      => @onTrip(     trip     ) )

  onLocation:( location ) ->
    Util.noop( 'BannerUC.onLocation()', @ext, location )

  onTrip:( trip ) ->
    @changeRecommendation( trip.recommendation )

  changeRecommendation:( recommendation ) ->
    @recommendation = recommendation
    klass = if recommendation is 'GO' then 'GoBanner' else 'NoGoBanner'
    @$.attr('class', klass )
    @resetText()

  resetText:() ->
    html =  if @recommendation is 'NO GO' and @screen.orientation is 'Landscape' then 'NO<br/>GO' else @recommendation
    @$bannerText.html( html )
    #@$.css( { fontSize:'60px' } )
    #Util.dbg( 'BannerUC.changeRecommendation() fontSize', screen.height*scale+'px', screen.height, scale )

  onScreen:( screen ) ->
    @screen = screen
    Util.cssPosition( @$, screen, @port, @land )
    @resetText()

  html:() ->
    """<div   id="#{Util.id('BannerUC')}"   class="#{Util.css('GoBannerUC')}">
         <div id="#{Util.id('BannerText')}" class="#{Util.css('BannerText')}">GO</div>
       </div>"""