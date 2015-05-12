
class NoGo

  Util.Export( NoGo, 'ui/NoGo' )

  constructor:( @app, @stream ) ->
    DriveBar  = Util.Import( 'ui/DriveBar')
    @driveBar = new DriveBar( @app, @stream, 'NoGo' )

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
         <div id="#{@app.id('NoGoDrive')}" class="#{@app.css('NoGoDrive')}">#{@driveBar.html('NoGo')}</div>
       </div>"""

  postReady:() ->
    @driveBar.postReady()

  layout:( orientation ) ->
    Util.noop( orientation )
    @driveBar.layout( orientation )

  show:() -> @$.show()
  hide:() -> @$.hide()