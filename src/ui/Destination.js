// Generated by CoffeeScript 1.9.1
(function() {
  var Destination;

  Destination = (function() {
    Util.Export(Destination, 'ui/Destination');

    function Destination(app, model) {
      this.app = app;
      this.model = model;
    }

    Destination.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    Destination.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Destination')) + "\" class=\"" + (this.app.css('Destination')) + "\"></div>";
    };

    Destination.prototype.layout = function() {};

    show;

    (function() {});

    Destination.prototype.hide = function() {};

    return Destination;

  })();

}).call(this);
