
class Deals

  Util.Export( Deals, 'ui/Deals' )

  constructor:( @app, @stream ) ->
    @gritterId = 0

  ready:() ->
    @$ = $( @html() )
    @subscribe()

  html:() ->
    """<div id="#{@app.id('Deals')}" class="#{@app.css('Deals')}">Deals</div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()

  subscribe:() ->
    @stream.subscribe( 'Destination', (object) => @onDestination(object.content) )
    @stream.subscribe( 'Location',    (object) =>    @onLocation(object.content) )
    @stream.subscribe( 'Orient',      (object) =>        @layout(object.content) )
    @stream.subscribe( 'Deals',       (object) =>       @onDeals(object.content) )
    @stream.subscribe( 'Conditions',  (object) => @onConditions( object.content) )


  onDestination:( destination ) ->
    Util.log( 'Deals.onDestination()', destination )

  onLocation:( latlon ) ->
    Util.log( 'Deals.onLocation() latlon', latlon )

  layout:( orientation ) ->
    Util.log( 'Deals.layout()', orientation )

  onDeals:( deals ) ->
    for deal in deals
      Util.log( 'Deals.onDeals()', deal )

  onConditions:( conditions ) ->
    for condition in conditions
      Util.log( 'DriveBar.onConditions()', condition )

  doDeals:( args, deals ) =>
    Util.log( 'logDeals args',  args )
    Util.log( 'logDeals deals', deals.length )
    for d in deals
      dd = d.dealData
      Util.log( '  ', { segmentId:dd.segmentId, lat:d.lat, lon:d.lon,  buiness:d.businessName, description:d.name } )
    @app.dealsComplete = true
    @app.checkComplete()

  dataDeals:( ) ->
    @rest = @app.rest.dealsByUrl( 'http://localhost:63342/Exit-Now-App/data/exit/deals.json', @callDeals )

  callDeals:( args, deals ) =>
    @stream.push( 'Deals', deals, 'Deals' )
    @popupMultipleDeals( 'EXIT NOW!', 'Traffic is slow ahead', 'ETA +2.5 hrs', deals )

  segments:() ->
    [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]

  latLon:() ->
    [39.644407,-106.378767]

  showMeMyDeals:() ->
    @dataDeals()
    #@popupMike()

  popupMike:() ->
    @popup( 'EXIT NOW!', 'Traffic is slow ahead', 'ETA +2.5 hrs', 'Stop now for ', 'FREE DINNER' )

  popupMultipleDeals:( title, traffic, eta, deals ) ->
    dataId = "IAMEXITING1"
    @gritterId++
    opts = {}
    opts.title = """<div style="text-align:center; font-size:2.0em;"><div>#{title}</div></div>"""
    opts.text  = """<div style="text-align:center; font-size:1.0em;">
                            <div><span>#{traffic}</span><span style="font-weight:bold;">#{eta}</span></div>"""
    for deal in deals
      opts.text += """<hr/>
                      <div style="font-size:0.9em;">#{deal.dealData.name        }</div>
                      <div style="font-size:0.9em;">#{deal.dealData.businessName}</div>"""
    html       = @iAmExiting(dataId)
    opts.text += html
    opts.class_name = "gritter-light"
    opts.sticky = true
    @deal( opts, dataId, @gritterId )

  iAmExiting:( dataId ) ->
    """<div style="margin-top:0.5em;"><span dataid="#{dataId}" style="font-size:0.9em; padding:0.3em; background-color:#658552; color:white;">I'M EXITING</span></div></div>"""

  popup:( title, traffic, eta, stop, reward ) ->
    dataId = "IAMEXITING1"
    @gritterId++
    opts = {}
    opts.title = """<div style="text-align:center; font-size:2.0em;"><div>#{title}</div></div><hr/>"""
    opts.text  = """<div style="text-align:center; font-size:1.0em;">
                      <div><span>#{traffic}</span><span style="font-weight:bold;">#{eta}</span></div>
                      <div style="font-size:0.9em;"><span>#{stop}<span style="font-weight:bold;">#{reward}</span></div>"""
    opts.text += @iAmExiting() + "</div>"
    opts.class_name = "gritter-light"
    opts.sticky = true
    @deal( opts, dataId, @gritterId )

  deal:( opts, dataId, gritterId ) ->
    @gritter( opts )
    @enableClick( dataId, gritterId )

  enableClick:( dataId, gritterId ) ->
    $("[dataid=#{dataId}]").click( () ->
      Util.log( "I'M EXITING" )
      $.gritter.remove( gritterId ) )

  gritter:( opts ) ->
    $.gritter.add( opts )

  ###
    $.gritter.add({
      title: 'This is a regular notice!', // (string | mandatory) the heading of the notification
      text:                               // (string | mandatory) the text inside the notification
      image: 'bigger.png',                // (string | optional) the image to display on the left
      sticky: false,                      // (bool | optional) if you want it to fade out on its own or just sit there
      time: 8000,                         // (int | optional) the time you want it to be alive for before fading out (milliseconds)
      class_name: 'my-class',             // (string | optional) the class
   ###
