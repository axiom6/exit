(function() {
  // Provides Spatial Geometry for Trip
  // Instanciated for each Trip for direct access to Trip data
  var Spatial;

  Spatial = (function() {
    class Spatial {
      static radians(deg) {
        return deg * 0.01745329251996; // deg * PI / 180
      }

      static cos(deg) {
        return Math.cos(Spatial.radians(deg));
      }

      // Class Method called as Spatial.direction
      // Lot of boilerplate because @direction can be called from anywhere
      static direction(source, destination) {
        var Data, hasSourceDesitnation;
        Data = Util.Import('app/Data');
        hasSourceDesitnation = (source != null) && source !== '?' && destination && destination !== '?';
        if (hasSourceDesitnation) {
          if (Data.DestinationsMile[source] >= Data.DestinationsMile[destination]) {
            return 'West';
          } else {
            return 'East';
          }
        } else {
          Util.error('Spatial.direction() source and/or destination missing so returning West');
          return 'West';
        }
      }

      constructor(stream, trip) {
        this.subscribe = this.subscribe.bind(this);
        this.onLocation = this.onLocation.bind(this);
        this.stream = stream;
        this.trip = trip;
        this.Data = Util.Import('app/Data');
        this.subscribe();
      }

      subscribe() {
        return this.stream.subscribe('Location', 'Spatial', (location) => {
          return this.onLocation(location);
        });
      }

      onLocation(location) {
        return Util.log('Spatial.onLocation', location);
      }

      segInTrip(seg) {
        var begMileSeg, endMileSeg, inTrip;
        begMileSeg = Util.toFloat(seg.StartMileMarker);
        endMileSeg = Util.toFloat(seg.EndMileMarker);
        inTrip = (function() {
          switch (this.trip.direction) {
            case 'East':
            case 'North':
              return this.trip.begMile() - 0.5 <= begMileSeg && endMileSeg <= this.trip.endMile() + 0.5;
            case 'West' || 'South':
              return this.trip.begMile() + 0.5 >= begMileSeg && endMileSeg >= this.trip.endMile() - 0.5;
          }
        }).call(this);
        //Util.dbg( 'Spatial.segInTrip 2', { inTrip:inTrip, begMileTrip:@trip.begMile(), begMileSeg:begMileSeg, endMileSeg:endMileSeg, endMileTrip:@trip.endMile() } )
        return inTrip;
      }

      segIdNum(key) {
        var id, len, num;
        id = "";
        num = 0;
        len = key.length;
        if (len >= 2 && 'id' === key.substring(0, 2)) {
          id = key;
          num = Util.toInt(key.substring(2, key.length));
        } else {
          Util.error('Spatial.segIdNum() unable to parse key for Segment number', key);
        }
        return [id, num];
      }

      locationFromPosition(position) {
        var location;
        location = {
          lat: position.coords.latitude,
          lon: position.coords.longitude,
          time: Util.toTime()
        };
        if (Util.isNum(position.coords.elevation)) {
          location.elev = position.coords.elevation * Spatial.MetersToFeet;
        }
        if (Util.isNum(position.coords.heading)) {
          location.heading = position.heading;
        }
        if (Util.isNum(position.coords.speed)) {
          location.speed = position.speed * Spatial.MetersPerSecToMPH;
        }
        return location;
      }

      locationFromGeo(geo) {
        var location;
        location = {
          lat: geo.coords.latitude,
          lon: geo.coords.longitude,
          time: Util.toTime()
        };
        if (Util.isNum(geo.coords.elevation)) {
          location.elev = geo.coords.elevation * Spatial.MetersToFeet;
        }
        if (Util.isNum(geo.coords.heading)) {
          location.heading = geo.heading;
        }
        if (Util.isNum(geo.coords.speed)) {
          location.speed = geo.speed * Spatial.MetersPerSecToMPH;
        }
        if (Util.isStr(geo.address.city)) {
          location.city = geo.address.city;
        }
        if (Util.isStr(geo.address.town)) {
          location.town = geo.address.town;
        }
        if (Util.isStr(geo.address.neighborhood)) {
          location.neighborhood = geo.address.neighborhood;
        }
        if (Util.isStr(geo.address.postalCode)) {
          location.zip = geo.address.postalCode;
        }
        if (Util.isStr(geo.address.street)) {
          location.street = geo.address.street;
        }
        if (Util.isStr(geo.address.streetNumber)) {
          location.streetNumber = geo.address.streetNumber;
        }
        if (Util.isStr(geo.formattedAddress)) {
          location.address = geo.formattedAddress;
        }
        return location;
      }

      pushLocations() {}

      // if geolocator? then @pushGeoLocators() else @pushNavLocations()
      pushNavLocations() {
        var onError, onSuccess, options;
        if (Spatial.PushLocationsOn) {
          return;
        } else {
          Spatial.PushLocationsOn = true;
        }
        onSuccess = (position) => {
          return this.stream.publish('Location', this.locationFromPosition(position), 'Trip');
        };
        onError = (error) => {
          return Util.error('Spatia.pushLocation()', ' Unable to get your location', error);
        };
        options = {
          maximumAge: Spatial.MaxAgePosition,
          timeout: Spatial.TimeOutPosition,
          enableHighAccuracy: Spatial.EnableHighAccuracy
        };
        return navigator.geolocation.watchPosition(onSuccess, onError, options); // or getCurrentPosition
      }

      pushGeoLocators() {
        var onError, onSuccess, options;
        if (Spatial.PushLocationsOn) {
          return;
        } else {
          Spatial.PushLocationsOn = true;
        }
        onSuccess = (geo) => {
          return this.stream.publish('Location', this.locationFromGeo(geo), 'Trip');
        };
        onError = (error) => {
          return Util.error('Spatia.pushLocation()', ' Unable to get your location', error);
        };
        options = {
          maximumAge: Spatial.MaxAgePosition,
          timeout: Spatial.TimeOutPosition,
          enableHighAccuracy: Spatial.EnableHighAccuracy
        };
        return geolocator.locate(onSuccess, onError, true, options, null);
      }

      // Hold off untill we want to load google and google maps
      pushAddressForLatLon(latLon) {
        var geocoder, latlng, onReverseGeo;
        geocoder = new google.maps.Geocoder();
        onReverseGeo = function(results, status) {
          if (status === google.maps.GeocoderStatus.OK) {
            geolocator.fetchDetailsFromLookup(results);
            return this.stream.publish('Location', this.locationFromGeo(geolocator.location), 'Spatial');
          } else {
            return Util.error('Spatial.pushAddressForLatLon() bad status from google.maps', status);
          }
        };
        latlng = new google.maps.LatLng(latLon.lat, latLon.lon);
        return geocoder.geocode({
          'latLng': latlng
        }, onReverseGeo);
      }

      seg(segNum) {
        var j, len1, ref, segment;
        ref = this.trip.segments;
        for (j = 0, len1 = ref.length; j < len1; j++) {
          segment = ref[j];
          if (segment.num === segNum) {
            return segment;
          }
        }
        return void 0;
      }

      milePosts() {
        var array, i, j, json, latLon1, latLon2, mile, miles, obj, post, ref;
        array = [];
        miles = this.trip.milePosts.features[0].properties.Milepost;
        for (i = j = 1, ref = this.trip.milePosts.features.length; (1 <= ref ? j < ref : j > ref); i = 1 <= ref ? ++j : --j) {
          latLon1 = this.trip.milePosts.features[i - 1].geometry.coordinates;
          latLon2 = this.trip.milePosts.features[i].geometry.coordinates;
          post = this.trip.milePosts.features[i].properties.Milepost;
          mile = this.mileLatLonFCC(latLon1[1], latLon1[0], latLon2[1], latLon2[0]);
          miles += mile;
          obj = {
            mile: Util.toFixed(mile, 2),
            miles: Util.toFixed(miles, 2),
            post: post
          };
          array.push(obj);
        }
        json = JSON.stringify(array);
        Util.dbg(json);
        return miles;
      }

      mileSeg(seg) {
        var i, j, latlngs, mile, ref;
        mile = 0;
        for (i = j = 1, ref = seg.latlngs.length; (1 <= ref ? j < ref : j > ref); i = 1 <= ref ? ++j : --j) {
          latlngs = seg.latlngs;
          mile += this.mileLatLonFCC(latlngs[i - 1][0], latlngs[i - 1][1], latlngs[i][0], latlngs[i][1]);
        }
        return mile;
      }

      mileSegs() {
        var array, beg, dist, end, j, json, len1, mile, miles, obj, ref, seg;
        array = [];
        miles = Util.toFloat(this.trip.segments[0].StartMileMarker);
        ref = this.trip.segments;
        for (j = 0, len1 = ref.length; j < len1; j++) {
          seg = ref[j];
          mile = this.mileSeg(seg);
          miles -= mile;
          beg = Util.toFloat(seg.StartMileMarker);
          end = Util.toFloat(seg.EndMileMarker);
          dist = Util.toFixed(Math.abs(end - beg));
          obj = {
            num: seg.num,
            mile: Util.toFixed(mile, 2),
            dist: dist,
            beg: seg.StartMileMarker,
            end: seg.EndMileMarker,
            miles: miles
          };
          array.push(obj);
        }
        json = JSON.stringify(array);
        Util.dbg(json);
        return miles;
      }

      // FCC formula derived from the binomial series of Clarke 1866 reference ellipsoid). See Wikipedia:Geographical distance
      mileLatLonFCC(lat1, lon1, lat2, lon2) {
        var cos, dLat, dLon, k1, k2, mLat;
        cos = Spatial.cos;
        mLat = (lat2 + lat1) * 0.5; // Midpoint
        dLat = lat2 - lat1;
        dLon = lon2 - lon1;
        k1 = 111.13209 - 0.56605 * cos(2 * mLat) + 0.00120 * cos(4 * mLat);
        k2 = 111.41513 * cos(mLat) - 0.09455 * cos(3 * mLat) + 0.00012 * cos(5 * mLat);
        return Spatial.KiloMetersToMiles * Math.sqrt(k1 * k1 * dLat * dLat + k2 * k2 * dLon * dLon);
      }

      // This is a fast approximation formula for small distances. See Wikipedia:Geographical distance
      mileLatLonSpherical(lat1, lon1, lat2, lon2) {
        var dLat, dLon, mLat, radians;
        radians = Spatial.radians;
        mLat = radians(lat2 + lat1) * 0.5; // Midpoint
        dLat = radians(lat2 - lat1);
        dLon = radians(lon2 - lon1);
        return Spatial.EarthRadiusInMiles * Math.sqrt(dLat * dLat + dLon * dLon * Math.cos(mLat));
      }

      // This may provide a better result, but  have not a proper reference
      mileLatLon2(lat1, lon1, lat2, lon2) {
        var a, c, dLat, dLon, radians;
        radians = Spatial.radians;
        dLat = radians(lat2 - lat1);
        dLon = radians(lon2 - lon1);
        a = Math.sin(dLat * 0.5) ** 2 + Math.cos(radians(lat1)) * Math.cos(radians(lat2)) * Math.sin(dLon * 0.5) ** 2;
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return Spatial.EarthRadiusInMiles * c; // 6371000 * c  returns meters
      }

    };

    Util.Export(Spatial, 'app/Spatial');

    Spatial.EarthRadiusInMiles = 3958.761;

    Spatial.EarthRadiusInMeters = 6371000;

    Spatial.KiloMetersToMiles = 0.621371;

    Spatial.MetersToFeet = 3.28084;

    Spatial.MetersPerSecToMPH = 0.44704; // 5280 / ( Spatial.MetersToFeet * 3600 )

    Spatial.MaxAgePosition = 0; // 600000 One Minute

    Spatial.TimeOutPosition = 5000; // 600000 One Minute

    Spatial.EnableHighAccuracy = true;

    Spatial.PushLocationsOn = false;

    return Spatial;

  }).call(this);

}).call(this);
