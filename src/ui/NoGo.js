// Generated by CoffeeScript 1.9.1
(function() {
  var NoGo;

  NoGo = (function() {
    Util.Export(NoGo, 'ui/NoGo');

    function NoGo(app, model) {
      this.app = app;
      this.model = model;
    }

    NoGo.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    NoGo.prototype.html = function() {
      return "<div id=\"" + (this.app.id('NoGo')) + "\" class=\"" + (this.app.css('NoGo')) + "\"></div>";
    };

    NoGo.prototype.layout = function() {};

    NoGo.prototype.show = function() {};

    NoGo.prototype.hide = function() {};

    return NoGo;

  })();

}).call(this);
