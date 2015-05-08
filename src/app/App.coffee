
class App

  Util.Export( App, 'app/App' )

  # This kicks of everything   (MTCN): 9763514107
  $(document).ready ->
    Util.init()
    Util.app = new App( true, false )
    Util.log( 'App Created' )
    return

  constructor:( runSimulate=false, runTest=false ) ->

    # Import Classes
    Stream      = Util.Import( 'app/Stream'     )
    Simulate    = Util.Import( 'app/Simulate'   )  if runSimulate
    Test        = Util.Import( 'app/Test'       )  if runTest

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

    # Instantiate main App classes
    @stream   = new Stream(   @ )
    @simulate = new Simulate( @ ) if runSimulate
    @test     = new Test(     @ ) if runTest

    # Instantiate UI class
    @driveBar    = new DriveBar(     @, @stream )
    @go          = new Go(           @, @stream, @driveBar )
    @nogo        = new NoGo(         @, @stream, @driveBar )
    @threshold   = new Threshold(    @, @stream )
    @destination = new Destination(  @, @stream, @go, @nogo, @threshold )
    @road        = new Road(         @, @stream )
    @weather     = new Weather(      @, @stream )
    @advisory    = new Advisory(     @, @stream )
    @trip        = new Trip(         @, @stream, @road, @weather, @advisory, @driveBar )
    @deals       = new Deals(        @, @stream )
    @navigate    = new Navigate(     @, @stream )
    @ui          = new UI(           @, @stream, @destination, @trip, @deals, @navigate )

    @ready()

  ready:() ->
    @destination.ready()
    @trip.ready()
    @deals.ready()
    @navigate.ready()
    @ui.ready()

    @destination.publish()


  id:(   name, type=''  ) -> name + type
  css:(  name, type=''  ) -> name + type
  icon:( name, type, fa ) -> name + type + ' fa fa-' + fa
