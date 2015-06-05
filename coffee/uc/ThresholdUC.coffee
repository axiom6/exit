
class ThresholdUC

  Util.Export( ThresholdUC, 'uc/ThresholdUC' )

  constructor:( @stream, @ext, @port, @land ) ->

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    Util.noop( screen )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )

  onScreen:( screen ) ->
    Util.noop( 'ThresholdUC.onScreen()', screen )

  html:() ->
    """<div id="#{Util.id('Threshold')}"       class="#{Util.css('Threshold')}">
       <div id="#{Util.id('ThresholdAdjust')}" class="#{Util.css('ThresholdAdjust')}">Adjust Threshold</div>
       <img src="css/img/app/Threshold.png">
    </div>"""

  show:() -> @$.show()
  hide:() -> @$.hide()