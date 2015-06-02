// Generated by CoffeeScript 1.9.1
(function() {
  var NavigateUI;

  NavigateUI = (function() {
    Util.Export(NavigateUI, 'ui/NavigateUI');

    function NavigateUI(app, stream) {
      this.app = app;
      this.stream = stream;
    }

    NavigateUI.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    NavigateUI.prototype.position = function() {
      return this.subscribe();
    };

    NavigateUI.prototype.subscribe = function() {
      return this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
    };

    NavigateUI.prototype.layout = function(orientation) {
      return Util.dbg('Navigate.layout()', orientation);
    };

    NavigateUI.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Navigate')) + "\" class=\"" + (this.app.css('Navigate')) + "\">Navigate</div>";
    };

    NavigateUI.prototype.show = function() {
      return this.$.show();
    };

    NavigateUI.prototype.hide = function() {
      return this.$.hide();
    };

    return NavigateUI;

  })();

}).call(this);
