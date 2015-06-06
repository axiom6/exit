
class Trip

  Util.Export( Trip, 'app/Trip' )

  # Weather Forecast Locations
  @Towns = {
    "Evergreen"    : { index:1, lon:-105.334724, lat:39.701735, name:"Evergreen"      }
    "US40"         : { index:2, lon:-105.654065, lat:39.759558, name:"US40"           }
    "EastTunnel"   : { index:3, lon:-105.891111, lat:39.681757, name:"East Tunnel"    }
    "WestTunnel"   : { index:4, lon:-105.878342, lat:39.692400, name:"West Tunnel"    }
    "Silverthorne" : { index:5, lon:-106.072685, lat:39.624160, name:"Silverthorne"   }
    "CopperMtn"    : { index:6, lon:-106.147382, lat:39.503512, name:"Copper Mtn"     }
    "VailPass"     : { index:7, lon:-106.216071, lat:39.531042, name:"Vail Pass"      }
    "Vail"         : { index:8, lon:-106.378767, lat:39.644407, name:"Vail"           } }

  constructor:( @stream, @model, @name, @source, @destination  ) ->

    @Data           = Util.Import( 'app/Data'    )
    @Spatial        = Util.Import( 'app/Spatial' )

    @eta            = -1
    @travelTime     = -1 # Set by travelTime in preset Segments
    @recommendation = '?'
    @preset         = -1

    @segmentIdsAll  = []
    @segmentIds     = []

    @segments       = []
    @conditions     = []
    @deals          = []
    @towns          = Trip.Towns
    @forecasts      = {}

    @begTown        = @toTown( @source,      'Source'      )
    @endTown        = @toTown( @destination, 'Destination' )
    @spatial        = new @Spatial( @stream, @ )
    @direction      = @Spatial.direction( @source, @destination )
    @initByDirection( @direction )

  toTown:( name, role ) ->
    { name:name, role:role, mile:@Data.DestinationsMile[name] }

  initByDirection:( direction ) ->
    switch direction
      when 'West'
        @preset        = 2
        @segmentIdsAll = @Data.WestSegmentIds
      when 'East'
        @preset        = 1
        @segmentIdsAll = @Data.EastSegmentIds
      # when 'North'
      # when 'South'
      else
        Util.error( 'Trip unknown direction', direction )

  begMile:() ->
    @begTown.mile

  endMile:() ->
    @endTown.mile

  segInTrip:( seg ) ->
    @spatial.segInTrip( seg )

  segIdNum:( key ) ->
    @spatial.segIdNum( key )

  launch:() ->
    @eta            = @etaFromCondtions()
    @recommendation = @makeRecommendation()
    # @spatial.pushLocations()
    # @spatial.mileSegs()
    # @spatial.milePosts()
    @log( 'Trip.launch()' )

  etaFromCondtions:() =>
    eta = 0
    for condition in @conditions
      eta += Util.toFloat(condition.Conditions.TravelTime)
    eta

  etaHoursMins:() =>
    Util.toInt(@eta/60) + ' Hours ' + @eta%60 + ' Mins'

  makeRecommendation:( ) =>
    if @destination is 'Copper Mtn' then 'NO GO' else 'GO'

  getDealsBySegId:( segId ) ->
    segDeals = []
    for deal in @deals when @dealHasSegId( deal, segId )
      segDeals.push( deal )
    segDeals

  dealHasSegId:( deal, segId ) ->
    for seq in deal.dealData.onSegments
      return true if seq.segmentId is segId
    false

  log:( caller ) ->
    Util.dbg( caller, { source:@source, destination:@destination, direction:@direction, preset:@preset, recommendation:@recommendation, eta:@eta, travelTime:@travelTime } )
