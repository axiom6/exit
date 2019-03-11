
class ThresholdUC

  Util.Export( ThresholdUC, 'uc/ThresholdUC' )

  constructor:( @stream, @ext, @port, @land ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', 'ThresholdUC', (screen)   => @onScreen( screen ) )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  html:() ->
    """<div id="#{Util.id('Threshold')}"       class="#{Util.css('Threshold')}">
       <div id="#{Util.id('ThresholdAdjust')}" class="#{Util.css('ThresholdAdjust')}">Adjust Threshold</div>
       <img src="css/img/app/Threshold.png" width="300" height="200">
    </div>"""

  show:() -> @$.show()
  hide:() -> @$.hide()