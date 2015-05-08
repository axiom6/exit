// Generated by CoffeeScript 1.9.1
(function() {
  var DriveBar;

  DriveBar = (function() {
    Util.Export(DriveBar, 'ui/DriveBar');

    function DriveBar(app) {
      this.app = app;
    }

    DriveBar.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    DriveBar.prototype.html = function(name) {
      return "<div id=\"" + (this.app.id('DriveBar', name)) + "\" class=\"" + (this.app.css('DriveBar', name)) + "\"></div>";
    };

    DriveBar.prototype.layout = function() {};

    DriveBar.prototype.show = function() {};

    DriveBar.prototype.hide = function() {};

    return DriveBar;

  })();

}).call(this);
