(function() {
  // Depreciated - Code for for referencece purposed
  var Test;

  Test = (function() {
    class Test {
      constructor(app, stream) {
        this.app = app;
        this.stream = stream;
        //@rest()
        this.streamPushTestLocation();
      }

      //@streamFibonacci()

      // App

      // Model

      // Rest
      rest() {
        Util.dbg('Test.rest() ------------');
        this.rest = this.app.rest;
        this.segments = [31, 32, 33, 34, 272, 273, 36, 37, 39, 40, 41, 276, 277, 268, 269, 44, 45];
        this.rest.segmentsByPreset(1, this.rest.logSegments);
        this.rest.conditionsBySegme;
        objents(this.segments, this.rest.logConditions);
        return this.rest.deals([39.644407, -106.378767], this.segments, this.rest.logDeals);
      }

      restConstructor(app, stream) {
        this.app = app;
        this.stream = stream;
      }

      segmentsFromLocal(direction, onSuccess, onError) {}

      conditionsFromLocal(direction, onSuccess, onError) {}

      dealsFromLocal(direction, onSuccess, onError) {}

      milePostsFromLocal(onSuccess, onError) {}

      forecastsFromLocal(onSuccess, onError) {}

      segmentsByPreset(preset, onSuccess, onError) {}

      conditionsBySegments(segments, onSuccess, onError) {}

      deals(latlon, segments, onSuccess, onError) {}

      forecastByTown(name, town, onSuccess, onError) {}

      getForecast(args, onSuccess, onError) {}

      forecastByLatLonTime(lat, lon, time, onSuccess, onError) {}

      requestSegmentsBy(query, onSuccess, onError) {
        Util.noop('Stream.requestSegmentsBy', query, onSuccess, onError);
      }

      requestConditionsBy(query, onSuccess, onError) {
        Util.noop('Stream.requestConditionsBy', query, onSuccess, onError);
      }

      requestDealsBy(query, onSuccess, onError) {
        Util.noop('Stream.requestDealsBy', query, onSuccess, onError);
      }

      segmentsByLatLon(slat, slon, elat, elon, onSuccess, onError) {}

      segmentsBySegments(segments, onSuccess, onError) {}

      conditionsBySegmentsDate(segments, date, onSuccess, onError) {}

      dealsByUrl(url, onSuccess, onError) {}

      toCsv(array) {}

      segIdNum(segment) {}

      // Simulatate

      // Spatial

      // Stream / RxJS

      // Town

      // Trip

      // Util

      // Visual

      // Location
      streamPushTestLocation() {
        this.stream.subscribe('Location', 'Test', (location) => {
          return this.onTestLocation(location);
        });
        this.stream.publish('Location', {
          content: 'LatLon',
          from: 'Stream.Test'
        });
      }

      onTestLocation(object) {
        return Util.dbg('Test.Stream.onLocation()', object.content, object.from);
      }

    };

    Util.Export(Test, 'util/Test');

    Test.array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    return Test;

  }).call(this);

  // AdvisoryUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// DealsUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// DestinationUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// DriveBarUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// GoUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// NavigateUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// NoGoUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// RoadUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// ThresholdUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// TripUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// UI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

// WeartherUI
// constructor
// ready
// html
// position
// layout
// publish
// subscrible

}).call(this);
