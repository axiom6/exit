// Generated by CoffeeScript 1.9.1
(function() {
  var AdvisoryUI;

  AdvisoryUI = (function() {
    Util.Export(AdvisoryUI, 'ui/AdvisoryUI');

    function AdvisoryUI(app, stream) {
      this.app = app;
      this.stream = stream;
    }

    AdvisoryUI.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    AdvisoryUI.prototype.position = function() {
      return this.subscribe();
    };

    AdvisoryUI.prototype.subscribe = function() {
      this.stream.subscribe('Location', (function(_this) {
        return function(location) {
          return _this.onLocation(location);
        };
      })(this));
      return this.stream.subscribe('Orient', (function(_this) {
        return function(orientation) {
          return _this.layout(orientation);
        };
      })(this));
    };

    AdvisoryUI.prototype.onLocation = function(location) {
      return Util.noop('AdvisoryUI.onLocation()', this.ext, location);
    };

    AdvisoryUI.prototype.layout = function(orientation) {
      return Util.dbg('AdvisoryUI.layout()', orientation);
    };

    AdvisoryUI.prototype.html = function() {
      return "<div id=\"" + (Util.id('Advisory')) + "\" class=\"" + (Util.css('Advisory')) + "\"></div>";
    };

    return AdvisoryUI;

  })();

}).call(this);
