
class DriveBar

  Util.Export( DriveBar, 'ui/DriveBar' )

  constructor:( @app, @stream, @ext, @parent ) ->
    @Data        = Util.Import( 'app/Data' )
    @name        = 'DriveBar'
    @created     = false

  html:() ->
    @htmlId = @app.id(@name,@ext)                                          # For createSvg()
    htm     = """<div id="#{@htmlId}" class="#{@app.css(@name)}"></div>"""  # May or may not need ext for CSS
    @$      = $(htm)
    htm

  ready:() ->

  postReady:() ->
    [@svg,@$svg,@g,@$g,@gw,@gh,@y0] = @createSvg( @$, @htmlId, @name, @ext, @svgWidth(),  @svgHeight(), @barTop() )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Location',   (object) => @onLocation(   object.content ) )
    @stream.subscribe( 'Orient',     (object) =>     @layout(   object.content ) )
    @stream.subscribe( 'Conditions', (object) => @onConditions( object.content ) )

  onLocation:( latlon ) ->
    Util.dbg( 'DriveBar.onLocation()', @ext, latlon )

  onConditions:( conditions ) =>
    if not @created
      @createBars( @app.model.segments, conditions, @Data )
    else
      @updateBars( @app.model.segments, conditions, @Data )

  layout:( orientation ) ->
    @orientation = orientation
    @svg.attr( "width", @svgWidth() ).attr( 'height', @svgHeight() )
    xs = if @gw > 0 then @gw / @svgWidth() else 1.0
    ys = 1.0
    @g.attr( 'transform', "scale(#{xs},#{ys})" )
    return

  svgWidth:()   -> if @ext isnt 'Road' then @app.width()  * 0.92    else 640                     # Needs to match 92% in App.less
  svgHeight:()  -> if @ext isnt 'Road' then @parent.$.height()*0.33 else 200
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

  createBars:( segments, conditions, Data ) ->
    Util.dbg( 'createBars', @ext )
    features = if @app.direction is 'West' then Data.WestSegments.features else Data.EastSegments.features
    n        = features.length-1
    mileBeg  = features[0].properties.beg
    mileEnd  = features[n].properties.end
    mileRef  = if @app.direction is 'West' then mileBeg else mileEnd
    distance = Math.abs( mileEnd - mileBeg )
    pxLen    = if @ext isnt 'Road'then @svgWidth() else @app.height()
    thick  = 1
    for feature in features
      prop  = feature.properties
      beg   = pxLen * Math.abs( prop.beg - mileRef ) / distance
      end   = pxLen * Math.abs( prop.end - mileRef ) / distance
      segId = Util.toInt(prop.id)
      fill = @fillCondition( segId, conditions )
      # Util.dbg( 'Rect', { segId:segId, beg:beg, end:end, y0:y0, h:h, fill:fill } )
      @rect( @g, segId, beg, @barTop(), end-beg, @barHeight(), fill, 'black', thick, '' )
      @created  = true
    @rect( @g, @ext+'Border', 0, @barTop(), pxLen, @barHeight(), 'transparent', 'white', thick*4, '' )
    return

  fillCondition:( segId, conditions ) ->
    Conditions = @getConditions( segId, conditions )
    return 'gray' if not Conditions? or not Conditions.AverageSpeed?
    @fillSpeed( Conditions.AverageSpeed )

  # Brute force array interation
  getConditions:( segId, conditions ) ->
    for condition in conditions when condition.SegmentId? and condition.Conditions?
      return condition.Conditions if segId is condition.SegmentId
    undefined

  fillSpeed:( speed ) ->
    fill = 'gray'
    if      50 < speed                 then fill = 'green'
    else if 25 < speed and speed <= 50 then fill = 'yellow'
    else if 15 < speed and speed <= 25 then fill = 'red'
    else if  0 < speed and speed <= 15 then fill = 'black'
    fill

  updateBars:( segments, conditions, Data ) ->
    Util.dbg( 'updateBars', @ext )
    features = if @app.direction is 'West' then Data.WestSegments.features else Data.EastSegments.features
    for feature in features
      prop  = feature.properties
      segId = Util.toInt(prop.id)
      fill  = @fillCondition( segId, conditions )
      @updateRectFill( segId, fill )
    return

  rect:( g, segId, x0, y0, w, h, fill, stroke, thick, text='' ) ->
    svgId = @app.svgId( @name, segId.toString(), @ext )
    g.append("svg:rect").attr('id',svgId).attr("x",x0).attr("y",y0).attr("width",w).attr("height",h)
     .attr("fill",fill).attr("stroke",stroke).attr("stroke-width",thick)
    if text isnt ''
      g.append("svg:text").text(text).attr("x",x0+w/2).attr("y",y0+h/2+2).attr('fill',@textFill(fill))
       .attr("text-anchor","middle").attr("font-size","4px").attr("font-family","Arial")
    return

  updateRectFill:( segId, fill ) ->
    rectId = @app.svgId( @name, segId.toString(), @ext )
    rect   = $svg.find('#'+rectId)
    rect.attr( 'fill', fill )
    return

