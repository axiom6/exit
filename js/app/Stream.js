// Generated by CoffeeScript 1.9.1
(function() {
  var Stream;

  Stream = (function() {
    Util.Export(Stream, 'app/Stream');

    function Stream(subjectNames) {
      var i, len, name, ref;
      this.subjectNames = subjectNames;
      if ($().bindAsObservable == null) {
        Util.error('Stream rxjs-jquery not defined');
      }
      this.subjects = {};
      ref = this.subjectNames;
      for (i = 0, len = ref.length; i < len; i++) {
        name = ref[i];
        this.subjects[name] = new Rx.Subject();
      }
    }

    Stream.prototype.getSubject = function(name, warn) {
      if (warn == null) {
        warn = false;
      }
      if (this.subjects[name] != null) {
        this.subjects[name];
      } else {
        if (warn) {
          Util.warn('Stream.getSubject() unknown subject so returning new subject for', name);
        }
        this.subjects[name] = new Rx.Subject();
      }
      return this.subjects[name];
    };

    Stream.prototype.event = function(name, jQuerySelector, eventType, objectArg) {
      var object, onNext, subject;
      subject = this.getSubject(name);
      object = objectArg;
      onNext = (function(_this) {
        return function(event) {
          _this.processEvent(event);
          if (eventType !== 'click') {
            object = event.target.value;
          }
          return subject.onNext(object);
        };
      })(this);
      this.subscribeEvent(onNext, jQuerySelector, eventType, object);
    };

    Stream.prototype.subscribe = function(name, onNext) {
      var subject;
      subject = this.getSubject(name, false);
      subject.subscribe(onNext, this.onError, this.onComplete);
    };

    Stream.prototype.publish = function(name, object) {
      var subject;
      subject = this.getSubject(name);
      subject.onNext(object);
    };

    Stream.prototype.subscribeEvent = function(onNext, jqSel, eventType, object) {
      var observable, rxjq;
      rxjq = this.createRxJQuery(jqSel, object);
      observable = rxjq.bindAsObservable(eventType);
      observable.subscribe(onNext, this.onError, this.onComplete);
    };

    Stream.prototype.createRxJQuery = function(jQuerySelector, object) {
      if (Util.isJQuery(jQuerySelector)) {
        return jQuerySelector;
      } else if (Util.isStr(jQuerySelector)) {
        return $(jQuerySelector);
      } else {
        Util.error('App.Pub.createRxJQuery( jqSel )', object, typeof jQuerySelector, 'jqSel is neither jQuery object nor selector');
        return $();
      }
    };

    Stream.prototype.onError = function(error) {
      return Util.error('Stream.onError()', error);
    };

    Stream.prototype.onComplete = function() {
      return Util.dbg('Stream.onComplete()', 'Completed');
    };

    Stream.prototype.processEvent = function(event) {
      if (event != null) {
        event.stopPropagation();
      }
      if (event != null) {
        event.preventDefault();
      }
    };

    Stream.prototype.streamFibonacci = function() {
      var source;
      source = Rx.Observable.from(this.fibonacci()).take(10);
      return source.subscribe(function(x) {
        return Util.dbg('Text.Stream.Fibonacci()', x);
      });
    };

    Stream.prototype.fibonacci = function*() {
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

    return Stream;

  })();

}).call(this);
