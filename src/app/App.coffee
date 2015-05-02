
class App

  Util.Export( App, 'app/App' )

  # This kicks of everything
  $(document).ready ->
    Util.init()
    app = new App( true, false )
    return

  constructor:( runSimulate=false, runTest=false ) ->

    # Import Classes
    Stream      = Util.Import( 'app/Stream'     )
    Simulate    = Util.Import( 'app/Simulate'   )  if runSimulate
    Test        = Util.Import( 'app/Test'       )  if runTest
    Destination = Util.Import( 'ui/Destination' )
    Threshold   = Util.Import( 'ui/Threshold'   )
    Advisory    = Util.Import( 'ui/Advisory'    )
    Go          = Util.Import( 'ui/Go'          )
    NoGo        = Util.Import( 'ui/NoGo'        )
    Weather     = Util.Import( 'ui/Weather'     )
    Road        = Util.Import( 'ui/Road'        )
    Trip        = Util.Import( 'ui/Trip'        )
    Deals       = Util.Import( 'ui/Deals'       )
    Navigate    = Util.Import( 'ui/Navigate'    )
    UI          = Util.Import( 'ui/UI'          )

    # Instantiate main App classes
    @stream   = new Stream(   @ )
    @simulate = new Simulate( @ ) if runSimulate
    @test     = new Test(     @ ) if runTest

    # Instantiate UI class
    @destination = new Destination(  @, @stream )
    @advisory    = new Advisory(     @, @stream )
    @go          = new Go(           @, @stream )
    @nogo        = new NoGo(         @, @stream )
    @weather     = new Weather(      @, @stream )
    @road        = new Road(         @, @stream )
    @trip        = new Trip(         @, @advisory, @go, @nogo, @weather, @road )
    @deals       = new Deals(        @, @stream )
    @navigate    = new Navigate(     @, @stream )
    @ui          = new UI( @, @destination, @trip, @deals, @navigate )

  id:(   name, type=''  ) -> name + type
  css:(  name, type=''  ) -> name + type
  icon:( name, type, fa ) -> name + type + ' fa ' + fa
