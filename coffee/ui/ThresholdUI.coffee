
class ThresholdUI

  Util.Export( ThresholdUI, 'ui/ThresholdUI' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (orientation) =>  @layout(orientation) )

  layout:( orientation ) ->
    Util.dbg( 'Threshold.layout()', orientation )

  html:() ->
    """<div id="#{Util.id('Threshold')}"       class="#{Util.css('Threshold')}">
       <div id="#{Util.id('ThresholdAdjust')}" class="#{Util.css('ThresholdAdjust')}">Adjust Threshold</div>
       <img src="css/img/app/Threshold.png">
    </div>"""

  show:() -> @$.show()
  hide:() -> @$.hide()