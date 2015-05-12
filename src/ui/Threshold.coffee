
class Threshold

  Util.Export( Threshold, 'ui/Threshold' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Threshold')}"       class="#{@app.css('Threshold')}">
       <div id="#{@app.id('ThresholdAdjust')}" class="#{@app.css('ThresholdAdjust')}">Adjust Threshold</div>
       <img src="img/app/Threshold.png">
    </div>"""

  layout:( orientation ) ->
    Util.noop( orientation )

  show:() -> @$.show()
  hide:() -> @$.hide()