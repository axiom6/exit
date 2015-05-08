
class Go

  Util.Export( Go, 'ui/Go' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'Go' )

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Go')}"         class="#{@app.css('Go')}">
         <div   id="#{@app.id('GoBanner')}"     class="#{@app.css('GoBanner')}">
           <div id="#{@app.id('GoBannerText')}" class="#{@app.css('GoBannerText')}">GO</div>
         </div>
         <div id="#{@app.id('GoDeals')}"  class="#{@app.css('GoDeals')}">
           <div>11 deals at your destination</div>
           <div>get going to beat traffic!</div>
         </div>
         <div id="#{@app.id('GoDrive')}" class="#{@app.css('GoDrive')}">#{@driveBar.html('Go')}</div>
       </div>"""

  postReady:() ->
    @driveBar.postReady()

  layout:() ->

  show:() -> @$.show()
  hide:() -> @$.hide()