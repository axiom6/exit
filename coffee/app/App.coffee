
import Util          from '../util/Util.js'
import Stream        from '../util/Stream.js'
import Rest          from '../app/Rest.js'
import Data          from '../app/Data.js'           # Static class with no need to instaciate
import Model         from '../app/Model.js'
import Simulate      from '../app/Simulate.js'
import DestinationUI from '../ui/DestinationUI.js'
import GoUI          from '../ui/GoUI.js'
import TripUI        from '../ui/TripUI.js'
import DealsUI       from '../ui/DealsUI.js'
import NavigateUI    from '../ui/NavigateUI.js'
import UI            from '../ui/UI.js'

class App

  # This kicks off everything
  $(document).ready ->
    Util.debug = true # Swithes  Util.dbg() debugging on or off
    Util.init()
    Util.app = new App( 'Local' ) # @dataSource = 'Rest', 'RestThenLocal', 'Local', 'LocalForecasts'

  constructor:( @dataSource='RestThenLocal' ) ->

    @subjects = ['Icons','Location','Screen','Source','Destination','Trip','Forecasts']

    # Instantiate main App classes
    logSpec     = { subscribe:false, publish:false, complete:false, subjects:@subjects }
    @stream     = new Stream( @subjects, logSpec )
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

    Util.noop( Data, @appTest, @uiTest )

  ready:() ->
    @model.ready()
    @ui.ready()

  position:( screen ) ->
    @ui.position( screen )
    
export default App
