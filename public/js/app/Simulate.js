var Simulate;

import Util from '../util/Util.js';

import Data from '../app/Data.js';

Simulate = class Simulate {
  constructor(stream) {
    this.stream = stream;
    Util.noop(this.generateLocationsFromMilePosts);
  }

  generateLocationsFromMilePosts(delay) {
    var feature, i, lat, latlon, len, lon, ref, time;
    time = 0;
    ref = Data.MilePosts.features;
    //subject = @stream.getSubject('Location')
    //subject.delay( delay )
    for (i = 0, len = ref.length; i < len; i++) {
      feature = ref[i];
      // Milepost = feature.properties.Milepost
      lat = feature.geometry.coordinates[1];
      lon = feature.geometry.coordinates[0];
      latlon = [lat, lon];
      time += delay;
      this.stream.publish('Location', latlon); // latlon is content Milepost is from
    }
  }

};

export default Simulate;
