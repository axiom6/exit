
import Util     from '../util/Util.js'

class AdvisoryUC

  constructor:( @stream, @role, @port, @land ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', 'AdvisoryUC', (location)  => @onLocation(location) )
    @stream.subscribe( 'Screen',   'AdvisoryUC', (screen)    => @onScreen(screen)     )

  onLocation:( location ) ->
    Util.noop( 'AdvisoryUC.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  html:() ->
    """<div id="#{Util.id('AdvisoryUC',@role)}" class="#{Util.css('AdvisoryUC')}"></div>"""

`export default AdvisoryUC`
