
class Simulate

  Util.Export( Simulate, 'app/Simulate' )

  constructor:( @app, @stream  ) ->
    @Data = Util.Import( 'app/Data')

  generateLocationsFromMilePosts:( delay ) ->
    time    = 0
    #subject = @stream.getSubject('Location')
    #subject.delay( delay )
    for feature in @Data.MilePosts.features
      Milepost = feature.properties.Milepost
      lat      = feature.geometry.coordinates[1]  # lat lon reversed in GeoJSON
      lon      = feature.geometry.coordinates[0]
      latlon   = [lat,lon]
      time    += delay
      @stream.push( 'Location', latlon, "#{Milepost}" ) # latlon is content Milepost is from
    return