
class App

  Util.Export( App, 'test/app/App' )

  constructor:( @appObj, @streamObj ) ->

    # Import Classes
    Stream        = Util.Import( 'test/app/Stream'       )
    Rest          = Util.Import( 'test/app/Rest'         )
    Data          = Util.Import( 'test/app/Data'         )  # Static class with no need to instaciate
    Model         = Util.Import( 'test/app/Model'        )

    GoUI          = Util.Import( 'test/ui/GoUI'          )
    NoGoUI        = Util.Import( 'test/ui/NoGoUI'        )
    ThresholdUI   = Util.Import( 'test/ui/ThresholdUI'   )
    DestinationUI = Util.Import( 'test/ui/DestinationUI' )

    RoadUI        = Util.Import( 'test/ui/RoadUI'        )
    WeatherUI     = Util.Import( 'test/ui/WeatherUI'     )
    AdvisoryUI    = Util.Import( 'test/ui/AdvisoryUI'    )
    TripUI        = Util.Import( 'test/ui/TripUI'        )

    DealsUI       = Util.Import( 'test/ui/DealsUI'       )
    NavigateUI    = Util.Import( 'test/ui/NavigateUI'    )
    UI            = Util.Import( 'test/ui/UI'            )

    Simulate    = Util.Import( 'test/app/Simulate'       )
    Test        = Util.Import( 'test/app/Test'           )

    # Instantiate main App classes
    @stream     = new Stream(      @, @subjectNames  )
    @rest       = new Rest(        @, @stream        )
    @model      = new Model(       @, @stream, @rest )

    # Instantiate UI class
    @goUI          = new GoUI(           @, @stream )
    @nogoUI        = new NoGoUI(         @, @stream )
    @thresholdUI   = new ThresholdUI(    @, @stream )
    @destinationUI = new DestinationUI(  @, @stream, @thresholdUI )
    @roadUI        = new RoadUI(         @, @stream )
    @weatherUI     = new WeatherUI(      @, @stream )
    @advisoryUI    = new AdvisoryUI(     @, @stream )
    @tripUI        = new TripUI(         @, @stream, @roadUI, @weatherUI, @advisoryUI )
    @dealsUI       = new DealsUI(        @, @stream )
    @navigateUI    = new NavigateUI(     @, @stream )
    @ui            = new UI(             @, @stream, @destinationUI, @goUI, @nogoUI, @tripUI, @dealsUI, @navigateUI )

    @ready()
    @position()

    # Run Demos, simulations and/or tests
    @deals.dataDeals()                            if @runDemo
    @simulate   = new Simulate(      @, @stream ) if @runSimulate
    @test       = new Test(          @, @stream ) if @runTest

  ready:() ->
    @model.ready()
    @destinationUI.ready()
    @goUI.ready()
    @nogoUI.ready()
    @tripUI.ready()
    @dealsUI.ready()
    @navigateUI.ready()
    @ui.ready()

  position:() ->
    @destinationUI.position()
    @goUI.position()
    @nogoUI.position()
    @tripUI.position()
    @dealsUI.position()
    @navigateUI.position()

  width:()  -> @ui.width()
  height:() -> @ui.height()

  id:(    name, type=''       ) -> name + type
  css:(   name, type=''       ) -> name + type
  icon:(  name, type, fa      ) -> name + type + ' fa fa-' + fa
  svgId:( name, type, svgType ) -> @id( name, type+svgType )
