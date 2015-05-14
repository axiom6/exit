// Generated by CoffeeScript 1.9.1
(function() {
  var Test;

  Test = (function() {
    Util.Export(Test, 'app/Test');

    Test.array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    function Test(app, stream) {
      this.app = app;
      this.stream = stream;
      this.streamPushTestLocation();
    }

    Test.prototype.rest = function() {
      Util.log('Test.rest() ------------');
      this.rest = this.app.rest;
      this.segments = [31, 32, 33, 34, 272, 273, 36, 37, 39, 40, 41, 276, 277, 268, 269, 44, 45];
      this.rest.segmentsByPreset(1, this.rest.logSegments);
      this.rest.conditionsBySegme;
      objents(this.segments, this.rest.logConditions);
      return this.rest.deals([39.644407, -106.378767], this.segments, this.rest.logDeals);
    };

    Test.prototype.streamPushTestLocation = function() {
      var object, subject;
      subject = new Rx.Subject();
      subject.subscribe((function(_this) {
        return function(object) {
          return _this.onTestLocation(object);
        };
      })(this));
      object = this.stream.createObject('LatLon', 'Stream.Test');
      subject.onNext(object);
    };

    Test.prototype.onTestLocation = function(object) {
      return Util.log('Test.Stream.onLocation()', object.content, object.from);
    };

    Test.prototype.streamFibonacci = function() {
      var source;
      source = Rx.Observable.from(this.fibonacci()).take(10);
      return source.subscribe(function(x) {
        return Util.log('Text.Stream.Fibonacci()', x);
      });
    };

    Test.prototype.fibonacci = function*() {
      var current, fn1, fn2, results;
      fn1 = 1;
      fn2 = 1;
      results = [];
      while (1) {
        current = fn2;
        fn2 = fn1;
        fn1 = fn1 + current;
        results.push((yield current));
      }
      return results;
    };

    return Test;

  })();

}).call(this);
