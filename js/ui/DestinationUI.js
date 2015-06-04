// Generated by CoffeeScript 1.9.1
(function() {
  var DestinationUI;

  DestinationUI = (function() {
    Util.Export(DestinationUI, 'ui/DestinationUI');

    function DestinationUI(stream, thresholdUI) {
      this.stream = stream;
      this.thresholdUI = thresholdUI;
      this.Data = Util.Import('app/Data');
      this.sources = this.Data.Destinations;
      this.destinations = this.Data.Destinations;
    }

    DestinationUI.prototype.ready = function() {
      this.thresholdUI.ready();
      this.$ = $(this.html());
      this.$.append(this.thresholdUI.$);
      this.$destinationBody = this.$.find('#DestinationBody');
      this.$sourceSelect = this.$.find('#SourceSelect');
      return this.$destinationSelect = this.$.find('#DestinationSelect');
    };

    DestinationUI.prototype.position = function(screen) {
      this.thresholdUI.position(screen);
      this.events();
      return this.subscribe();
    };

    DestinationUI.prototype.events = function() {
      this.stream.event('Source', this.$sourceSelect, 'change', 'Source');
      return this.stream.event('Destination', this.$destinationSelect, 'change', 'Destination');
    };

    DestinationUI.prototype.subscribe = function() {
      this.stream.subscribe('Source', (function(_this) {
        return function(source) {
          return _this.onSource(source);
        };
      })(this));
      this.stream.subscribe('Destination', (function(_this) {
        return function(destination) {
          return _this.onDestination(destination);
        };
      })(this));
      return this.stream.subscribe('Screen', (function(_this) {
        return function(screen) {
          return _this.onScreen(screen);
        };
      })(this));
    };

    DestinationUI.prototype.onSource = function(source) {
      return Util.noop('Destination.onSource()', source);
    };

    DestinationUI.prototype.onDestination = function(destination) {
      return Util.noop('Destination.onDestination()', destination);
    };

    DestinationUI.prototype.id = function(name, type) {
      return Util.id(name, type);
    };

    DestinationUI.prototype.css = function(name, type) {
      return Util.css(name, type);
    };

    DestinationUI.prototype.icon = function(name, type, fa) {
      return Util.icon(name, type, fa);
    };

    DestinationUI.prototype.html = function() {
      var destination, htm, i, j, len, len1, ref, ref1, source;
      htm = "<div      id=\"" + (this.id('Destination')) + "\"             class=\"" + (this.css('Destination')) + "\">\n<div      id=\"" + (this.id('DestinationBody')) + "\"         class=\"" + (this.css('DestinationBody')) + "\">\n <!--div  id=\"" + (this.id('DestinationLabelInput')) + "\" class=\"" + (this.css('DestinationLabelInput')) + "\">\n   <span  id=\"" + (this.id('DestinationUserLabel')) + "\" class=\"" + (this.css('DestinationUserLabel')) + "\">User:</span>\n   <input id=\"" + (this.id('DestinationUserInput')) + "\" class=\"" + (this.css('DestinationUserInput')) + "\"type=\"text\" name=\"theinput\" />\n </div-->\n <div     id=\"" + (this.id('SourceWhat')) + "\"            class=\"" + (this.css('SourceWhat')) + "\">Where are You Now?</div>\n <select  id=\"" + (this.id('SourceSelect')) + "\"          class=\"" + (this.css('SourceSelect')) + "\"name=\"Sources\">";
      ref = this.sources;
      for (i = 0, len = ref.length; i < len; i++) {
        source = ref[i];
        htm += "<option>" + source + "</option>";
      }
      htm += "</select></div>\n<div     id=\"" + (this.id('DestinationWhat')) + "\"       class=\"" + (this.css('DestinationWhat')) + "\">What is your</div>\n<div     id=\"" + (this.id('DestinationDest')) + "\"       class=\"" + (this.css('DestinationDest')) + "\">Destination?</div>\n<select  id=\"" + (this.id('DestinationSelect')) + "\"     class=\"" + (this.css('DestinationSelect')) + "\"name=\"Desinations\">";
      ref1 = this.destinations;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        destination = ref1[j];
        htm += "<option>" + destination + "</option>";
      }
      htm += "</select></div></div>";
      return htm;
    };

    DestinationUI.prototype.onScreen = function(screen) {
      return Util.noop('DestinationUI.onScreen()', screen);
    };

    DestinationUI.prototype.show = function() {
      return this.$.show();
    };

    DestinationUI.prototype.hide = function() {
      return this.$.hide();
    };

    DestinationUI.prototype.showBody = function() {
      return this.$destinationBody.show();
    };

    DestinationUI.prototype.hideBody = function() {
      return this.$destinationBody.hide();
    };

    return DestinationUI;

  })();

}).call(this);