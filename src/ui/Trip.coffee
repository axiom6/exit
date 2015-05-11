
class Trip

  Util.Export( Trip,   'ui/Trip' )
  Data = Util.Import( 'app/Data' )

  constructor:( @app, @stream, @road, @weather, @advisory ) ->
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

  layout:() ->

  show:() -> @$.show()

  hide:() -> @$.hide()


  doSegments:( args, obj ) =>
    @segments = obj.segments
    Util.log( 'logSegments args', args )
    Util.log( 'logSegments segs', segments.length )
    for segment in @segments
      [id,num] = @segIdNum( segment )
      Util.log( 'logSegment', { id:id, num:num, name:segment.name } )
    @app.segmentsComplete = true
    @app.checkComplete()

  condSegs:() ->
    [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]
    
  doConditions:( args, conditions ) =>
    @conditions          = conditions
    @conditions.segments = args.segments
    Util.log( 'logConditions args',  args )
    Util.log( 'logConditions conds', conditions.length )
    for c in conditions
      cc = c.Conditions
      Util.log( '  condition', { SegmentId:c.SegmentId, TravelTime:cc.TravelTime, AverageSpeed:cc.AverageSpeed } )
      Util.log( '  weather', cc.Weather )
    @app.conditionsComplete = true
    if @driveBarsCreated
       @updateDriveBars( conditions.Conditions )
    else
       @app.checkComplete()


  @createDriveBars:() ->
    @app.go  .driveBar.create( @segments, @conditions, Trip.Data )
    @app.nogo.driveBar.create( @segments, @conditions, Trip.Data )
    @app.trip.driveBar.create( @segments, @conditions, Trip.Data )
    @driveBarsCreated = true
    
  @updateDriveBars:( conditions ) ->
    @app.go  .driveBar.update( @segments, conditions, Trip.Data )
    @app.nogo.driveBar.update( @segments, conditions, Trip.Data )
    @app.trip.driveBar.update( @segments, conditions, Trip.Data )
