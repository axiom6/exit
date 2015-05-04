
class Weather

  Util.Export( Weather, 'ui/Weather' )

  # Devner Lat 39.779062 -104.982605

  constructor:( @app ) ->

  ready:() ->
    @$ = $( @html() )


  # lon=-105.334724&lat=39.701735&name=Evergreen Pkwy"> </iframe></div>
  # lon=-105.654065&lat=39.759558&name=US40">           </iframe></div>
  # lon=-105.891111&lat=39.681757&name=East Tunnel">    </iframe></div>
  # lon=-105.878342&lat=39.692400&name=West Tunnel">    </iframe></div>
  # lon=-106.072685&lat=39.624160&name=Silverthorne">   </iframe></div>
  # lon=-106.147382&lat=39.503512&name=Copper Mtn">     </iframe></div>
  # lon=-106.216071&lat=39.531042&name=Vail Pass">      </iframe></div>
  # lon=-106.378767&lat=39.644407&name=Vail">           </iframe></div>

  html:() ->
    """<div class="Weather">
       <div class="Weather1"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-105.334724&lat=39.701735&name=Evergreen"> </iframe></div>
       <div class="Weather2"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-105.654065&lat=39.759558&name=US40 Exit">      </iframe></div>
       <div class="Weather3"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-105.891111&lat=39.681757&name=E Tunnel">    </iframe></div>
       <div class="Weather4"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-105.878342&lat=39.692400&name=W Tunnel">    </iframe></div>
       <div class="Weather5"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-106.072685&lat=39.624160&name=Silver">   </iframe></div>
       <div class="Weather6"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-106.147382&lat=39.503512&name=Copper">     </iframe></div>
       <div class="Weather7"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-106.216071&lat=39.531042&name=Vail Pass">      </iframe></div>
       <div class="Weather8"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-106.378767&lat=39.644407&name=Vail">           </iframe></div>
       </div>"""

  html2:() ->
    """<div id="#{@app.id('Weather')}" class="#{@app.css('Weather')}"></div>"""


  layout:() ->

  show:() ->

  hide:() ->