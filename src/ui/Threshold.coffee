
class Threshold

  Util.Export( Threshold, 'ui/Threshold' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )

  position:() ->
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Orient', (object) =>  @layout(object.content) )

  layout:( orientation ) ->
    Util.dbg( 'Threshold.layout()', orientation )

  html:() ->
    """<div id="#{@app.id('Threshold')}"       class="#{@app.css('Threshold')}">
       <div id="#{@app.id('ThresholdAdjust')}" class="#{@app.css('ThresholdAdjust')}">Adjust Threshold</div>
       <img src="img/app/Threshold.png">
    </div>"""

  show:() -> @$.show()
  hide:() -> @$.hide()