
class NavigateUI

  Util.Export( NavigateUI, 'ui/NavigateUI' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )

  layout:( orientation ) ->
    Util.dbg( 'Navigate.layout()', orientation )

  html:() ->
    """<div id="#{Util.id('Navigate')}" class="#{Util.css('Navigate')}">Navigate</div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()