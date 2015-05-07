// Generated by CoffeeScript 1.9.1
(function() {
  var UI;

  UI = (function() {
    Util.Export(UI, 'ui/UI');

    function UI(app, stream, destination, trip, deals, navigate) {
      this.app = app;
      this.stream = stream;
      this.destination = destination;
      this.trip = trip;
      this.deals = deals;
      this.navigate = navigate;
    }

    UI.prototype.ready = function() {
      this.$ = $(this.html());
      $('#App').append(this.$);
      this.$view = this.$.find('#View');
      this.$view.append(this.destination.$);
      this.$view.append(this.trip.$);
      this.$view.append(this.deals.$);
      this.$view.append(this.navigate.$);
      this.$IconsHover = this.$.find('#IconsHover');
      this.$Icons = this.$.find('#Icons');
      this.$destinationIcon = this.$.find('#DestinationIcon');
      this.$tripIcon = this.$.find('#TripIcon');
      this.$dealsIcon = this.$.find('#DealsIcon');
      this.$namigateIcon = this.$.find('#NavigateIcon');
      this.lastSelect = null;
      this.orientation = 'Portrait';
      this.$IconsHover.mouseenter((function(_this) {
        return function() {
          return _this.$Icons.show();
        };
      })(this));
      this.$Icons.mouseleave((function(_this) {
        return function() {
          return _this.$Icons.hide();
        };
      })(this));
      this.publish();
      this.subscribe();
      return this.select('Destination');
    };

    UI.prototype.id = function(name, type) {
      return this.app.id(name, type);
    };

    UI.prototype.css = function(name, type) {
      return this.app.css(name, type);
    };

    UI.prototype.icon = function(name, type, fa) {
      return this.app.icon(name, type, fa);
    };

    UI.prototype.html = function() {
      return "<div      id=\"" + (this.id('UI')) + "\"                  class=\"" + (this.css('UI')) + "\">\n <div    id=\"" + (this.id('IconsHover')) + "\"          class=\"" + (this.css('IconsHover')) + "\"></div>\n <div    id=\"" + (this.id('Icons')) + "\"               class=\"" + (this.css('Icons')) + "\">\n    <div id=\"" + (this.id('Destination', 'Icon')) + "\"  class=\"" + (this.css('Destination', 'Icon')) + "\"><div><i class=\"fa fa-picture-o\"></i></div></div>\n    <div id=\"" + (this.id('Trip', 'Icon')) + "\"  class=\"" + (this.css('Trip', 'Icon')) + "\"><div><i class=\"fa fa-road\"></i></div></div>\n    <div id=\"" + (this.id('Deals', 'Icon')) + "\"  class=\"" + (this.css('Deals', 'Icon')) + "\"><div><i class=\"fa fa-trophy\"></i></div></div>\n    <div id=\"" + (this.id('Navigate', 'Icon')) + "\"  class=\"" + (this.css('Navigate', 'Icon')) + "\"><div><i class=\"fa fa-street-view\"></i></div></div>\n </div>\n <div id=\"" + (this.id('View')) + "\" class=\"" + (this.css('View')) + "\"></div>\n</div>";
    };

    UI.prototype.layout = function(orientation) {
      var url;
      Util.log('UI.layout', orientation);
      url = "img/app/phone6x12" + orientation + ".png";
      $('body').css({
        "background-image": "url(" + url + ")"
      });
      return $('#App').attr('class', "App" + orientation);
    };

    UI.prototype.show = function() {};

    UI.prototype.hide = function() {};

    UI.prototype.publish = function() {
      this.stream.publish('Select', this.$destinationIcon, 'click', 'Destination', 'UI');
      this.stream.publish('Select', this.$tripIcon, 'click', 'Trip', 'UI');
      this.stream.publish('Select', this.$dealsIcon, 'click', 'Deals', 'UI');
      return this.stream.publish('Orient', this.$namigateIcon, 'click', 'Orient', 'UI');
    };

    UI.prototype.subscribe = function() {
      this.stream.subscribe('Select', (function(_this) {
        return function(object) {
          return _this.select(object.topic);
        };
      })(this));
      return this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.orient();
        };
      })(this));
    };

    UI.prototype.push = function(subject, topic, from) {
      return this.stream.push(subject, topic, from);
    };

    UI.prototype.select = function(name) {
      var dataId, opts;
      if (this.lastSelect != null) {
        this.lastSelect.hide();
      }
      switch (name) {
        case 'Destination':
          this.lastSelect = this.destination;
          break;
        case 'Trip':
          this.lastSelect = this.trip;
          break;
        case 'Deals':
          this.lastSelect = this.deals;
          dataId = "IAMEXITING1";
          opts = {};
          opts.title = "<div style=\"text-align:center; font-size:2.0em;\"><div>EXIT NOW!</div></div><hr/>";
          opts.text = "<div style=\"text-align:center; font-size:1.0em;\">\n  <div><span>Traffic is slow ahead, </span><span style=\"font-weight:bold;\">ETA +2.5 hrs</span></div>\n  <div style=\"font-size:0.9em;\"><span>Stop now for <span style=\"font-weight:bold;\">FREE DINNER</span></div>\n  <div style=\"margin-top:0.5em;\">\n    <span dataid=\"" + dataId + "\" style=\"font-size:0.9em; padding:0.3em; background-color:#658552; color:white;\">I'M EXITING</span>\n  </div>\n</div>";
          opts.class_name = "gritter-light";
          opts.sticky = true;
          this.deal(opts, dataId);
          break;
        case 'Navigate':
          this.lastSelect = this.navigate;
          break;
        default:
          Util.error("UI.select unknown name", name);
      }
      if (this.lastSelect != null) {
        this.lastSelect.show();
        return Util.log(name, 'Selected');
      }
    };

    UI.prototype.orient = function() {
      this.orientation = this.orientation === 'Portrait' ? 'Landscape' : 'Portrait';
      return this.layout(this.orientation);
    };

    UI.prototype.deal = function(opts, dataId) {
      this.gritter(opts);
      return $("[dataid=" + dataId + "]").click(function() {
        return Util.log("I'M EXITING");
      });
    };

    UI.prototype.gritter = function(opts) {
      return $.gritter.add(opts);
    };


    /*
      $.gritter.add({
        title: 'This is a regular notice!', // (string | mandatory) the heading of the notification
        text:                               // (string | mandatory) the text inside the notification
        image: 'bigger.png',                // (string | optional) the image to display on the left
        sticky: false,                      // (bool | optional) if you want it to fade out on its own or just sit there
        time: 8000,                         // (int | optional) the time you want it to be alive for before fading out (milliseconds)
        class_name: 'my-class',             // (string | optional) the class
     */

    return UI;

  })();

}).call(this);
