
class NoGo

  Util.Export( NoGo, 'ui/NoGo' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div      id="#{@app.id('NoGo')}"          class="#{@app.css('NoGo')}">
         <div   id="#{@app.id('NoGoBanner')}"     class="#{@app.css('NoGoBanner')}">
           <div id="#{@app.id('NoGoBannerText')}" class="#{@app.css('NoGoBannerText')}">NO GO</div>
         </div>
         <div id="#{@app.id('NoGoODeals')}"       class="#{@app.css('NoGoDeals')}">
           <div>50% off Hotel</div>
         </div>
         <div id="#{@app.id('NoGoDrive')}" class="#{@app.css('NoGoDrive')}">
           <img src="img/app/NoGoDriveBar.png" width="362">
         </div>
       </div>"""

  layout:() ->

  show:() -> @$.show()
  hide:() -> @$.hide()