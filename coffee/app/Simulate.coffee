
import Util  from '../util/Util.js'
import Data  from '../app/Data.js'

class Simulate

  constructor:( @stream  ) ->
    Util.noop( @generateLocationsFromMilePosts )

  generateLocationsFromMilePosts:( delay ) ->
    time    = 0
    #subject = @stream.getSubject('Location')
    #subject.delay( delay )
    for feature in Data.MilePosts.features
      # Milepost = feature.properties.Milepost
      lat        = feature.geometry.coordinates[1]  # lat lon reversed in GeoJSON
      lon        = feature.geometry.coordinates[0]
      latlon     = [lat,lon]
      time      += delay
      @stream.publish( 'Location', latlon ) # latlon is content Milepost is from
    return

export default Simulate