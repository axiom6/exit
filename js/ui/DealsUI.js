// Generated by CoffeeScript 1.9.1
(function() {
  var DealsUI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  DealsUI = (function() {
    Util.Export(DealsUI, 'ui/DealsUI');

    function DealsUI(stream) {
      this.stream = stream;
      this.callDeals = bind(this.callDeals, this);
      this.setDealData = bind(this.setDealData, this);
      this.gritterId = 0;
      this.uom = 'em';
      this.dealsData = [];
      this.isVisible = false;
    }

    DealsUI.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    DealsUI.prototype.position = function(screen) {
      return this.subscribe();
    };

    DealsUI.prototype.html = function() {
      return "<div id=\"" + (Util.id('DealsUI')) + "\" class=\"" + (Util.css('DealsUI')) + "\"></div>";
    };

    DealsUI.prototype.show = function() {
      this.isVisible = true;
      return this.$.show();
    };

    DealsUI.prototype.hide = function() {
      this.isVisible = false;
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
      return this.stream.subscribe('Deals', (function(_this) {
        return function(deals) {
          return _this.onDeals(deals);
        };
      })(this));
    };

    DealsUI.prototype.onTrip = function(trip) {
      return Util.noop('Deals.onTrip()', trip);
    };

    DealsUI.prototype.onLocation = function(location) {
      return Util.noop('DealsUI.onLocation()', this.ext, location);
    };

    DealsUI.prototype.onScreen = function(screen) {};

    DealsUI.prototype.latLon = function() {
      return [39.574431, -106.09752];
    };

    DealsUI.prototype.onDeals = function(deals) {
      Util.dbg('DealsUI.onDeals()', deals[0].exit);
      this.popupMultipleDeals('Deals', "for Exit ", "" + deals[0].exit, deals);
      return $('#gritter-notice-wrapper').show();
    };

    DealsUI.prototype.onDeals2 = function(deals) {};

    DealsUI.prototype.onConditions = function(conditions) {
      return Util.noop('Deals.onConditions()');
    };

    DealsUI.prototype.getGoDeals = function() {
      return this.dealsData;
    };

    DealsUI.prototype.getNoGoDeals = function() {
      return this.dealsData;
    };

    DealsUI.prototype.getDeals = function() {
      return this.dealsData;
    };

    DealsUI.prototype.setDealData = function(args, deals) {
      return this.dealsData = deals;
    };

    DealsUI.prototype.callDeals = function(args, deals) {
      this.dealsData = deals;
      return this.stream.publish('Deals', deals);
    };

    DealsUI.prototype.popupMultipleDeals = function(title, traffic, eta, deals) {
      var deal, i, len, opts, results;
      opts = this.dealsOptsHtml(title, traffic, eta, deals);
      opts.class_name = "gritter-light";
      opts.sticky = true;
      this.gritter(opts);
      results = [];
      for (i = 0, len = deals.length; i < len; i++) {
        deal = deals[i];
        results.push(this.enableTakeDealClick(deal._id));
      }
      return results;
    };

    DealsUI.prototype.fs = function(size) {
      return size + this.uom;
    };

    DealsUI.prototype.dealsOptsHtml = function(title, traffic, eta, deals) {
      var deal, i, len, opts;
      this.uom = 'em';
      opts = {};
      opts.title = this.dealsTitle(title, 2.0);
      opts.text = this.dealsTrafficEta(traffic, eta, 1.3);
      for (i = 0, len = deals.length; i < len; i++) {
        deal = deals[i];
        opts.text += this.dealHtml(deal, 1.2, true);
      }
      opts.text += "</div>";
      return opts;
    };

    DealsUI.prototype.goDealsHtml = function(deals) {
      var deal, html, i, len;
      this.uom = 'em';
      html = '';
      for (i = 0, len = deals.length; i < len; i++) {
        deal = deals[i];
        html += this.dealHtml(deal, 0.7, false);
      }
      html += "</div>";
      return html;
    };

    DealsUI.prototype.dealsTitle = function(title, fontSize) {
      return "<div style=\"text-align:center;\">\n<div style=\"font-size:" + (this.fs(fontSize)) + ";\">" + title + "</div>";
    };

    DealsUI.prototype.dealsTrafficEta = function(traffic, eta, fontSize) {
      return "<div style=\"font-size:" + (this.fs(fontSize)) + ";\"><span>" + traffic + "</span><span style=\"font-weight:bold;\"> " + eta + "</span></div>";
    };

    DealsUI.prototype.dealHtml = function(deal, fontSize, take) {
      var html, padding, takeSize;
      padding = 0.2 * fontSize;
      takeSize = 0.6 * fontSize;
      html = "<hr  style=\"margin:" + (this.fs(padding)) + "\"</hr>";
      html += "<div style=\"font-size:" + (this.fs(fontSize)) + ";\">" + deal.dealData.name + "</div>\n<div style=\"font-size:" + (this.fs(fontSize)) + ";\"><span>" + deal.dealData.businessName + "</span>" + (this.takeDeal(deal._id, takeSize, padding, take)) + "</div>";
      return html;
    };

    DealsUI.prototype.takeDeal = function(dealId, fontSize, padding, take) {
      var style;
      if (take) {
        style = "font-size:" + (this.fs(fontSize)) + "; margin-left:" + (this.fs(fontSize)) + "; padding:" + (this.fs(padding)) + "; border-radius:" + (this.fs(padding * 2)) + "; background-color:#658552; color:white;";
        return "<span dataid=\"" + dealId + "\" style=\"" + style + "\">Take Deal</span>";
      } else {
        return '';
      }
    };

    DealsUI.prototype.enableTakeDealClick = function(dealId) {
      return $("[dataid=" + dealId + "]").click((function(_this) {
        return function() {
          Util.dbg('Deal.TakeDeal', dealId);
          return _this.stream.publish('TakeDeal', dealId);
        };
      })(this));
    };

    DealsUI.prototype.gritter = function(opts) {
      return $.gritter.add(opts);
    };

    DealsUI.prototype.iAmExiting = function(dataId) {
      return "<div style=\"margin-top:0.5em;\"><span dataid=\"" + dataId + "\" style=\"font-size:0.9em; padding:0.3em; background-color:#658552; color:white;\">I'M EXITING</span></div></div>";
    };

    DealsUI.prototype.deal = function(opts, dataId, gritterId) {
      this.gritter(opts);
      return this.enableIamExitingClick(dataId, gritterId);
    };

    DealsUI.prototype.enableIamExitingClick = function(dataId, gritterId) {
      return $("[dataid=" + dataId + "]").click(function() {
        Util.dbg("I'M EXITING");
        return $.gritter.remove(gritterId);
      });
    };

    return DealsUI;

  })();

}).call(this);
