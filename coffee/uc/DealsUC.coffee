
import Util  from '../util/Util.js'

class DealsUC

  constructor:( @stream, @role, @port, @land ) ->
    @etaHoursMins = '?'
    @uom = 'em'
    Util.noop( @iAmExiting, @enableIamExitingClick )

  ready:() ->
    @$ = $( @html() )

  position:(   screen ) ->
    @onScreen( screen )
    @subscribe()

  html:() ->
    """<div id="#{Util.id('DealsUC',@role)}" class="#{Util.css('DealsUC')}"></div>"""

  subscribe:() ->
    @stream.subscribe( 'Trip',        'DealsUC', (trip)        => @onTrip(trip)              )
    @stream.subscribe( 'Location',    'DealsUC', (location)    => @onLocation(location)      )
    @stream.subscribe( 'Screen',      'DealsUC', (screen)      => @onScreen(screen)          )
    @stream.subscribe( 'Deals',       'DealsUC', (deals)       => @onDeals(deals)            )
    #@stream.subscribe( 'Conditions', 'DealsUC', (conditions)  => @onConditions( conditions) )

  onTrip:( trip ) ->
    @etaHoursMins = trip.etaHoursMins()
    @onDeals( trip.deals )

  onLocation:( location ) ->
    Util.noop( 'DealsUC.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )

  onConditions:( conditions ) ->
    Util.noop( 'Deals.onConditions()', conditions )

  onDeals:( deals ) ->
    #Util.dbg( 'DealsUI.onDeals()', deals[0].exit )
    html = @dealsHtml( "Exit Now", 'Traffic Slow', @etaHoursMins, deals )
    @$.append( html )
    @enableTakeDealClick( deal._id ) for deal in deals

# placement is either Go NoGo Gritter Deals - This is a hack for now
  dealsHtml:( title, traffic, eta, deals ) ->
    @uom = 'em'
    html  = ''
    html += @dealsTitle(      title,        1.00 )
    html += @dealsTrafficEta( traffic, eta, 0.75 )
    html += @dealHtml( deal, 0.80, true ) for deal in deals
    html += """</div>"""  # Closes main centering div fron @dealTitle()
    html

  dealsTitle:( title, fontSize ) ->
    """<div style="text-align:center;">
         <div style="font-size:#{@fs(fontSize)};">#{title}</div>"""

  dealsTrafficEta:( traffic, eta, fontSize ) ->
    """<div style="font-size:#{@fs(fontSize)};"><span>#{traffic}</span><span style="font-weight:bold;"> #{eta}</span></div>"""

  dealHtml:( deal, fontSize, take ) ->
    padding  = 0.2 * fontSize
    takeSize = 1.0 * fontSize
    html  = """<hr  style="margin:#{@fs(padding)}"</hr>"""
    html += """<div style="font-size:#{@fs(fontSize)};">#{deal['dealData'].name}</div>
               <div style="font-size:#{@fs(fontSize)};"><span>#{deal['dealData']['businessName']}</span>#{@takeDeal(deal._id,takeSize,padding,take)}</div>"""
    html

  fs:(size) ->
    size+@uom

  takeDeal:( dealId, fontSize, padding, take ) ->
    if take
      style = "font-size:#{@fs(fontSize)}; margin-left:#{@fs(fontSize)}; padding:#{@fs(padding)}; border-radius:#{@fs(padding*2)}; background-color:#E2492F; color:white;"
      """<span dataid="#{dealId}" style="#{style}">Take Deal</span>"""
    else
      ''

  enableTakeDealClick:( dealId ) ->
    @$.find("[dataid=#{dealId}]").click( () =>
      Util.dbg( 'Deal.TakeDeal', dealId )
      @stream.publish(  'TakeDeal', dealId ) )

  iAmExiting:( dataId ) ->
    """<div style="margin-top:0.5em;"><span dataid="#{dataId}" style="font-size:0.9em; padding:0.3em; background-color:#658552; color:white;">I'M EXITING</span></div></div>"""

  enableIamExitingClick:( dataId, gritterId ) ->
    $("[dataid=#{dataId}]").click( () ->
      Util.dbg( "I'M EXITING" )
      $.gritter.remove( gritterId ) )

`export default DealsUC`