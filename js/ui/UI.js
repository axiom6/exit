// Generated by CoffeeScript 1.9.1
(function() {
  var UI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  UI = (function() {
    Util.Export(UI, 'ui/UI');

    function UI(app, stream, destinationUI, goUI, nogoUI, tripUI, dealsUI, navigateUI) {
      this.app = app;
      this.stream = stream;
      this.destinationUI = destinationUI;
      this.goUI = goUI;
      this.nogoUI = nogoUI;
      this.tripUI = tripUI;
      this.dealsUI = dealsUI;
      this.navigateUI = navigateUI;
      this.select = bind(this.select, this);
      this.layout = bind(this.layout, this);
      this.orientation = 'Portrait';
      this.lastSelect = this.destinationUI;
    }

    UI.prototype.ready = function() {
      this.$ = $(this.html());
      $('#App').append(this.$);
      this.$view = this.$.find('#View');
      this.$view.append(this.destinationUI.$);
      this.$view.append(this.goUI.$);
      this.$view.append(this.nogoUI.$);
      this.$view.append(this.tripUI.$);
      this.$view.append(this.dealsUI.$);
      this.$view.append(this.navigateUI.$);
      this.$IconsHover = this.$.find('#IconsHover');
      this.$Icons = this.$.find('#Icons');
      this.$destinationIcon = this.$.find('#DestinationIcon');
      this.$recommendationIcon = this.$.find('#RecommendationIcon');
      this.$recommendationFA = this.$.find('#RecommendationFA');
      this.$tripIcon = this.$.find('#TripIcon');
      this.$dealsIcon = this.$.find('#DealsIcon');
      this.$namigateIcon = this.$.find('#NavigateIcon');
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
      this.events();
      this.subscribe();
      return this.stream.publish('Select', 'Destination');
    };

    UI.prototype.events = function() {
      this.stream.event('Select', this.$destinationIcon, 'click', 'Destination');
      this.stream.event('Select', this.$recommendationIcon, 'click', 'Recommendation');
      this.stream.event('Select', this.$tripIcon, 'click', 'Trip');
      return this.stream.event('Select', this.$dealsIcon, 'click', 'Deals');
    };

    UI.prototype.subscribe = function() {
      this.stream.subscribe('Select', (function(_this) {
        return function(page) {
          return _this.select(page);
        };
      })(this));
      return this.stream.subscribe('Orient', (function(_this) {
        return function(orientation) {
          return _this.layout(orientation);
        };
      })(this));
    };

    UI.prototype.id = function(name, type) {
      return Util.id(name, type);
    };

    UI.prototype.css = function(name, type) {
      return Util.css(name, type);
    };

    UI.prototype.icon = function(name, type, fa) {
      return Util.icon(name, type, fa);
    };

    UI.prototype.html = function() {
      return "<div      id=\"" + (this.id('UI')) + "\"                     class=\"" + (this.css('UI')) + "\">\n <div    id=\"" + (this.id('IconsHover')) + "\"             class=\"" + (this.css('IconsHover')) + "\"></div>\n <div    id=\"" + (this.id('Icons')) + "\"                  class=\"" + (this.css('Icons')) + "\">\n    <div>\n      <div id=\"" + (this.id('Destination', 'Icon')) + "\"  class=\"" + (this.css('Destination', 'Icon')) + "\"><i class=\"fa fa-picture-o\"></i><div>Destination</div></div>\n      <div id=\"" + (this.id('Recommendation', 'Icon')) + "\"  class=\"" + (this.css('Recommendation', 'Icon')) + "\"><i class=\"fa fa-thumbs-up\" id=\"RecommendationFA\"></i><div>Recommendation</div></div>\n      <div id=\"" + (this.id('Trip', 'Icon')) + "\"  class=\"" + (this.css('Trip', 'Icon')) + "\"><i class=\"fa fa-road\"></i><div>Trip</div></div>\n      <div id=\"" + (this.id('Deals', 'Icon')) + "\"  class=\"" + (this.css('Deals', 'Icon')) + "\"><i class=\"fa fa-trophy\"></i><div>Deals</div></div>\n    </div>\n </div>\n <div id=\"" + (this.id('View')) + "\" class=\"" + (this.css('View')) + "\"></div>\n</div>";
    };

    UI.prototype.changeRecommendation = function(recommendation) {
      var faClass;
      Util.noop('UI.changeRecommendation', recommendation);
      this.select(recommendation);
      faClass = recommendation === 'Go' ? 'fa fa-thumbs-up' : 'fa fa-thumbs-down';
      this.$recommendationFA.attr('class', faClass);
    };

    UI.prototype.orient = function(orientation) {
      if (orientation != null) {
        this.orientation = orientation;
      } else {
        this.orientation = this.orientation === 'Portrait' ? 'Landscape' : 'Portrait';
      }
      Util.dbg('UI.orient() new', this.orientation);
    };

    UI.prototype.layout = function(orientation) {
      var url;
      Util.dbg('UI.layout', orientation);
      url = "css/img/app/phone6x12" + orientation + ".png";
      $('body').css({
        "background-image": "url(" + url + ")"
      });
      return $('#App').attr('class', "App" + orientation);
    };

    UI.prototype.show = function() {};

    UI.prototype.hide = function() {};

    UI.prototype.select = function(page) {
      if (this.lastSelect != null) {
        this.lastSelect.hide();
      }
      switch (page) {
        case 'Destination':
          this.lastSelect = this.destinationUI;
          break;
        case 'Recommendation':
        case 'Go':
        case 'NoGo':
          this.lastSelect = page === 'Go' ? this.goUI : this.nogoUI;
          break;
        case 'Trip':
          this.lastSelect = this.tripUI;
          this.orient('Landscape');
          this.layout('Landscape');
          this.tripUI.layout('Landscape');
          break;
        case 'Deals':
          this.lastSelect = this.dealsUI;
          break;
        default:
          Util.error("UI.select unknown page", page);
      }
      if (this.orientation === 'Landscape' && page !== 'Trip') {
        this.layout('Portrait');
      }
      this.lastSelect.show();
    };

    UI.prototype.width = function() {
      var w, w1;
      w1 = this.$ != null ? this.$.width() : 0;
      w = 0;
      if (w1 === 0) {
        w = this.orientation === 'Portrait' ? 300 : 500;
      } else {
        w = w1;
      }
      return w;
    };

    UI.prototype.height = function() {
      var h, h1;
      h1 = this.$ != null ? this.$.height() : 0;
      h = 0;
      if (h1 === 0) {
        h = this.orientation === 'Portrait' ? 500 : 300;
      } else {
        h = h1;
      }
      return h;
    };

    return UI;

  })();

}).call(this);
