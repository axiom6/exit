
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