(function() {
  var Simulate;

  Simulate = (function() {
    class Simulate {
      constructor(stream) {
        this.stream = stream;
        this.Data = Util.Import('app/Data');
      }

      generateLocationsFromMilePosts(delay) {
        var Milepost, feature, i, lat, latlon, len, lon, ref, time;
        time = 0;
        ref = this.Data.MilePosts.features;
        //subject = @stream.getSubject('Location')
        //subject.delay( delay )
        for (i = 0, len = ref.length; i < len; i++) {
          feature = ref[i];
          Milepost = feature.properties.Milepost;
          lat = feature.geometry.coordinates[1];
          lon = feature.geometry.coordinates[0];
          latlon = [lat, lon];
          time += delay;
          this.stream.publish('Location', latlon); // latlon is content Milepost is from
        }
      }

    };

    Util.Export(Simulate, 'app/Simulate');

    return Simulate;

  }).call(this);

}).call(this);
