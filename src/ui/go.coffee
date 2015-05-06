
class Go

  Util.Export( Go, 'ui/Go' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Go')}"         class="#{@app.css('Go')}">
         <div id="#{@app.id('GoBanner')}" class="#{@app.css('GoBanner')}">GO</div>
         <div id="#{@app.id('GoDeals')}"  class="#{@app.css('GoDeals')}">
           <div>11 deals at your destination</div>
           <div>get going to beat traffic!</div>
         </div>
         <div id="#{@app.id('GoDrive')}" class="#{@app.css('GoDrive')}">
           <img src="img/app/DriveBar.png" width="362">
         </div>
       </div>"""

  layout:() ->

  show:() -> @$.show()
  hide:() -> @$.hide()