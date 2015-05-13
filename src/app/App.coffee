
class App

  Util.Export( App, 'app/App' )

  # This kicks off everything
  $(document).ready ->
    Util.init()
    Util.app = new App( false, true, false )
    # Util.log( 'App Created' )

  constructor:( @runRest=true, @runSimulate=false, @runTest=false ) ->
    @dest               = ''
    @segmentsComplete   = false
    @conditionsComplete = false
    @dealsComplete      = false
    @direction          = 'West' # or East


    # Import Classes
    Stream      = Util.Import( 'app/Stream'     )
    Rest        = Util.Import( 'app/Rest'       )
    Data        = Util.Import( 'app/Data'       )  # Static class with no need to instaciate

    Go          = Util.Import( 'ui/Go'          )
    NoGo        = Util.Import( 'ui/NoGo'        )
    Threshold   = Util.Import( 'ui/Threshold'   )
    Destination = Util.Import( 'ui/Destination' )

    Road        = Util.Import( 'ui/Road'        )
    Weather     = Util.Import( 'ui/Weather'     )
    Advisory    = Util.Import( 'ui/Advisory'    )
    Trip        = Util.Import( 'ui/Trip'        )

    Deals       = Util.Import( 'ui/Deals'       )
    Navigate    = Util.Import( 'ui/Navigate'    )
    UI          = Util.Import( 'ui/UI'          )

    Simulate    = Util.Import( 'app/Simulate'   )
    Test        = Util.Import( 'app/Test'       )

    # Instantiate main App classes
    @stream     = new Stream(        @ )
    @rest       = new Rest(          @, @stream )

    # Instantiate UI class
    @go          = new Go(           @, @stream )
    @nogo        = new NoGo(         @, @stream )
    @threshold   = new Threshold(    @, @stream )
    @destination = new Destination(  @, @stream, @go, @nogo, @threshold )
    @road        = new Road(         @, @stream )
    @weather     = new Weather(      @, @stream )
    @advisory    = new Advisory(     @, @stream )
    @trip        = new Trip(         @, @stream, @road, @weather, @advisory )
    @deals       = new Deals(        @, @stream )
    @navigate    = new Navigate(     @, @stream )
    @ui          = new UI(           @, @stream, @destination, @trip, @deals, @navigate )

    @ready()
    @postReady()

    # Run simulations and tests
    @simulate   = new Simulate(      @, @stream ) if @runSimulate
    @test       = new Test(          @, @stream ) if @runTest

  ready:() ->
    @destination.ready()
    @trip.ready()
    @deals.ready()
    @navigate.ready()
    @ui.ready()

  postReady:() ->
    @destination.postReady()
    @trip.postReady()

  width:()  -> @ui.width()
  height:() -> @ui.height()

  id:(    name, type=''       ) -> name + type
  css:(   name, type=''       ) -> name + type
  icon:(  name, type, fa      ) -> name + type + ' fa fa-' + fa
  svgId:( name, type, svgType ) -> @id( name, type+svgType )

  doDestination:( dest ) ->
    @dest                = dest
    initalCompleteStatus = not @runRest
    @segmentsComplete    = initalCompleteStatus
    @conditionsComplete  = initalCompleteStatus
    @dealsComplete       = initalCompleteStatus
    if @runRest
      @rest.segmentsByPreset(     1,                   @trip.doSegments   ) # Preset 1
      @rest.conditionsBySegments(   @trip.condSegs(),  @trip.doConditions )
      @rest.deals( @deals.latLon(), @deals.segments(), @deals.doDeals     )
    @checkComplete()

  checkComplete:() ->
    @goOrNoGo( @dest ) if @segmentsComplete and @conditionsComplete and @dealsComplete

  goOrNoGo:( dest ) ->
    # another fancy piece of logic goes here
    @trip.createDriveBars()
    if dest is 'Vail' or dest is 'Winter Park'
      @destination.nogo.show()
    else
      @destination.go.show()
