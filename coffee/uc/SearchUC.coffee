
import Util  from '../util/Util.js'

class SearchUC

  constructor:( @stream, @role, @port, @land, @dealsUC ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', 'SearchUC', (location)  => @onLocation(location) )
    @stream.subscribe( 'Screen',   'SearchUC', (screen)    => @onScreen(screen)     )

  onLocation:( location ) ->
    Util.noop( 'SearchUC.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  html:() ->
    """<div id="#{Util.id('SearchUC',@role)}" class="#{Util.css('SearchUC')}"></div>"""

`export default SearchUC`