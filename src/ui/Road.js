// Generated by CoffeeScript 1.9.1
(function() {
  var Road;

  Road = (function() {
    Util.Export(Road, 'ui/Road');

    function Road(app) {
      this.app = app;
    }

    Road.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    Road.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Road')) + "\" class=\"" + (this.app.css('Road')) + "\"></div>";
    };

    Road.prototype.layout = function() {};

    Road.prototype.show = function() {};

    Road.prototype.hide = function() {};

    return Road;

  })();

}).call(this);
