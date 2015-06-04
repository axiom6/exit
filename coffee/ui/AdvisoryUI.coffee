
class AdvisoryUI

  Util.Export( AdvisoryUI, 'ui/AdvisoryUI' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (location)    => @onLocation(location) )
    @stream.subscribe( 'Orient',   (orientation) => @layout(orientation)  )

  onLocation:( location ) ->
    Util.noop( 'AdvisoryUI.onLocation()', @ext, location )

  layout:( orientation ) ->
    Util.dbg( 'AdvisoryUI.layout()', orientation )

  html:() ->
    """<div id="#{Util.id('Advisory')}" class="#{Util.css('Advisory')}"></div>"""
