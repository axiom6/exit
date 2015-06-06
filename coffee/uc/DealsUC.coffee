
class DealsUC

  Util.Export( DealsUC, 'uc/DealsUC' )

  constructor:( @stream, @role, @port, @land ) ->
    @gritterId = 0
    @uom = 'em'
    @dealsData = []
    @isVisible = false

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  html:() ->
    """<div id="#{Util.id('DealsUC',@role)}" class="#{Util.css('DealsUC')}"></div>"""

  show:() ->
    @isVisible = true
    @$.show()
    #$('#gritter-notice-wrapper').show()

  hide:() ->
    @isVisible = false
    #$('#gritter-notice-wrapper').hide()
    @$.hide()

  subscribe:() ->
    @stream.subscribe( 'Trip',        (trip)        => @onTrip(trip)              )
    @stream.subscribe( 'Location',    (location)    => @onLocation(location)      )
    @stream.subscribe( 'Screen',      (screen)    => @onScreen(screen)     )
    @stream.subscribe( 'Deals',       (deals)       => @onDeals(deals)            )
    #@stream.subscribe( 'Conditions', (conditions)  => @onConditions( conditions) )

  onTrip:( trip ) ->
    Util.noop( 'Deals.onTrip()', trip )

  onLocation:( location ) ->
    Util.noop( 'DealsUC.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  latLon:() ->
    [39.574431,-106.09752]

  onDeals:( deals ) ->
    Util.dbg( 'DealsUI.onDeals()', deals[0].exit )
    @popupMultipleDeals( 'Deals', "for Exit ", "#{deals[0].exit}", deals )
    $('#gritter-notice-wrapper').show()

  onDeals2:( deals ) ->
    return
    @$GoDeals.empty()
    html = @app.deals.goDealsHtml( deals )
    @$GoDeals.append( html )

  onDeals3:( deals ) ->
    #@popupMultipleDeals( 'EXIT NOW!', 'Traffic is slow ', "ETA #{@app.etaHoursMins()}", deals )
    #$('#gritter-notice-wrapper').hide() if not @isVisible

  onConditions:( conditions ) ->
    Util.noop( 'Deals.onConditions()' )

  getGoDeals:()   -> @dealsData
  getNoGoDeals:() -> @dealsData
  getDeals:()     -> @dealsData

  setDealData:( args, deals ) =>
    @dealsData = deals

  callDeals:( args, deals ) =>
    @dealsData = deals
    @stream.publish( 'Deals', deals )

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
      Util.dbg( 'Deal.TakeDeal', dealId )
      @stream.publish(  'TakeDeal', dealId ) )

  gritter:( opts ) ->
    $.gritter.add( opts )

  iAmExiting:( dataId ) ->
    """<div style="margin-top:0.5em;"><span dataid="#{dataId}" style="font-size:0.9em; padding:0.3em; background-color:#658552; color:white;">I'M EXITING</span></div></div>"""

  deal:( opts, dataId, gritterId ) ->
    @gritter( opts )
    @enableIamExitingClick( dataId, gritterId )

  enableIamExitingClick:( dataId, gritterId ) ->
    $("[dataid=#{dataId}]").click( () ->
      Util.dbg( "I'M EXITING" )
      $.gritter.remove( gritterId ) )
