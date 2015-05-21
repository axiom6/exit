
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

    @subjectNames       = ['Select','Location','Orient','Source','Destination','Trip','ETA','Recommendation']

    # Import Classes
    Stream        = Util.Import( 'app/Stream'       )
    Rest          = Util.Import( 'app/Rest'         )
    Data          = Util.Import( 'app/Data'         )  # Static class with no need to instaciate
    Model         = Util.Import( 'app/Model'        )

    GoUI          = Util.Import( 'ui/GoUI'          )
    NoGoUI        = Util.Import( 'ui/NoGoUI'        )
    ThresholdUI   = Util.Import( 'ui/ThresholdUI'   )
    DestinationUI = Util.Import( 'ui/DestinationUI' )

    RoadUI        = Util.Import( 'ui/RoadUI'        )
    WeatherUI     = Util.Import( 'ui/WeatherUI'     )
    AdvisoryUI    = Util.Import( 'ui/AdvisoryUI'    )
    TripUI        = Util.Import( 'ui/TripUI'        )

    DealsUI       = Util.Import( 'ui/DealsUI'       )
    NavigateUI    = Util.Import( 'ui/NavigateUI'    )
    UI            = Util.Import( 'ui/UI'            )

    Simulate    = Util.Import( 'app/Simulate'       )
    Test        = Util.Import( 'app/Test'           )

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
    @subscribe()

  width:()  -> @ui.width()
  height:() -> @ui.height()

  id:(    name, type=''       ) -> name + type
  css:(   name, type=''       ) -> name + type
  icon:(  name, type, fa      ) -> name + type + ' fa fa-' + fa
  svgId:( name, type, svgType ) -> @id( name, type+svgType )
