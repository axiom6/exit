
class NavigateUI

  Util.Export( NavigateUI, 'ui/NavigateUI' )

  constructor:( @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    Util.noop( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )

  onScreen:( screen ) ->
    Util.noop( 'NavigateUI.onScreen()', screen )

  html:() ->
    """<div id="#{Util.id('NavigateUI')}" class="#{Util.css('NavigateUI')}">Navigate</div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()