
class Deals

  Util.Export( Deals, 'ui/Deals' )

  constructor:( @app, @stream ) ->
    @gritterId = 0
    @uom = 'em'
    @dealsData = []
    @isVisible = false

  ready:() ->
    @$ = $( @html() )
    @subscribe()

  html:() ->
    """<div id="#{@app.id('Deals')}" class="#{@app.css('Deals')}"></div>"""

  show:() ->
    @isVisible = true
    @$.show()
    $('#gritter-notice-wrapper').show()

  hide:() ->
    @isVisible = false
    $('#gritter-notice-wrapper').hide()
    @$.hide()

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
    @popupMultipleDeals( 'EXIT NOW!', 'Traffic is slow ', "ETA #{@app.etaHoursMins()}", deals )
    $('#gritter-notice-wrapper').hide() if not @isVisible

  onConditions:( conditions ) ->
    for condition in conditions
      Util.log( 'DriveBar.onConditions()', condition )

  getGoDeals:()   -> @dealsData
  getNoGoDeals:() -> @dealsData
  getDeals:()     -> @dealsData

  dataDeals:() ->
    if @dealsData.length == 0
      @app.rest.dealsByUrl( 'http://localhost:63342/Exit-Now-App/data/exit/deals.json', @callDeals )

  setDealData:( args, deals ) =>
    @dealsData = deals

  callDeals:( args, deals ) =>
    @dealsData = deals
    @stream.push( 'Deals', deals, 'Deals' )

  popupMultipleDeals:( title, traffic, eta, deals ) ->
    opts   = @dealsOptsHtml( title, traffic, eta, deals )
    opts.class_name = "gritter-light"
    opts.sticky = true
    @gritter( opts )
    @enableTakeDealClick( deal._id ) for deal in deals

  fs:(size) ->
    size+@uom

  # placement is either Go NoGo Gritter Deals - This is a hack for now
  dealsOptsHtml:( title, traffic, eta, deals ) ->
    @uom = 'em'
    opts = {}
    opts.title = @dealsTitle(      title,        2.0 )
    opts.text  = @dealsTrafficEta( traffic, eta, 1.3 )
    opts.text += @dealHtml( deal, 1.2, true ) for deal in deals
    opts.text += """</div>"""  # Closes main centering div fron @dealTitle()
    opts

# placement is either Go NoGo Gritter Deals - This is a hack for now
  goDealsHtml:( deals ) ->
    @uom  = 'em'
    html  = ''
    html += @dealHtml( deal, 0.7, false ) for deal in deals
    html += """</div>"""  # Closes main centering div fron @dealTitle()
    html

  dealsTitle:( title, fontSize ) ->
    """<div style="text-align:center;">
         <div style="font-size:#{@fs(fontSize)};">#{title}</div>"""

  dealsTrafficEta:( traffic, eta, fontSize ) ->
    """<div style="font-size:#{@fs(fontSize)};"><span>#{traffic}</span><span style="font-weight:bold;"> #{eta}</span></div>"""

  dealHtml:( deal, fontSize, take ) ->
    padding  = 0.2 * fontSize
    takeSize = 0.6 * fontSize
    html  = """<hr  style="margin:#{@fs(padding)}"</hr>"""
    html += """<div style="font-size:#{@fs(fontSize)};">#{deal.dealData.name}</div>
               <div style="font-size:#{@fs(fontSize)};"><span>#{deal.dealData.businessName}</span>#{@takeDeal(deal._id,takeSize,padding,take)}</div>"""
    html

  takeDeal:( dealId, fontSize, padding, take ) ->
    if take
      style = "font-size:#{@fs(fontSize)}; margin-left:#{@fs(fontSize)}; padding:#{@fs(padding)}; border-radius:#{@fs(padding*2)}; background-color:#658552; color:white;"
      """<span dataid="#{dealId}" style="#{style}">Take Deal</span>"""
    else
      ''

  enableTakeDealClick:( dealId ) ->
    $("[dataid=#{dealId}]").click( () =>
      Util.log( 'Deal.TakeDeal', dealId )
      @stream.push(  'TakeDeal', dealId, 'Deal' ) )

  gritter:( opts ) ->
    $.gritter.add( opts )

  iAmExiting:( dataId ) ->
    """<div style="margin-top:0.5em;"><span dataid="#{dataId}" style="font-size:0.9em; padding:0.3em; background-color:#658552; color:white;">I'M EXITING</span></div></div>"""

  doDeals:( args, deals ) =>
    Util.log( 'logDeals args',  args )
    ###
    Util.log( 'logDeals deals', deals.length )
    for d in deals
      dd = d.dealData
      Util.log( '  ', { segmentId:dd.segmentId, lat:d.lat, lon:d.lon,  buiness:d.businessName, description:d.name } )
    ###
    @app.dealsComplete = true
    @app.checkComplete()

  deal:( opts, dataId, gritterId ) ->
    @gritter( opts )
    @enableIamExitingClick( dataId, gritterId )

  enableIamExitingClick:( dataId, gritterId ) ->
    $("[dataid=#{dataId}]").click( () ->
      Util.log( "I'M EXITING" )
      $.gritter.remove( gritterId ) )
