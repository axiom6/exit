
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

    # Initialize instance parameters
    @dest               = ''
    @subjectNames       = ['Select','Orient','Destination','ETA','Location','TakeDeal','ArriveAtDeal',
                           'Segments','Deals','Conditions',
                           'RequestSegmentBy','RequestConditionsBy','RequestDealsBy']
    @direction          = 'West' # or East
    @eta                = 141 # Expressed in minutes
    @recommendation     = 'Go'

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
    @stream.subscribe( 'Destination', (object) => @goOrNoGo( object.content) )
    @stream.subscribe( 'Conditions ', (object) => @updateETA(object.content) )

  updateETA:( conditions ) ->
    @eta = 0
    for condition in conditions
      @eta += conditions.Condition.TravelTime
    Util.dbg( 'App.updateETA()', @etaHoursMins() )
    @stream.push( 'ETA', @eta, 'App' )

  etaHoursMins:() ->
    Util.toInt(@eta/60) + ' Hours ' + @eta%60 + ' Mins'

  goOrNoGo:( dest ) =>
    # another fancy piece of logic goes here
    if dest is 'Vail' or dest is 'Winter Park'
      if @recommendation = 'Go'
         @recommendation = 'NoGo'
         @ui.changeRecommendation('NoGo')
    else
      if @recommendation = 'NoGo'
         @recommendation = 'Go'
         @ui.changeRecommendation('Go')

  width:()  -> @ui.width()
  height:() -> @ui.height()

  id:(    name, type=''       ) -> name + type
  css:(   name, type=''       ) -> name + type
  icon:(  name, type, fa      ) -> name + type + ' fa fa-' + fa
  svgId:( name, type, svgType ) -> @id( name, type+svgType )
