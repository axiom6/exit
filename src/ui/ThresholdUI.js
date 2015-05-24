// Generated by CoffeeScript 1.9.1
(function() {
  var ThresholdUI;

  ThresholdUI = (function() {
    Util.Export(ThresholdUI, 'ui/ThresholdUI');

    function ThresholdUI(app, stream) {
      this.app = app;
      this.stream = stream;
    }

    ThresholdUI.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    ThresholdUI.prototype.position = function() {
      return this.subscribe();
    };

    ThresholdUI.prototype.subscribe = function() {
      return this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
    };

    ThresholdUI.prototype.layout = function(orientation) {
      return Util.dbg('Threshold.layout()', orientation);
    };

    ThresholdUI.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Threshold')) + "\"       class=\"" + (this.app.css('Threshold')) + "\">\n   <div id=\"" + (this.app.id('ThresholdAdjust')) + "\" class=\"" + (this.app.css('ThresholdAdjust')) + "\">Adjust Threshold</div>\n   <img src=\"img/app/Threshold.png\">\n</div>";
    };

    ThresholdUI.prototype.show = function() {
      return this.$.show();
    };

    ThresholdUI.prototype.hide = function() {
      return this.$.hide();
    };

    return ThresholdUI;

  })();

}).call(this);