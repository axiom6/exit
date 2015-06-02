

# Provides Spatial Geometry for Trip
# Instanciated for each Trip for direct access to Trip data

class Spatial

  Util.Export( Spatial, 'test/app/Spatial' )



  # Class Method called as Spatial.direction
  # Lot of boilerplate because @direction can be called from anywhere
  @direction:( source, destination ) ->

  constructor:( @app, @stream, @trip ) ->

  subscribe:() =>
    #@stream.subscribe( 'Location', (object) => @onLocation( object.content ) )

  onLocation:( position ) =>
    #Util.log( 'Spatial.onLocation', position )

  segInTrip:( seg ) ->
    inTrip

  segIdNum:( key ) ->

  locationFromPosition:( position ) ->

  locationFromGeo:( geo ) ->
    
  pushLocations:() ->
    # if geolocator? then @pushGeoLocators() else @pushNavLocations()

  pushNavLocations:() ->

  pushGeoLocators:() ->


  # Hold off untill we want to load google and google maps
  pushAddressForLatLon:( latLon ) ->


  seg:( segNum ) ->

  milePosts:() ->


  mileSeg:( seg ) ->


  mileSegs:() ->


  # FCC formula derived from the binomial series of Clarke 1866 reference ellipsoid). See Wikipedia:Geographical distance
  mileLatLonFCC:( lat1, lon1, lat2, lon2 ) ->


  # This is a fast approximation formula for small distances. See Wikipedia:Geographical distance
  mileLatLonSpherical:( lat1, lon1, lat2, lon2 ) ->


  # This may provide a better result, but  have not a proper reference
  mileLatLon2:(lat1, lon1, lat2, lon2 ) ->




