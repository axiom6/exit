
class App

  Util.Export( App, 'app/App' )

  # This kicks off everything
  $(document).ready ->
    Util.debug = true # Swithes  Util.dbg() debugging on or off
    Util.init()
    Util.app = new App( 'Local' ) # @dataSource = 'Rest', 'RestThenLocal', 'Local', 'LocalForecasts'

  constructor:( @dataSource='RestThenLocal' ) ->

    @subjectNames = ['Icons','Location','Screen','Source','Destination','Trip','Forecasts']

    # Import Classes
    Stream        = Util.Import( 'app/Stream'       )
    Rest          = Util.Import( 'app/Rest'         )
    Data          = Util.Import( 'app/Data'         )  # Static class with no need to instaciate
    Model         = Util.Import( 'app/Model'        )
    Simulate      = Util.Import( 'app/Simulate'     )

    DestinationUI = Util.Import( 'ui/DestinationUI' )   
    GoUI          = Util.Import( 'ui/GoUI'          )
    TripUI        = Util.Import( 'ui/TripUI'        )
    DealsUI       = Util.Import( 'ui/DealsUI'       )
    NavigateUI    = Util.Import( 'ui/NavigateUI'    )
    UI            = Util.Import( 'ui/UI'            )

    # Instantiate main App classes
    @stream     = new Stream( @subjectNames  )
    @rest       = new Rest(   @stream        )
    @model      = new Model(  @stream, @rest, @dataSource )

    @destinationUI = new DestinationUI(  @stream, @thresholdUC )
    @goUI          = new GoUI(           @stream )
    @tripUI        = new TripUI(         @stream )
    @dealsUI       = new DealsUI(        @stream )
    @navigateUI    = new NavigateUI(     @stream )
    @ui            = new UI(             @stream, @destinationUI, @goUI, @tripUI, @dealsUI, @navigateUI )

    @ready()
    @position( @ui.toScreen('Portrait' ) )

    # Run simulations and test if test modules presents
    @simulate = new Simulate( @, @stream )

    if Util.hasModule( 'app/App.Test',false)
      $('body').css( { "background-image":"none" } )
      $('#App').hide()
      @appTest = new App.Test( @, @stream, @simulate, @rest, @model )

    if Util.hasModule( 'ui/UI.Test',false)
      @uiTest = new UI.Test( @ui, @trip, @destinationUI, @goUI, @tripUI, @navigateUI )

    # Jumpstart App
    @stream.publish( 'Source',      'Denver' )
    @stream.publish( 'Destination', 'Vail'   )

  ready:() ->
    @model.ready()
    @ui.ready()

  position:( screen ) ->
    @ui.position( screen )
