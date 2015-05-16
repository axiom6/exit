// Generated by CoffeeScript 1.9.1
(function() {
  var Deals,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Deals = (function() {
    Util.Export(Deals, 'ui/Deals');

    function Deals(app, stream) {
      this.app = app;
      this.stream = stream;
      this.callDeals = bind(this.callDeals, this);
      this.setDealData = bind(this.setDealData, this);
      this.gritterId = 0;
      this.uom = 'em';
      this.dealsData = [];
      this.isVisible = false;
    }

    Deals.prototype.ready = function() {
      return this.$ = $(this.html());
    };

    Deals.prototype.position = function() {
      return this.subscribe();
    };

    Deals.prototype.html = function() {
      return "<div id=\"" + (this.app.id('Deals')) + "\" class=\"" + (this.app.css('Deals')) + "\"></div>";
    };

    Deals.prototype.show = function() {
      this.isVisible = true;
      return this.$.show();
    };

    Deals.prototype.hide = function() {
      this.isVisible = false;
      return this.$.hide();
    };

    Deals.prototype.subscribe = function() {
      this.stream.subscribe('Destination', (function(_this) {
        return function(object) {
          return _this.onDestination(object.content);
        };
      })(this));
      this.stream.subscribe('Location', (function(_this) {
        return function(object) {
          return _this.onLocation(object.content);
        };
      })(this));
      this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
      this.stream.subscribe('Deals', (function(_this) {
        return function(object) {
          return _this.onDeals(object.content);
        };
      })(this));
      return this.stream.subscribe('Conditions', (function(_this) {
        return function(object) {
          return _this.onConditions(object.content);
        };
      })(this));
    };

    Deals.prototype.onDestination = function(destination) {
      return Util.dbg('Deals.onDestination()', destination);
    };

    Deals.prototype.onLocation = function(latlon) {
      return Util.dbg('Deals.onLocation() latlon', latlon);
    };

    Deals.prototype.layout = function(orientation) {
      return Util.dbg('Deals.layout()', orientation);
    };

    Deals.prototype.latLon = function() {
      return [39.574431, -106.09752];
    };

    Deals.prototype.onDeals = function(deals) {};

    Deals.prototype.onConditions = function(conditions) {
      return Util.dbg('Deals.onConditions()');
    };

    Deals.prototype.getGoDeals = function() {
      return this.dealsData;
    };

    Deals.prototype.getNoGoDeals = function() {
      return this.dealsData;
    };

    Deals.prototype.getDeals = function() {
      return this.dealsData;
    };

    Deals.prototype.dataDeals = function() {
      if (this.dealsData.length === 0) {
        return this.app.rest.dealsByUrl('http://localhost:63342/Exit-Now-App/data/exit/Deals.json', this.callDeals);
      }
    };

    Deals.prototype.setDealData = function(args, deals) {
      return this.dealsData = deals;
    };

    Deals.prototype.callDeals = function(args, deals) {
      this.dealsData = deals;
      return this.stream.push('Deals', deals, 'Deals');
    };

    Deals.prototype.popupMultipleDeals = function(title, traffic, eta, deals) {
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

    Deals.prototype.fs = function(size) {
      return size + this.uom;
    };

    Deals.prototype.dealsOptsHtml = function(title, traffic, eta, deals) {
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

    Deals.prototype.goDealsHtml = function(deals) {
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

    Deals.prototype.dealsTitle = function(title, fontSize) {
      return "<div style=\"text-align:center;\">\n<div style=\"font-size:" + (this.fs(fontSize)) + ";\">" + title + "</div>";
    };

    Deals.prototype.dealsTrafficEta = function(traffic, eta, fontSize) {
      return "<div style=\"font-size:" + (this.fs(fontSize)) + ";\"><span>" + traffic + "</span><span style=\"font-weight:bold;\"> " + eta + "</span></div>";
    };

    Deals.prototype.dealHtml = function(deal, fontSize, take) {
      var html, padding, takeSize;
      padding = 0.2 * fontSize;
      takeSize = 0.6 * fontSize;
      html = "<hr  style=\"margin:" + (this.fs(padding)) + "\"</hr>";
      html += "<div style=\"font-size:" + (this.fs(fontSize)) + ";\">" + deal.dealData.name + "</div>\n<div style=\"font-size:" + (this.fs(fontSize)) + ";\"><span>" + deal.dealData.businessName + "</span>" + (this.takeDeal(deal._id, takeSize, padding, take)) + "</div>";
      return html;
    };

    Deals.prototype.takeDeal = function(dealId, fontSize, padding, take) {
      var style;
      if (take) {
        style = "font-size:" + (this.fs(fontSize)) + "; margin-left:" + (this.fs(fontSize)) + "; padding:" + (this.fs(padding)) + "; border-radius:" + (this.fs(padding * 2)) + "; background-color:#658552; color:white;";
        return "<span dataid=\"" + dealId + "\" style=\"" + style + "\">Take Deal</span>";
      } else {
        return '';
      }
    };

    Deals.prototype.enableTakeDealClick = function(dealId) {
      return $("[dataid=" + dealId + "]").click((function(_this) {
        return function() {
          Util.dbg('Deal.TakeDeal', dealId);
          return _this.stream.push('TakeDeal', dealId, 'Deal');
        };
      })(this));
    };

    Deals.prototype.gritter = function(opts) {
      return $.gritter.add(opts);
    };

    Deals.prototype.iAmExiting = function(dataId) {
      return "<div style=\"margin-top:0.5em;\"><span dataid=\"" + dataId + "\" style=\"font-size:0.9em; padding:0.3em; background-color:#658552; color:white;\">I'M EXITING</span></div></div>";
    };

    Deals.prototype.deal = function(opts, dataId, gritterId) {
      this.gritter(opts);
      return this.enableIamExitingClick(dataId, gritterId);
    };

    Deals.prototype.enableIamExitingClick = function(dataId, gritterId) {
      return $("[dataid=" + dataId + "]").click(function() {
        Util.dbg("I'M EXITING");
        return $.gritter.remove(gritterId);
      });
    };

    return Deals;

  })();

}).call(this);
