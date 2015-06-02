
class Test
  
  UI = Util.Import( 'ui/UI' )
  UI.Test = Test
  Util.Export( UI.Test, 'ui/UI.Test' )
  
  constructor:( @ui, @adivsoryUI, @dealsUI, @destinationUI, @driveBarUI, @goUI, @noGoUI, @roadUI, @thresholdUI, @trip, @weatherUI, @navigateUI  ) ->
    
  # UI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->
    # orient:( orientation ) ->
    # changeRecommendation:( recommendation ) ->
    # select:( name ) =>
    # width
    # height

  # AdivsoryUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # DealsUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # DestinationUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # DriveBarUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->
    # onTrip:( trip ) =>
    # createSvg:( $, htmlId, name, ext, width, height, barTop ) ->
    # createBars:( trip ) ->
    # createTravelTime:( trip, g, x, y, w, h ) ->
    # fillCondition:( segId, conditions ) ->
    # fillSpeed:( speed ) ->
    # updateFills:( trip ) ->
    # rect:( trip, g, seg, segId, x0, y0, w, h, fill, stroke, thick, text ) ->
    # onClick
    # doSeqmentDeals:( trip, segId, mile ) ->
    # updateRectFill:( segId, fill ) ->
    # layout2:( orientation ) -> # Transform version
    # svgWidth:()   -> if @orientation is 'Portrait' then @app.width()  * 0.92 else @app.height()
    # svgHeight:()  -> if @orientation is 'Portrait' then @app.height() * 0.33 else @app.width() * 0.50
    # barHeight:()  -> @svgHeight() * 0.33
    # barTop:()     -> @svgHeight() * 0.50

  # GoUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # NoGoUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # RoadUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # ThresholdUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # Trip
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

  # WeatherUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->
    # createForecastHtml:( name, w ) ->
    # updateForecastHtml:( name, w ) ->

  # NavigateUI
    # html:() ->
    # ready:() ->
    # $ready;() ->
    # position:() ->
    # subscribe:() ->
    # onLocation:( location ) ->
    # layout:( orientation ) ->

