// Generated by CoffeeScript 1.9.1
(function() {
  var Threshold;

  Threshold = (function() {
    Util.Export(Road, 'ui/Threshold');

    function Threshold(app, model) {
      this.app = app;
      this.model = model;
    }

    Threshold.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    Threshold.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Threshold')) + "\" class=\"" + (this.app.css('Threshold')) + "\"></div>";
    };

    Threshold.prototype.layout = function() {};

    show;

    (function() {});

    Threshold.prototype.hide = function() {};

    return Threshold;

  })();

}).call(this);
