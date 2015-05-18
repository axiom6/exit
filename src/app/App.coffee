
class App

  Util.Export( App, 'app/App' )

  # This kicks off everything
  $(document).ready ->
    Util.debug = true # Controls Util.dbg() debugging
    Util.init()
    Util.app = new App( false, true, true, false, false )
    # Util.dbg( 'App Created' )

  # @retryData implies that we access static data from data/exit folder up server failure in Rest Class - good for demos
  constructor:( @runDemo=true, @runRest=true, @retryData, @runSimulate=false, @runTest=false ) ->

    # Initialize Trip parameters

    @source             = undefined  # Dumb
    @dest               = undefined  # Dumb

    @subjectNames       = ['Select','Orient','Source','Destination','Trip','Recommendation','ETA','Location','TakeDeal','ArriveAtDeal',
                           'Segments','Deals','Conditions',
                           'RequestSegmentBy','RequestConditionsBy','RequestDealsBy']

    # Import Classes
    Stream      = Util.Import( 'app/Stream'     )
    Rest        = Util.Import( 'app/Rest'       )
    Data        = Util.Import( 'app/Data'       )  # Static class with no need to instaciate
    Model       = Util.Import( 'app/Model'      )

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
    @stream     = new Stream(        @, @subjectNames )
    @rest       = new Rest(          @, @stream )
    @model      = new Model(         @, @stream, @rest )

    # Instantiate UI class
    @go          = new Go(           @, @stream )
    @nogo        = new NoGo(         @, @stream )
    @threshold   = new Threshold(    @, @stream )
    @destination = new Destination(  @, @stream, @threshold )
    @road        = new Road(         @, @stream )
    @weather     = new Weather(      @, @stream )
    @advisory    = new Advisory(     @, @stream )
    @trip        = new Trip(         @, @stream, @road, @weather, @advisory )
    @deals       = new Deals(        @, @stream )
    @navigate    = new Navigate(     @, @stream )
    @ui          = new UI(           @, @stream, @destination, @go, @nogo, @trip, @deals, @navigate )

    @ready()
    @position()

    # Run Demos, simulations and/or tests
    @deals.dataDeals()                            if @runDemo
    @simulate   = new Simulate(      @, @stream ) if @runSimulate
    @test       = new Test(          @, @stream ) if @runTest

  ready:() ->
    @model.ready()
    @destination.ready()
    @go.ready()
    @nogo.ready()
    @trip.ready()
    @deals.ready()
    @navigate.ready()
    @ui.ready()

  position:() ->
    @destination.position()
    @go.position()
    @nogo.position()
    @trip.position()
    @deals.position()
    @navigate.position()
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Source',      (object) => @onSource(      object.content ) )
    @stream.subscribe( 'Destination', (object) => @onDestination( object.content ) )



  onSource:( source ) =>
    @source = source
    @model.createTrip( @source, @dest ) if @dest?
    Util.dbg( 'App.onSource()', source )

  onDestination:( destination ) =>
    @dest = destination
    @model.createTrip( @source, @dest ) if @source?
    Util.dbg( 'App.onDestination()', destination )



  width:()  -> @ui.width()
  height:() -> @ui.height()

  id:(    name, type=''       ) -> name + type
  css:(   name, type=''       ) -> name + type
  icon:(  name, type, fa      ) -> name + type + ' fa fa-' + fa
  svgId:( name, type, svgType ) -> @id( name, type+svgType )
