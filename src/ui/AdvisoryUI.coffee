
class AdvisoryUI

  Util.Export( AdvisoryUI, 'ui/AdvisoryUI' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (object) => @onLocation(object.content) )
    @stream.subscribe( 'Orient',   (object) =>     @layout(object.content) )

  onLocation:( location ) ->
    Util.noop( 'AdvisoryUI.onLocation()', @ext, location )

  layout:( orientation ) ->
    Util.dbg( 'AdvisoryUI.layout()', orientation )

  html:() ->
    """<div id="#{Util.id('Advisory')}" class="#{Util.css('Advisory')}"></div>"""
