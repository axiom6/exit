
class AdvisoryUI

  Util.Export( AdvisoryUI, 'ui/AdvisoryUI' )

  constructor:( @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    Util.noop( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (location)  => @onLocation(location) )
    @stream.subscribe( 'Screen',   (screen)    => @onScreen(screen)     )

  onLocation:( location ) ->
    Util.noop( 'AdvisoryUI.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.noop( 'AdvisoryUI.screen()', screen )

  html:() ->
    """<div id="#{Util.id('Advisory')}" class="#{Util.css('Advisory')}"></div>"""
