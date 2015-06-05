
class BannerUC

  Util.Export( BannerUC, 'uc/BannerUC' )

  constructor:( @stream, @role, @port, @land ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (location)  => @onLocation(location) )
    @stream.subscribe( 'Screen',   (screen)    => @onScreen(screen)     )

  onLocation:( location ) ->
    Util.noop( 'BannerUC.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  html:() ->
    """<div id="#{Util.id('BannerUC')}" class="#{Util.css('BannerUC')}"></div>"""