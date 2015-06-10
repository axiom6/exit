
class SearchUC

  Util.Export( SearchUC, 'uc/SearchUC' )

  constructor:( @stream, @role, @port, @land, @dealsUC ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (location)  => @onLocation(location) )
    @stream.subscribe( 'Screen',   (screen)    => @onScreen(screen)     )

  onLocation:( location ) ->
    Util.noop( 'SearchUC.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  html:() ->
    """<div id="#{Util.id('SearchUC',@role)}" class="#{Util.css('SearchUC')}"></div>"""