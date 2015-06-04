
class App

  Util.Export( App, 'app/App' )

  # This kicks off everything
  $(document).ready ->
    Util.debug = true # Swithes  Util.dbg() debugging on or off
    Util.init()
    Util.app = new App( 'Local' )

  # @dataSource = 'Rest', 'RestThenLocal', 'Local', 'LocalForecasts'
  constructor:( @dataSource='RestThenLocal' ) ->

    @subjectNames = ['Select','Location','Orient','Source','Destination','Trip','Forecasts','App']

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

    # Run simulations and test if test modules presents
    @simulate = new Simulate( @, @stream )

    if Util.hasModule( 'app/App.Test',false)
      $('body').css( { "background-image":"none" } )
      $('#App').hide()
      @appTest = new App.Test( @, @stream, @simulate, @rest, @model )

    if Util.hasModule( 'ui/UI.Test',false)
      @uiTest = new UI.Test( @ui, @adivsoryUI, @dealsUI, @destinationUI, @driveBarUI, @goUI, @noGoUI, @roadUI, @thresholdUI, @trip, @weatherUI, @navigateUI )


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

