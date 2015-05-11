
class DriveBar

  Util.Export( DriveBar, 'ui/DriveBar' )

  constructor:( @app, @stream, @ext ) ->
    @hPercent = 0.2 # Needs to match DriveBar CSS at 20%
    @name = 'DriveBar'

  html:() ->
    @htmlId = @app.id(@name,@ext)                                          # For createSvg()
    htm     = """<div id="#{@htmlId}" class="#{@app.css(@name)}"></div>"""  # May or may not need ext for CSS
    @$      = $(htm)
    htm

  # DriveBar has a postReady does not have a ready() method since it is embedded
  postReady:() ->
    [@svg,@$svg,@g,@$g] = @createSvg( @$, @htmlId, @name, @ext, @app.width(), @app.height()*@hPercent )

  layout:() ->

  show:() ->

  hide:() ->

# d3 Svg dependency
  createSvg:( $, htmlId, name, ext, width, height ) ->
    svgId = @app.svgId(  name, ext, 'Svg' )
    gId   = @app.svgId(  name, ext, 'G'   )
    svg   = d3.select('#'+htmlId).append("svg:svg").attr("id",svgId).attr("width",width).attr("height",height)
    g     = svg.append("svg:g").attr("id",gId) # All tranforms are applied to g
    $svg  = $.find( '#'+svgId )
    $g    = $.find( '#'+gId   )
    [svg,$svg,g,$g]

  createBars:( segments, conditions, Data ) ->
    DataSegments = if @app.direction is 'West' then Data.WestSegments.features else Data.EastSegments.features
    n        = DataSegments.length-1
    mileBeg  = DataSegments[0].beg
    mileEnd  = DataSegments[n].end
    distance = Math.abs( mileEnd - mileBeg )
    pxBeg    = 0
    pxEnd    = @app.width()
    pxLen    = pxEnd - pxBeg
    height   = @app.height()*@hPercent
    y0       = height * 0.70
    h        = height * 0.20
    stroke   = 1
    for seg in DataSegments
      beg   = pxLen * seg.beg / distance
      end   = pxLen * seg.end / distance
      segId = Util.toInt(seq.id)
      fill = @fillCondtion( segId, conditions )
      @rect( @g, segId, beg, y0, end-beg, h, fill, stroke, '' )

  @fillCondition:( segId, conditions ) ->
    for condition in conditions
      if segId is condition.SegmentId
        return @fillColor( condition )
    'green'

  @fillColor:( condition ) ->
    color = 'gray'
    if condition.ExpectedTravelTime is 0 or condition.TravelTime is 0
      color = 'gray'
    else if condition.ExpectedTravelTime < condition.TravelTime * 0.50
      color = 'red'
    else if condition.ExpectedTravelTime < condition.TravelTime * 0.80
      color = 'yellow'
    else if condition.ExpectedTravelTime > condition.TravelTime * 0.80
      color = 'green'
    color

  updateBars:( segments, conditions, Data ) ->
    for seg in DataSegments
      segId = Util.toInt(seq.id)
      fill  = @fillCondtion( segId, conditions )
      @updateRectFill( segId, fill )

  rect:( g, segId, x0, y0, w, h, fill, stroke, text='' ) ->
    svgId = @app.svgId( @name, segId.toString(), @ext )
    g.append("svg:rect").attr('id',svgId).attr("x",x0).attr("y",y0).attr("width",w).attr("height",h)
     .attr("fill",fill).attr("stroke",stroke)
    if text isnt ''
      g.append("svg:text").text(text).attr("x",x0+w/2).attr("y",y0+h/2+2).attr('fill',@textFill(fill))
       .attr("text-anchor","middle").attr("font-size","4px").attr("font-family","Arial")
    return

  updateRectFill:( segId, fill ) ->
    rectId = @app.svgId( @name, segId.toString(), @ext )
    rect   = $svg.find('#'+rectId)
    rect.attr( 'fill', fill )

