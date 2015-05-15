// Generated by CoffeeScript 1.9.1
(function() {
  var Threshold;

  Threshold = (function() {
    Util.Export(Threshold, 'ui/Threshold');

    function Threshold(app, stream) {
      this.app = app;
      this.stream = stream;
    }

    Threshold.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    Threshold.prototype.postReady = function() {
      return this.subscribe();
    };

    Threshold.prototype.subscribe = function() {
      return this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
    };

    Threshold.prototype.layout = function(orientation) {
      return Util.dbg('Threshold.layout()', orientation);
    };

    Threshold.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Threshold')) + "\"       class=\"" + (this.app.css('Threshold')) + "\">\n   <div id=\"" + (this.app.id('ThresholdAdjust')) + "\" class=\"" + (this.app.css('ThresholdAdjust')) + "\">Adjust Threshold</div>\n   <img src=\"img/app/Threshold.png\">\n</div>";
    };

    Threshold.prototype.show = function() {
      return this.$.show();
    };

    Threshold.prototype.hide = function() {
      return this.$.hide();
    };

    return Threshold;

  })();

}).call(this);
