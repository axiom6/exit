html:() ->
  i = 1
  htm = """<div class="Weather">"""
  for loc in Weather.Locs
    htm +=  """<div class="Weather1"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
       src="http://forecast.io/embed/#lon=-105.334724&lat=39.701735&name=Evergreen"> </iframe></div>"""
    <div class="Weather#{i}"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
    src="http://forecast.io/embed/#lon=#{loc.lon}&lat=#{loc.lat}&name=#{loc.name}">      </iframe></div>
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


  html3:() ->
    i = 1
    htm = """<div id="Weather" class="Weather"></div>""""
    for loc in Weather.Locs
      htm +=  """<div class="Weather#{i}"><iframe id="forecast_embed" type="text/html" frameborder="1" height="100%" width="100%"
    src="http://forecast.io/embed/#lon=#{loc.lon}&lat=#{loc.lat}&name=#{loc.name}"> </iframe></div>"""
      i = i + 1
    htm += """""
    htm


    html = """<div class="Weather#{loc.index}" style="text-align:center; background-color:#{f.style.back}">
                <div style="font-size:0.9em;">#{loc.name}</div>
                <div><i class="wi #{f.style.icon}" style="font-size:2.0em;"></i><span style="font-size:1.5em;"> #{f.temperature}&deg;</span></div>
                <div style="padding-top:0.2em;">#{f.summary}</div>
              </div>"""