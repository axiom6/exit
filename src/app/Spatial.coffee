

# Provides Spatial Geometry for Trip
# Instanciated for each Trip for direct access to Trip data

class Spatial

  Util.Export( Spatial, 'app/Spatial' )

  constructor:( @app, @stream, @trip ) ->
    @Data = Util.Import( 'app/Data')

  direction:( source, destination ) ->
    if @Data.DestinationsMile[source] >= @Data.DestinationsMile[destination]  then 'West' else 'East'

  segInTrip:( seg ) ->
    begMileSeg = Util.toFloat(seg.StartMileMarker)
    endMileSeg = Util.toFloat(seg.EndMileMarker)
    switch @trip.direction
      when 'East', 'North'
        @trip.begMile() <= begMileSeg and endMileSeg <= @trip.endMile()
      when 'West' or 'South'
        @trip.begMile() >= begMileSeg and endMileSeg >= @trip.endMile()

  segIdNum:( key ) ->
    id  = ""
    num = 0
    len = key.length
    if len >= 2 and 'id' is key.substring(0,2)
      id    = key
      num   = Util.toInt( key.substring(2,key.length) )
    else
      Util.error( 'Spatial.segIdNum() unable to parse key for Segment number', key )
    [id,num]
