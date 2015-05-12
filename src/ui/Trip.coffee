
class Trip

  Util.Export( Trip,   'ui/Trip' )

  constructor:( @app, @stream, @road, @weather, @advisory ) ->
    @Data = Util.Import( 'app/Data' )
    @driveBarsCreated = false
    @segments         = []
    @conditions       = []

  ready:() ->
    @advisory.ready()
    @road.ready()
    @weather.ready()
    @$ = $( @html() )
    @$.append( @advisory.$  )
    @$.append( @weather.$   )
    @$.append( @road.$      )

  html:() ->
    """<div id="#{@app.id('Trip')}" class="#{@app.css('Trip')}"></div>"""

  postReady:() ->
    @road.postReady()

  layout:( orientation ) ->
    @road    .layout( orientation )
    @weather .layout( orientation )
    @advisory.layout( orientation )

  show:() -> @$.show()

  hide:() -> @$.hide()

  doSegments:( args, obj ) =>
    @segments = obj.segments
    Util.log( 'logSegments args', args )
    Util.log( 'logSegments segs', @segments.length )
    for seg in @segments
      [id,num]  = @segIdNum( seg )  # name:seg[id].name
      Util.log( 'logSegment', { id:id, num:num, distance:seg.Length, beg:seg.StartMileMarker, end:seg.EndMileMarker, dir:seg.Direction } )
    @app.segmentsComplete = true
    @app.checkComplete()

  segIdNum:( segment ) ->
    id  = ""
    num = 0
    for own key, obj of segment
      len = key.length
      if len >= 2 and 'id' is key.substring(0,2)
        id    = key
        num   = key.substring(0,1)
        return [id,num]
    [id,num]

  condSegs:() ->
    [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]

  condFields:() ->
    { "RoadCondition":9,"AverageOccupancy":5,"TypeTrafficFlowTxt":"No Data","TypeTrafficFlowCd":5,"IsSlowDown":true, "AverageTrafficFlow":-1,"AverageSpeed":65,"AverageVolume":55,"TravelTime":"1","ExpectedTravelTime":1 }

  doConditions:( args, conditions ) =>
    @conditions          = conditions
    @conditions.segments = args.segments
    Util.log( 'logConditions args',  args )
    Util.log( 'logConditions conds', conditions.length )
    for c in conditions
      cc = c.Conditions
      weather = cc.Weather
      cc.Weather = {}
      Util.log( '  condition id', SegmentId:c.SegmentId, cc )
      Util.log( '  weather', weather )
      cc.Weather = weather
    @app.conditionsComplete = true
    if @driveBarsCreated
       @updateDriveBars( conditions.Conditions )
    else
       @app.checkComplete()

  createDriveBars:() ->
    @app.go  .driveBar.createBars( @segments, @conditions, @Data )
    @app.nogo.driveBar.createBars( @segments, @conditions, @Data )
    @app.road.driveBar.createBars( @segments, @conditions, @Data )
    @driveBarsCreated = true
    
  updateDriveBars:( conditions ) ->
    @app.go  .driveBar.updateBars( @segments, conditions, @Data )
    @app.nogo.driveBar.updateBars( @segments, conditions, @Data )
    @app.road.driveBar.updateBars( @segments, conditions, @Data )
