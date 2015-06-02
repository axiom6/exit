// Generated by CoffeeScript 1.9.1
(function() {
  var TripUI;

  TripUI = (function() {
    Util.Export(TripUI, 'ui/TripUI');

    function TripUI(app, stream, road, weather, advisory) {
      this.app = app;
      this.stream = stream;
      this.road = road;
      this.weather = weather;
      this.advisory = advisory;
      this.Data = Util.Import('app/Data');
      this.driveBarsCreated = false;
    }

    TripUI.prototype.ready = function() {
      this.advisory.ready();
      this.road.ready();
      this.weather.ready();
      this.$ = $(this.html());
      this.$.append(this.advisory.$);
      this.$.append(this.weather.$);
      return this.$.append(this.road.$);
    };

    TripUI.prototype.position = function() {
      this.road.position();
      this.weather.position();
      this.advisory.position();
      return this.subscribe();
    };

    TripUI.prototype.subscribe = function() {
      return this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
    };

    TripUI.prototype.layout = function(orientation) {
      this.road.layout(orientation);
      this.weather.layout(orientation);
      return this.advisory.layout(orientation);
    };

    TripUI.prototype.html = function() {
      return "<div id=\"" + (Util.id('Trip')) + "\" class=\"" + (Util.css('Trip')) + "\"></div>";
    };

    TripUI.prototype.show = function() {
      return this.$.show();
    };

    TripUI.prototype.hide = function() {
      return this.$.hide();
    };

    return TripUI;

  })();

}).call(this);
