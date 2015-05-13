
class DriveBar

  Util.Export( DriveBar, 'ui/DriveBar' )

  constructor:( @app, @stream, @ext ) ->
    @name = 'DriveBar'
    @heightPC = if @ext  is 'Road' then 0.55 else 0.30
    @portPC   = if @ext  is 'Road' then 0.30 else 0.50
    @landPC   = if @ext  is 'Road' then 0.50 else 0.20
    @topPC    = if @ext  is 'Road' then 3.00 else 1.00

  html:() ->
    @htmlId = @app.id(@name,@ext)                                          # For createSvg()
    htm     = """<div id="#{@htmlId}" class="#{@app.css(@name)}"></div>"""  # May or may not need ext for CSS
    @$      = $(htm)
    htm

  svgWidth:()   -> @app.width()  * 0.92 # Needs to match 92% in App.less
  svgHeight:()  -> @app.height() * @heightPC # Needs to match 30% or 55% in App.less
  barHeight:()  -> if @app.ui.orientation is 'Portrait' then @svgHeight()*@portPC        else @svgHeight()*@landPC
  barTop:()     -> if @app.ui.orientation is 'Portrait' then @barHeight()*@portPC*@topPC else @barHeight()*@landPC*@topPC


# DriveBar has a postReady does not have a ready() method since it is embedded
  postReady:() ->
    [@svg,@$svg,@g,@$g,@gw,@gh,@y0] = @createSvg( @$, @htmlId, @name, @ext, @svgWidth(), @svgHeight(), @barTop() )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location',   (object) => @onLocation(   object.content ) )
    @stream.subscribe( 'Orient',     (object) =>     @layout(   object.content ) )
    @stream.subscribe( 'Conditions', (object) => @onConditions( object.content ) )

  onLocation:( latlon ) ->
    Util.log( 'DriveBar.onLocation()', @ext, latlon )

  onConditions:( conditions ) ->
    for condition in conditions
      Util.log( 'DriveBar.onConditions()', condition )


  layout:( orientation ) ->
    Util.log( 'Drive.layout()', @ext, orientation, @svgWidth(), @svgHeight(), @barHeight(), @barTop() )
    @svg.attr( "width", @svgWidth() ).attr( 'height', @svgHeight() )
    xs = if @gw > 0 then @svgWidth()  / @gw else 1.0
    ys = if @gh > 0 then @svgHeight() / @gh else 1.0
    dy = @y0 - @barTop()
    @g.attr( 'transform', "scale(#{xs},#{ys}) translate(0,#{dy})" )
    @y0 = @barTop()
    return

  show:() ->

  hide:() ->

# d3 Svg dependency
  createSvg:( $, htmlId, name, ext, width, height, barTop ) ->
    svgId = @app.svgId(  name, ext, 'Svg' )
    gId   = @app.svgId(  name, ext, 'G'   )
    svg   = d3.select('#'+htmlId).append("svg:svg").attr("id",svgId).attr("width",width).attr("height",height)
    g     = svg.append("svg:g").attr("id",gId) # All tranforms are applied to g
    $svg  = $.find( '#'+svgId )
    $g    = $.find( '#'+gId   )
    [svg,$svg,g,$g,width,height,barTop]

  createBars:( segments, conditions, Data ) ->
    Util.log( 'createBars', @ext )
    features = if @app.direction is 'West' then Data.WestSegments.features else Data.EastSegments.features
    n        = features.length-1
    mileBeg  = features[0].properties.beg
    mileEnd  = features[n].properties.end
    mileRef  = if @app.direction is 'West' then mileBeg else mileEnd
    distance = Math.abs( mileEnd - mileBeg )
    pxLen    = @svgWidth()
    stroke   = 1
    # Util.log( 'Mile', { mileBeg:mileBeg, mileEnd:mileEnd, distance:distance, pxBeg:pxBeg, pxEnd:pxEnd, height:height, y0:y0, h:h } )
    for feature in features
      prop  = feature.properties
      beg   = pxLen * Math.abs( prop.beg - mileRef ) / distance
      end   = pxLen * Math.abs( prop.end - mileRef ) / distance
      segId = Util.toInt(prop.id)
      fill = @fillConditionCreate( segId, conditions )
      # Util.log( 'Rect', { segId:segId, beg:beg, end:end, y0:y0, h:h, fill:fill } )
      @rect( @g, segId, beg, @barTop(), end-beg, @barHeight(), fill, stroke, '' )
    return

  fillConditionCreate:( segId, conditions ) ->
    Util.noop( conditions )
    colors = ['green','yellow','red']
    colors[segId%3]

  fillConditionUpdate:( segId, conditions ) ->
    Util.noop( conditions )
    colors = ['green','yellow','red']
    colors[(segId+1)%3]

  fillConditionCondition:( segId, conditions ) ->
    for condition in conditions
      if segId is condition.SegmentId
        return @fillColor( condition )
    'green'

  fillColor:( condition ) ->
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
    features = if @app.direction is 'West' then Data.WestSegments.features else Data.EastSegments.features
    for feature in features
      prop  = feature.properties
      segId = Util.toInt(prop.id)
      fill  = @fillConditionU( segId, conditions )
      @updateRectFill( segId, fill )
    return

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
    return

