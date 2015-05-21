
class DriveBarUI

  Util.Export( DriveBarUI, 'ui/DriveBarUI' )

  constructor:( @app, @stream, @ext, @parent, @orientation ) ->
    @Data    = Util.Import( 'app/Data' )
    @name    = 'DriveBar'
    @created = false

  html:() ->
    @htmlId = @app.id(@name,@ext)                                          # For createSvg()
    htm     = """<div id="#{@htmlId}" class="#{@app.css(@name)}"></div>"""  # May or may not need ext for CSS
    @$      = $(htm)
    htm

  ready:() ->

  position:() ->
    [@svg,@$svg,@g,@$g,@gw,@gh,@y0] = @createSvg( @$, @htmlId, @name, @ext, @svgWidth(),  @svgHeight(), @barTop() )
    @left = @parent.$.offset().left
    @top  = @parent.$.offset().top
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location',   (object) => @onLocation( object.content ) )
    @stream.subscribe( 'Orient',     (object) =>     @layout( object.content ) )
    @stream.subscribe( 'Trip',       (object) =>     @onTrip( object.content ) )

  onLocation:( latlon ) ->
    Util.dbg( 'DriveBar.onLocation()', @ext, latlon )

  onTrip:( trip ) =>
    if not @created
      @createBars( trip, @Data )
    else
      @updateBars( trip, @Data )

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
    svgId = @app.svgId(  name, ext, 'Svg' )
    gId   = @app.svgId(  name, ext, 'G'   )
    svg   = d3.select('#'+htmlId).append("svg:svg").attr("id",svgId).attr("width",width).attr("height",height)
    g     = svg.append("svg:g").attr("id",gId) # All tranforms are applied to g
    $svg  = $.find( '#'+svgId )
    $g    = $.find( '#'+gId   )
    [svg,$svg,g,$g,width,height,barTop]

  createBars:( trip, Data ) ->
    @mileBeg  = trip.begMile()
    @mileEnd  = trip.endMile()
    @mileRef  = if trip.direction is 'West' then @mileBeg else @mileEnd
    @distRel  = @mileEnd - @mileBeg
    @distance = Math.abs( @mileEnd - @mileBeg )
    thick    = 1
    x        = 0
    y        = @barTop()
    w        = @svgWidth()
    h        = @barHeight()
    eta      = @app.model.etaHoursMins(Util.toInt(trip.eta))
    @createTravelTime( trip, @g, x, y, w, h )
    @rect( @g, @ext+'Border', x, y, w, h, 'transparent', 'white', thick*4, '' )
    for own key, seg of trip.segments
      m1    = Util.toFloat(seg.StartMileMarker)
      m2    = Util.toFloat(seg.EndMileMarker)
      beg   = w * Math.abs( m1 - @mileRef ) / @distance
      end   = w * Math.abs( m2 - @mileRef ) / @distance
      segId = Util.toInt(key.substring(2))
      fill = @fillCondition( segId, trip.conditions )
      @rect( @g, segId, beg, y, end-beg, h, fill, 'black', thick, '' )
      @created  = true
    return

  createTravelTime:( trip, g, x, y, w, h ) ->
    fontSize  = 18
    fontSizePx = fontSize + 'px'
    g.append("svg:text").text(trip.source).attr("x",4).attr("y",y-fontSize).attr('fill','white')
     .attr("text-anchor","start").attr("font-size",fontSizePx).attr("font-family","Droid Sans")
    g.append("svg:text").text('TRAVEL TIME').attr("x",w/2).attr("y",y-fontSize*2.2 ).attr('fill','white')
     .attr("text-anchor","middle").attr("font-size",fontSizePx).attr("font-family","Droid Sans")
    g.append("svg:text").text(trip.etaHoursMins()).attr("x",w/2).attr("y",  y-fontSize ).attr('fill','white')
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

  updateBars:( trip, Data ) ->
    Util.dbg( 'updateBars', @ext )
    for condition in trip.conditions
      segId = Util.toInt(condition.SegmentId)
      fill  = @fillSpeed( condition.Conditions.AverageSpeed )
      @updateRectFill( segId, fill )
    return

  rect:( g, segId, x0, y0, w, h, fill, stroke, thick, text ) ->
    svgId = @app.svgId( @name, segId.toString(), @ext )
    onClick = () =>
      `x = d3.mouse(this)[0]`
      mile  = @mileRef + @distRel *  x / @svgWidth()
      Util.dbg( 'DriveBar.rect()', { segId:segId, mile:Util.toFixed(mile,1) } )
      @doSeqmentDeals(segId,mile)
    g.append("svg:rect").attr('id',svgId).attr("x",x0).attr("y",y0).attr("width",w).attr("height",h).attr('segId',segId)
     .attr("fill",fill).attr("stroke",stroke).attr("stroke-width",thick)
     .on('click',onClick) #.on('mouseover',onMouseOver)

    if text isnt ''
      g.append("svg:text").text(text).attr("x",x0+w/2).attr("y",y0+h/2+2).attr('fill',fill)
       .attr("text-anchor","middle").attr("font-size","4px").attr("font-family","Droid Sans")
    return

  doSeqmentDeals:( segId, mile ) ->
    deals = @app.model.getDealsBySegId( segId )
    exit  = Util.toInt(mile)
    if deals.length > 0
      @app.deals.popupMultipleDeals( 'Deals', "for Exit ", "#{exit}", deals )
      $('#gritter-notice-wrapper').show()

  updateRectFill:( segId, fill ) ->
    rectId = @app.svgId( @name, segId.toString(), @ext )
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

