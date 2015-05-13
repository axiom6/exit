
class Advisory

  Util.Export( Advisory, 'ui/Advisory' )

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( @html() )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (object) => @onLocation(object.content) )
    @stream.subscribe( 'Orient',   (object) =>     @layout(object.content) )

  onLocation:( latlon ) ->
    Util.log( 'Advisory.onLocation()', @ext, latlon )

  layout:( orientation ) ->
    Util.log( 'Advisory.layout()', orientation )

  html:() ->
    """<div id="#{@app.id('Advisory')}" class="#{@app.css('Advisory')}"></div>"""


  show:() ->

  hide:() ->