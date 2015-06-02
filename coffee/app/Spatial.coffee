

# Provides Spatial Geometry for Trip
# Instanciated for each Trip for direct access to Trip data

class Spatial

  Util.Export( Spatial, 'app/Spatial' )

  @EarthRadiusInMiles  = 3958.761
  @EarthRadiusInMeters = 6371000
  @KiloMetersToMiles   = 0.621371
  @MetersToFeet        = 3.28084
  @MetersPerSecToMPH   = 0.44704  # 5280 / ( Spatial.MetersToFeet * 3600 )
  @MaxAgePosition      = 0        # 600000 One Minute
  @TimeOutPosition     = 5000     # 600000 One Minute
  @EnableHighAccuracy  = true
  @PushLocationsOn     = false

  @radians:( deg ) -> deg * 0.01745329251996 # deg * PI / 180
  @cos:(     deg ) -> Math.cos(Spatial.radians(deg))

  # Class Method called as Spatial.direction
  # Lot of boilerplate because @direction can be called from anywhere
  @direction:( source, destination ) ->
    Data = Util.Import( 'app/Data')
    hasSourceDesitnation = source? and source isnt '?' and destination and destination isnt '?'
    if hasSourceDesitnation
      if Data.DestinationsMile[source] >= Data.DestinationsMile[destination]  then 'West' else 'East'
    else
      Util.error( 'Spatial.direction() source and/or destination missing so returning West' )
      'West'

  constructor:( @app, @stream, @trip ) ->
    @Data = Util.Import( 'app/Data')
    @subscribe()

  subscribe:() =>
    @stream.subscribe( 'Location', (object) => @onLocation( object.content ) )

  onLocation:( position ) =>
    Util.log( 'Spatial.onLocation', position )

  segInTrip:( seg ) ->
    begMileSeg = Util.toFloat(seg.StartMileMarker)
    endMileSeg = Util.toFloat(seg.EndMileMarker)
    inTrip = switch @trip.direction
      when 'East', 'North'
        @trip.begMile() - 0.5 <= begMileSeg and endMileSeg <= @trip.endMile() + 0.5
      when 'West' or 'South'
        @trip.begMile() + 0.5 >= begMileSeg and endMileSeg >= @trip.endMile() - 0.5
    #Util.dbg( 'Spatial.segInTrip 2', { inTrip:inTrip, begMileTrip:@trip.begMile(), begMileSeg:begMileSeg, endMileSeg:endMileSeg, endMileTrip:@trip.endMile() } )
    inTrip

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

  locationFromPosition:( position ) ->
    location = { lat:position.coords.latitude, lon:position.coords.longitude, time:Util.toTime() }
    location.elev    = position.coords.elevation*Spatial.MetersToFeet if Util.isNum( position.coords.elevation )
    location.heading = position.heading                               if Util.isNum( position.coords.heading   )
    location.speed   = position.speed*Spatial.MetersPerSecToMPH       if Util.isNum( position.coords.speed     )
    location

  locationFromGeo:( geo ) ->
    location = { lat:geo.coords.latitude, lon:geo.coords.longitude, time:Util.toTime() }
    location.elev         = geo.coords.elevation*Spatial.MetersToFeet if Util.isNum( geo.coords.elevation     )
    location.heading      = geo.heading                               if Util.isNum( geo.coords.heading       )
    location.speed        = geo.speed*Spatial.MetersPerSecToMPH       if Util.isNum( geo.coords.speed         )
    location.city         = geo.address.city                          if Util.isStr( geo.address.city         )
    location.town         = geo.address.town                          if Util.isStr( geo.address.town         )
    location.neighborhood = geo.address.neighborhood                  if Util.isStr( geo.address.neighborhood )
    location.zip          = geo.address.postalCode                    if Util.isStr( geo.address.postalCode   )
    location.street       = geo.address.street                        if Util.isStr( geo.address.street       )
    location.streetNumber = geo.address.streetNumber                  if Util.isStr( geo.address.streetNumber )
    location.address      = geo.formattedAddress                      if Util.isStr( geo.formattedAddress     )
    location  
    
  pushLocations:() ->
    # if geolocator? then @pushGeoLocators() else @pushNavLocations()

  pushNavLocations:() ->
    if Spatial.PushLocationsOn then return else Spatial.PushLocationsOn = true
    onSuccess = (position) =>
      @stream.push( 'Location', @locationFromPosition(position), 'Trip' )
    onError = ( error ) =>
      Util.error( 'Spatia.pushLocation()',' Unable to get your location', error )
    options = { maximumAge:Spatial.MaxAgePosition, timeout:Spatial.TimeOutPosition, enableHighAccuracy:Spatial.EnableHighAccuracy }
    navigator.geolocation.watchPosition( onSuccess, onError, options ) # or getCurrentPosition

  pushGeoLocators:() ->
    if Spatial.PushLocationsOn then return else Spatial.PushLocationsOn = true
    onSuccess = ( geo ) =>
      @stream.push( 'Location', @locationFromGeo(geo), 'Trip' )
    onError = ( error ) =>
      Util.error( 'Spatia.pushLocation()',' Unable to get your location', error )
    options = { maximumAge:Spatial.MaxAgePosition, timeout:Spatial.TimeOutPosition, enableHighAccuracy:Spatial.EnableHighAccuracy }
    geolocator.locate( onSuccess, onError, true, options, null )

  # Hold off untill we want to load google and google maps
  pushAddressForLatLon:( latLon ) ->
    geocoder = new google.maps.Geocoder()
    onReverseGeo = ( results, status ) ->
      if status is google.maps.GeocoderStatus.OK
        geolocator.fetchDetailsFromLookup(results)
        @stream.push( 'Location', @locationFromGeo(geolocator.location), 'Spatial' )
      else
        Util.error( 'Spatial.pushAddressForLatLon() bad status from google.maps', status )
    latlng = new google.maps.LatLng( latLon.lat, latLon.lon )
    geocoder.geocode( {'latLng':latlng}, onReverseGeo )

  seg:( segNum ) ->
    for segment in @trip.segments
      return segment if segment.num is segNum
    undefined

  milePosts:() ->
    array = []
    miles = @trip.milePosts.features[0].properties.Milepost
    for i in [1...@trip.milePosts.features.length]
      latLon1 = @trip.milePosts.features[i-1].geometry.coordinates
      latLon2 = @trip.milePosts.features[i  ].geometry.coordinates
      post    = @trip.milePosts.features[i  ].properties.Milepost
      mile    = @mileLatLonFCC( latLon1[1], latLon1[0], latLon2[1], latLon2[0] )
      miles  += mile
      obj    = { mile:Util.toFixed(mile,2), miles:Util.toFixed(miles,2), post:post }
      array.push(obj)
    json = JSON.stringify(array)
    Util.dbg( json )
    miles

  mileSeg:( seg ) ->
    mile = 0
    for i in [1...seg.latlngs.length]
      latlngs = seg.latlngs
      mile += @mileLatLonFCC( latlngs[i-1][0], latlngs[i-1][1], latlngs[i][0], latlngs[i][1] )
    mile

  mileSegs:() ->
    array = []
    miles = Util.toFloat(@trip.segments[0].StartMileMarker)
    for seg in @trip.segments
      mile   = @mileSeg(seg)
      miles -= mile
      beg    = Util.toFloat(seg.StartMileMarker)
      end    = Util.toFloat(seg.EndMileMarker)
      dist   = Util.toFixed(Math.abs(end-beg))
      obj    = { num:seg.num, mile:Util.toFixed(mile,2), dist:dist, beg:seg.StartMileMarker, end:seg.EndMileMarker, miles:miles }
      array.push(obj)
    json = JSON.stringify(array)
    Util.dbg( json )
    miles

  # FCC formula derived from the binomial series of Clarke 1866 reference ellipsoid). See Wikipedia:Geographical distance
  mileLatLonFCC:( lat1, lon1, lat2, lon2 ) ->
    cos     = Spatial.cos
    mLat    = ( lat2 + lat1 ) * 0.5 # Midpoint
    dLat    =   lat2 - lat1
    dLon    =   lon2 - lon1
    k1      = 111.13209           - 0.56605*cos(2*mLat) + 0.00120*cos(4*mLat)
    k2      = 111.41513*cos(mLat) - 0.09455*cos(3*mLat) + 0.00012*cos(5*mLat)
    Spatial.KiloMetersToMiles * Math.sqrt( k1*k1*dLat*dLat + k2*k2*dLon*dLon )

  # This is a fast approximation formula for small distances. See Wikipedia:Geographical distance
  mileLatLonSpherical:( lat1, lon1, lat2, lon2 ) ->
    radians = Spatial.radians
    mLat    = radians( lat2 + lat1 ) * 0.5 # Midpoint
    dLat    = radians( lat2 - lat1 )
    dLon    = radians( lon2 - lon1 )
    Spatial.EarthRadiusInMiles * Math.sqrt( dLat*dLat + dLon*dLon*Math.cos(mLat) )

  # This may provide a better result, but  have not a proper reference
  mileLatLon2:(lat1, lon1, lat2, lon2 ) ->
    radians = Spatial.radians
    dLat    = radians(lat2 - lat1)
    dLon    = radians(lon2 - lon1)
    a = Math.sin(dLat*0.5) ** 2 + Math.cos(radians(lat1)) * Math.cos(radians(lat2)) * Math.sin(dLon*0.5) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    Spatial.EarthRadiusInMiles * c # 6371000 * c  returns meters



