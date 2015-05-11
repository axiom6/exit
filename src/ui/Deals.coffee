
class Deals

  Util.Export( Deals, 'ui/Deals' )

  constructor:( @app, @model ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    """<div id="#{@app.id('Deals')}" class="#{@app.css('Deals')}">Deals</div>"""

  layout:() ->

  show:() -> @$.show()

  hide:() -> @$.hide()

  doDeals:( args, deals ) =>
    Util.log( 'logDeals args',  args )
    Util.log( 'logDeals deals', deals.length )
    for d in deals
      dd = d.dealData
      Util.log( '  ', { segmentId:dd.segmentId, lat:d.lat, lon:d.lon,  buiness:d.businessName, description:d.name } )
    @app.dealsComplete = true
    @app.checkComplete()

  segments:() ->
    [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]

  latLon:() ->
    [39.644407,-106.378767]
