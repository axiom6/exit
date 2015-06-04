// Generated by CoffeeScript 1.9.1
(function() {
  var Simulate;

  Simulate = (function() {
    Util.Export(Simulate, 'app/Simulate');

    function Simulate(stream) {
      this.stream = stream;
      this.Data = Util.Import('app/Data');
    }

    Simulate.prototype.generateLocationsFromMilePosts = function(delay) {
      var Milepost, feature, i, lat, latlon, len, lon, ref, time;
      time = 0;
      ref = this.Data.MilePosts.features;
      for (i = 0, len = ref.length; i < len; i++) {
        feature = ref[i];
        Milepost = feature.properties.Milepost;
        lat = feature.geometry.coordinates[1];
        lon = feature.geometry.coordinates[0];
        latlon = [lat, lon];
        time += delay;
        this.stream.publish('Location', latlon);
      }
    };

    return Simulate;

  })();

}).call(this);
