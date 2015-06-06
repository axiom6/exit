
class BannerUC

  Util.Export( BannerUC, 'uc/BannerUC' )

  constructor:( @stream, @role, @port, @land ) ->

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
    # Util.dbg('BannerUC.onTrip()',   trip.recommendation )
    @$bannerText.text( trip.recommendation )
    klass = if trip.recommendation is 'GO' then 'GoBanner' else 'NoGoBanner'
    @$.attr('class', klass )
    scale = if @screen.orientation is 'Portrait' then @port[3]     else @land[3]
    scale = if trip.recommendation is 'GO'       then scale*0.0050 else scale*0.0030
    @$.css( { fontSize:screen.height*scale+'px' } )

  onScreen:( screen ) ->
    @screen = screen
    Util.cssPosition( @$, screen, @port, @land )


  html:() ->
    """<div   id="#{Util.id('BannerUC')}"   class="#{Util.css('GoBannerUC')}">
         <div id="#{Util.id('BannerText')}" class="#{Util.css('BannerText')}">GO</div>
       </div>"""