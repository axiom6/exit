
import Util          from '../util/Util.js'

class DriveBarUC

  # @port [0,0,92,33] @land =[0,0,100,50
  constructor:( @stream, @role, @port, @land ) ->
    @name     = 'DriveBar'
    @lastTrip = { name:'' }
    @created  = false
    @screen   = null # Set by position() updated by position()
    Util.noop( @onScreenTransform )

  html:() ->
    @htmlId = Util.id(@name,@role)                                          # For createSvg()
    """<div id="#{@htmlId}" class="#{Util.css(@name)}"></div>"""  # May or may not need ext for CSS

  ready:() ->
    @$ = $( @html() )

  position:( screen ) ->
    # Util.dbg( 'DriveBarUC.position()', @role, screen )
    @screen      = screen
    #@screenOrig = screen
    Util.cssPosition( @$, @screen, @port, @land )
    [@svg,@$svg,@g,@$g,@gId,@gw,@gh,@y0] = @createSvg( @$, @htmlId, @name, @role, @svgWidth(),  @svgHeight(), @barTop() )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', 'Deals', (location) => @onLocation( location ) )
    @stream.subscribe( 'Screen',   'Deals', (screen)   => @onScreen(   screen   ) )
    @stream.subscribe( 'Trip',     'Deals', (trip)     => @onTrip(     trip     ) )

  onLocation:( location ) ->
    Util.noop( 'DriveBarUC.onLocation()', @role, location )

  onTrip:( trip ) =>
    if not @created or trip.name isnt @lastTrip.name
      @createBars( trip )
    else
      @updateFills( trip )
    @lastTrip = trip

  onScreen:(  screen ) ->
    @screen = screen
    Util.cssPosition( @$, @screen, @port, @land )
    @svg.attr( "width", @svgWidth() ).attr( 'height', @svgHeight() )
    @createBars( @lastTrip )

  # Screenlayout changes base on orientation not working
  onScreenTransform:( next ) ->
    prev    = @screen
    @screen = next
    Util.cssPosition( @$, @screen, @port, @land )
    @svg.attr( "width", @svgWidth() ).attr( 'height', @svgHeight() )
    xp = 0
    yp = 0
    xn = 0
    yn = 0
    [xp,yp] = if prev.orientation is 'Portrait' then [@port[2],@port[3]] else [@land[2],@land[3]]
    [xn,yn] = if next.orientation is 'Portrait' then [@port[2],@port[3]] else [@land[2],@land[3]]
    xs = next.width  * xn  / ( prev.width  * xp )
    ys = next.height * yn  / ( prev.height * yp )
    @g.attr( 'transform', "scale(#{xs},#{ys})" )
    return

  # index 2 is width index 3 is height
  svgWidth: () -> if @screen.orientation is 'Portrait' then @screen.width  * @port[2]/100 else @screen.width  * @land[2]/100
  svgHeight:() -> if @screen.orientation is 'Portrait' then @screen.height * @port[3]/100 else @screen.height * @land[3]/100
  barHeight:() -> @svgHeight() * 0.33
  barTop:   () -> @svgHeight() * 0.50

  # d3 Svg dependency
  createSvg:( $, htmlId, name, ext, width, height, barTop ) ->
    svgId = Util.svgId(  name, ext, 'Svg' )
    gId   = Util.svgId(  name, ext, 'G'   )
    svg   = d3.select('#'+htmlId).append("svg:svg").attr("id",svgId).attr("width",width).attr("height",height)
    g     = svg.append("svg:g").attr("id",gId) # All tranforms are applied to g
    $svg  = $.find( '#'+svgId )
    $g    = $.find( '#'+gId   )
    [svg,$svg,g,$g,gId,width,height,barTop]

  createBars:( trip ) ->
    d3.select('#'+@gId).selectAll("*").remove()
    @mileBeg  = trip.begMile()
    @mileEnd  = trip.endMile()
    @distance = Math.abs( @mileEnd - @mileBeg )
    # Util.dbg( 'DriveBarUC.createBars() 1', { mileBeg:@mileBeg, mileEnd:@mileEnd, distance:@distance } )
    thick    = 1
    x        = 0
    y        = @barTop()
    w        = @svgWidth()
    h        = @barHeight()
    @createTravelTime( trip, @g, x, y, w, h )
    @rect( trip, @g, trip.segments[0], @role+'Border', x, y, w, h, 'transparent', 'white', thick*4, '' )
    for seg in trip.segments
      beg   = w * Math.abs( Util.toFloat(seg['StartMileMarker']) - @mileBeg ) / @distance
      end   = w * Math.abs( Util.toFloat(seg['EndMileMarker'])   - @mileBeg ) / @distance
      fill  = @fillCondition( seg.segId, trip.conditions )
      # Util.dbg( 'DriveBarUC.createBars() 2', { segId:seg.segId, beg:beg, end:end,  w:Math.abs(end-beg) } )
      @rect( trip, @g, seg, seg.segId, beg, y, Math.abs(end-beg), h, fill, 'black', thick, '' )
    @created  = true
    return

  createTravelTime:( trip, g, x, y, w, h ) ->
    Util.noop( h )
    fontSize  = 18
    fontSizePx = fontSize + 'px'
    g.append("svg:text").text(trip.source).attr("x",4).attr("y",y-fontSize).attr('fill','white')
     .attr("text-anchor","start").attr("font-size",fontSizePx).attr("font-family","Droid Sans")
    g.append("svg:text").text('TRAVEL TIME').attr("x",w/2).attr("y",y-fontSize*3.3 ).attr('fill','white')
     .attr("text-anchor","middle").attr("font-size",fontSizePx).attr("font-family","Droid Sans")
    g.append("svg:text").text(trip.etaHoursMins()).attr("x",w/2).attr("y",y-fontSize*2.2 ).attr('fill','white')
     .attr("text-anchor","middle").attr("font-size",fontSizePx).attr("font-family","Droid Sans")
    g.append("svg:text").text(trip.destination).attr("x",w-4).attr("y",y-fontSize ).attr('fill','white')
     .attr("text-anchor","end").attr("font-size",fontSizePx).attr("font-family","Droid Sans")

  fillCondition:( segId, conditions ) ->
    Conditions = @getTheCondition( segId, conditions )
    return 'gray' if not Conditions? or not Conditions.AverageSpeed?
    @fillSpeed( Conditions.AverageSpeed )

  # Brute force array interation
  getTheCondition:( segId, conditions ) ->
    for  condition in conditions
      if condition.SegmentId? and condition['Conditions']?
        return condition['Conditions'] if segId is condition.SegmentId
    undefined

  fillSpeed:( speed ) ->
    fill = 'gray'
    if      50 < speed                 then fill = 'green'
    else if 25 < speed and speed <= 50 then fill = 'yellow'
    else if 15 < speed and speed <= 25 then fill = 'red'
    else if  0 < speed and speed <= 15 then fill = 'black'
    fill

  updateFills:( trip ) ->
    for condition in trip.conditions
      segId = Util.toInt(condition.SegmentId)
      fill  = @fillSpeed( condition['Conditions'].AverageSpeed )
      @updateRectFill( segId, fill )
    return

  rect:( trip, g, seg, segId, x0, y0, w, h, fill, stroke, thick, text ) ->

    svgId = Util.svgId( @name, segId.toString(), @role )

    onClick = () =>
      `x = d3.mouse(this)[0]`
      mile  = @mileBeg + (@mileEnd-@mileBeg) *  x / @svgWidth()
      console.log( 'DriveBar.rect()', { segId:segId, beg:seg['StartMileMarker'], mile:Util.toFixed(mile,1), end:seg['EndMileMarker'] } )
      @doSeqmentDeals(trip,segId,mile)

    g.append("svg:rect").attr('id',svgId).attr("x",x0).attr("y",y0).attr("width",w).attr("height",h).attr('segId',segId)
     .attr("fill",fill).attr("stroke",stroke).attr("stroke-width",thick)
     .on('click',onClick) #.on('mouseover',onMouseOver)

    if text isnt ''
      g.append("svg:text").text(text).attr("x",x0+w/2).attr("y",y0+h/2+2).attr('fill',fill)
       .attr("text-anchor","middle").attr("font-size","4px").attr("font-family","Droid Sans")
    return

  doSeqmentDeals:( trip, segId, mile ) ->
    deals = trip.getDealsBySegId( segId )
    Util.dbg( 'DriveBarUC.doSeqmentDeals()', deals.length )
    if deals.length > 0
       deals[0].exit = Util.toInt(mile)
       @stream.publish( 'Deals', deals )


  updateRectFill:( segId, fill ) ->
    rectId = Util.svgId( @name, segId.toString(), @role )
    rect   = @$svg.find('#'+rectId)
    rect.attr( 'fill', fill )
    return

`export default DriveBarUC`
