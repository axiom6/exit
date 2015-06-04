
class DriveBarUI

  Util.Export( DriveBarUI, 'ui/DriveBarUI' )

  constructor:( @app, @stream, @ext, @parent, @orientation ) ->
    @name     = 'DriveBar'
    @lastTrip = { name:'' }
    @created  = false

  html:() ->
    @htmlId = Util.id(@name,@ext)                                          # For createSvg()
    htm     = """<div id="#{@htmlId}" class="#{Util.css(@name)}"></div>"""  # May or may not need ext for CSS
    @$      = $(htm)
    htm

  ready:() ->

  position:() ->
    [@svg,@$svg,@g,@$g,@gId,@gw,@gh,@y0] = @createSvg( @$, @htmlId, @name, @ext, @svgWidth(),  @svgHeight(), @barTop() )
    @left = @parent.$.offset().left
    @top  = @parent.$.offset().top
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location', (location)    => @onLocation( location ) )
    @stream.subscribe( 'Orient',   (orientation) => @layout( orientation )  )
    @stream.subscribe( 'Trip',     (trip)        => @onTrip( trip )         )

  onLocation:( location ) ->
    Util.noop( 'DriveBar.onLocation()', @ext, location )

  onTrip:( trip ) =>
    if not @created or trip.name isnt @lastTrip.name
      @createBars( trip )
    else
      @updateFills( trip )
    @lastTrip = trip

  # layout changes base on orientation not working
  layout:( orientation ) ->
    Util.noop( orientation )
    return

  # The svg methods are hacked up do to layout:( orientation ) change orientation difficulties
  svgWidth:()   -> if @orientation is 'Portrait' then @app.width()  * 0.92 else @app.height()
  svgHeight:()  -> if @orientation is 'Portrait' then @app.height() * 0.33 else @app.width() * 0.50
  barHeight:()  -> @svgHeight() * 0.33
  barTop:()     -> @svgHeight() * 0.50

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
    # Util.dbg( 'DriveBarUI.createBars() 1', { mileBeg:@mileBeg, mileEnd:@mileEnd, distance:@distance } )
    thick    = 1
    x        = 0
    y        = @barTop()
    w        = @svgWidth()
    h        = @barHeight()
    @createTravelTime( trip, @g, x, y, w, h )
    @rect( trip, @g, trip.segments[0], @ext+'Border', x, y, w, h, 'transparent', 'white', thick*4, '' )
    for seg in trip.segments
      beg   = w * Math.abs( Util.toFloat(seg.StartMileMarker) - @mileBeg ) / @distance
      end   = w * Math.abs( Util.toFloat(seg.EndMileMarker)   - @mileBeg ) / @distance
      fill  = @fillCondition( seg.segId, trip.conditions )
      # Util.dbg( 'DriveBarUI.createBars() 2', { segId:seg.segId, beg:beg, end:end,  w:Math.abs(end-beg) } )
      @rect( trip, @g, seg, seg.segId, beg, y, Math.abs(end-beg), h, fill, 'black', thick, '' )
    @created  = true
    return

  createTravelTime:( trip, g, x, y, w, h ) ->
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
    for condition in conditions
      if condition.SegmentId? and condition.Conditions?
        return condition.Conditions if segId is condition.SegmentId
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
      fill  = @fillSpeed( condition.Conditions.AverageSpeed )
      @updateRectFill( segId, fill )
    return

  rect:( trip, g, seg, segId, x0, y0, w, h, fill, stroke, thick, text ) ->

    svgId = Util.svgId( @name, segId.toString(), @ext )

    onClick = () =>
      `x = d3.mouse(this)[0]`
      mile  = @mileBeg + (@mileEnd-@mileBeg) *  x / @svgWidth()
      Util.dbg( 'DriveBar.rect()', { segId:segId, beg:seg.StartMileMarker, mile:Util.toFixed(mile,1), end:seg.EndMileMarker } )
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
    exit  = Util.toInt(mile)
    if deals.length > 0
      @app.dealsUI.popupMultipleDeals( 'Deals', "for Exit ", "#{exit}", deals )
      $('#gritter-notice-wrapper').show()

  updateRectFill:( segId, fill ) ->
    rectId = Util.svgId( @name, segId.toString(), @ext )
    rect   = $svg.find('#'+rectId)
    rect.attr( 'fill', fill )
    return

  # Transform version
  layout2:( orientation ) ->
    @orientation = orientation
    @svg.attr( "width", @svgWidth() ).attr( 'height', @svgHeight() )
    xs = if @gw > 0 then @gw / @svgWidth() else 1.0
    ys = 1.0
    @g.attr( 'transform', "scale(#{xs},#{ys})" )
    return

