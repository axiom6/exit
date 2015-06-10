// Generated by CoffeeScript 1.9.1
(function() {
  var DealsUI;

  DealsUI = (function() {
    Util.Export(DealsUI, 'ui/DealsUI');

    DealsUI.IconSpecs = [
      {
        name: 'Food',
        css: 'Icon',
        icon: 'cutlery'
      }, {
        name: 'Drink',
        css: 'Icon',
        icon: 'glass'
      }, {
        name: 'Lodging',
        css: 'Icon',
        icon: 'bed'
      }, {
        name: 'Shop',
        css: 'Icon',
        icon: 'cart-plus'
      }, {
        name: 'Museam',
        css: 'Icon',
        icon: 'building'
      }, {
        name: 'Hospital',
        css: 'Icon',
        icon: 'hospital-o'
      }
    ];

    function DealsUI(stream) {
      var DealsUC, IconsUC, SearchUC;
      this.stream = stream;
      SearchUC = Util.Import('uc/SearchUC');
      IconsUC = Util.Import('uc/IconsUC');
      DealsUC = Util.Import('uc/DealsUC');
      this.searchUC = new SearchUC(this.stream, 'Deals', [4, 4, 92, 12], [4, 4, 12, 92]);
      this.iconsUC = new IconsUC(this.stream, 'Search', [4, 16, 92, 10], [16, 4, 10, 92], DealsUI.IconSpecs, false, false);
      this.dealsUC = new DealsUC(this.stream, 'Deals', [4, 26, 92, 66], [26, 4, 66, 92]);
    }

    DealsUI.prototype.ready = function() {
      this.searchUC.ready();
      this.iconsUC.ready();
      this.dealsUC.ready();
      this.$ = $(this.html());
      return this.$.append(this.searchUC.$, this.iconsUC.$, this.dealsUC.$);
    };

    DealsUI.prototype.position = function(screen) {
      this.searchUC.position(screen);
      this.iconsUC.position(screen);
      this.dealsUC.position(screen);
      return this.subscribe();
    };

    DealsUI.prototype.html = function() {
      return "<div id=\"" + (Util.id('DealsUI')) + "\" class=\"" + (Util.css('DealsUI')) + "\"></div>";
    };

    DealsUI.prototype.show = function() {
      return this.$.show();
    };

    DealsUI.prototype.hide = function() {
      return this.$.hide();
    };

    DealsUI.prototype.subscribe = function() {
      this.stream.subscribe('Trip', (function(_this) {
        return function(trip) {
          return _this.onTrip(trip);
        };
      })(this));
      this.stream.subscribe('Location', (function(_this) {
        return function(location) {
          return _this.onLocation(location);
        };
      })(this));
      this.stream.subscribe('Screen', (function(_this) {
        return function(screen) {
          return _this.onScreen(screen);
        };
      })(this));
      this.stream.subscribe('Deals', (function(_this) {
        return function(deals) {
          return _this.onDeals(deals);
        };
      })(this));
      return this.stream.subscribe('Search', (function(_this) {
        return function(search) {
          return _this.onSearch(search);
        };
      })(this));
    };

    DealsUI.prototype.onTrip = function(trip) {
      return Util.noop('Deals.onTrip()', trip);
    };

    DealsUI.prototype.onLocation = function(location) {
      return Util.noop('DealsUI.onLocation()', this.ext, location);
    };

    DealsUI.prototype.onScreen = function(screen) {
      return Util.noop('TripUI.onScreen()', screen);
    };

    DealsUI.prototype.onDeals = function(deals) {
      return Util.dbg('DealsUI.onDeals()', deals[0].exit);
    };

    DealsUI.prototype.onSearch = function(search) {
      return Util.dbg('DealsUI.onSearch()', search);
    };

    DealsUI.prototype.onConditions = function(conditions) {
      return Util.noop('Deals.onConditions()');
    };

    return DealsUI;

  })();

}).call(this);
