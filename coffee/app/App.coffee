
class App

  Util.Export( App, 'app/App' )

  # This kicks off everything
  $(document).ready ->
    Util.debug = true # Swithes  Util.dbg() debugging on or off
    Util.init()
    Util.app = new App( 'Local' )

  # @dataSource = 'Rest', 'RestThenLocal', 'Local', 'LocalForecasts'
  constructor:( @dataSource='RestThenLocal' ) ->

    @subjectNames = ['Select','Location','Screen','Source','Destination','Trip','Forecasts']

    # Import Classes
    Stream        = Util.Import( 'app/Stream'       )
    Rest          = Util.Import( 'app/Rest'         )
    Data          = Util.Import( 'app/Data'         )  # Static class with no need to instaciate
    Model         = Util.Import( 'app/Model'        )
    Simulate      = Util.Import( 'app/Simulate'     )

    DestinationUI = Util.Import( 'ui/DestinationUI' )   
    GoUI          = Util.Import( 'ui/GoUI'          )
    NoGoUI        = Util.Import( 'ui/NoGoUI'        )
    TripUI        = Util.Import( 'ui/TripUI'        )
    DealsUI       = Util.Import( 'ui/DealsUI'       )
    NavigateUI    = Util.Import( 'ui/NavigateUI'    )


    ThresholdUC   = Util.Import( 'ui/ThresholdUC'   )

    UI            = Util.Import( 'ui/UI'            )

    # Instantiate main App classes
    @stream     = new Stream( @subjectNames  )
    @rest       = new Rest(   @stream        )
    @model      = new Model(  @stream, @rest, @dataSource )

    # Destination UI with Threshold UC component
    @thresholdUC   = new ThresholdUC(    @stream )
    @destinationUI = new DestinationUI(  @stream, @thresholdUC )

    # Go and NoGo UI
    @goUI          = new GoUI(           @stream )
    @nogoUI        = new NoGoUI(         @stream )

    # Trip UI with Road, Weather Advisory UC components
    @tripUI        = new TripUI(         @stream )
    
    @dealsUI       = new DealsUI(        @stream )
    @navigateUI    = new NavigateUI(     @stream )
    @ui            = new UI(             @stream, @destinationUI, @goUI, @nogoUI, @tripUI, @dealsUI, @navigateUI )

    @ready()
    @position( @ui.toScreen('Portrait' ) )

    # Run simulations and test if test modules presents
    @simulate = new Simulate( @, @stream )

    if Util.hasModule( 'app/App.Test',false)
      $('body').css( { "background-image":"none" } )
      $('#App').hide()
      @appTest = new App.Test( @, @stream, @simulate, @rest, @model )

    if Util.hasModule( 'ui/UI.Test',false)
      @uiTest = new UI.Test( @ui, @adivsoryUI, @dealsUI, @destinationUI, @driveBarUI, @goUI, @noGoUI, @roadUI, @thresholdUI, @trip, @weatherUI, @navigateUI )

    # Jumpstart App
    @stream.publish( 'Source',      'Denver' )
    @stream.publish( 'Destination', 'Vail'   )

  ready:() ->
    @model.ready()
    @destinationUI.ready()
    @goUI.ready()
    @nogoUI.ready()
    @tripUI.ready()
    @dealsUI.ready()
    @navigateUI.ready()
    @ui.ready()

  position:( screen ) ->
    @destinationUI.position( screen )
    @goUI.position(          screen )
    @nogoUI.position(        screen )
    @tripUI.position(        @ui.toScreen('Landscape') ) # For now until full responsive web design is implemented
    @dealsUI.position(       screen )
    @navigateUI.position(    screen )
    @ui.position(            screen )


