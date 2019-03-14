(function() {
  var DealsUC;

  DealsUC = (function() {
    class DealsUC {
      constructor(stream, role, port, land) {
        this.stream = stream;
        this.role = role;
        this.port = port;
        this.land = land;
        this.etaHoursMins = '?';
        this.uom = 'em';
        Util.noop(this.iAmExiting, this.enableIamExitingClick);
      }

      ready() {
        return this.$ = $(this.html());
      }

      position(screen) {
        this.onScreen(screen);
        return this.subscribe();
      }

      html() {
        return `<div id="${Util.id('DealsUC', this.role)}" class="${Util.css('DealsUC')}"></div>`;
      }

      subscribe() {
        this.stream.subscribe('Trip', 'DealsUC', (trip) => {
          return this.onTrip(trip);
        });
        this.stream.subscribe('Location', 'DealsUC', (location) => {
          return this.onLocation(location);
        });
        this.stream.subscribe('Screen', 'DealsUC', (screen) => {
          return this.onScreen(screen);
        });
        return this.stream.subscribe('Deals', 'DealsUC', (deals) => {
          return this.onDeals(deals);
        });
      }

      //@stream.subscribe( 'Conditions', 'DealsUC', (conditions)  => @onConditions( conditions) )
      onTrip(trip) {
        this.etaHoursMins = trip.etaHoursMins();
        return this.onDeals(trip.deals);
      }

      onLocation(location) {
        return Util.noop('DealsUC.onLocation()', this.ext, location);
      }

      onScreen(screen) {
        return Util.cssPosition(this.$, screen, this.port, this.land);
      }

      onConditions(conditions) {
        return Util.noop('Deals.onConditions()', conditions);
      }

      onDeals(deals) {
        var deal, html, i, len, results;
        //Util.dbg( 'DealsUI.onDeals()', deals[0].exit )
        html = this.dealsHtml("Exit Now", 'Traffic Slow', this.etaHoursMins, deals);
        this.$.append(html);
        results = [];
        for (i = 0, len = deals.length; i < len; i++) {
          deal = deals[i];
          results.push(this.enableTakeDealClick(deal._id));
        }
        return results;
      }

      // placement is either Go NoGo Gritter Deals - This is a hack for now
      dealsHtml(title, traffic, eta, deals) {
        var deal, html, i, len;
        this.uom = 'em';
        html = '';
        html += this.dealsTitle(title, 1.00);
        html += this.dealsTrafficEta(traffic, eta, 0.75);
        for (i = 0, len = deals.length; i < len; i++) {
          deal = deals[i];
          html += this.dealHtml(deal, 0.80, true);
        }
        html += "</div>"; // Closes main centering div fron @dealTitle()
        return html;
      }

      dealsTitle(title, fontSize) {
        return `<div style="text-align:center;">\n<div style="font-size:${this.fs(fontSize)};">${title}</div>`;
      }

      dealsTrafficEta(traffic, eta, fontSize) {
        return `<div style="font-size:${this.fs(fontSize)};"><span>${traffic}</span><span style="font-weight:bold;"> ${eta}</span></div>`;
      }

      dealHtml(deal, fontSize, take) {
        var html, padding, takeSize;
        padding = 0.2 * fontSize;
        takeSize = 1.0 * fontSize;
        html = `<hr  style="margin:${this.fs(padding)}"</hr>`;
        html += `<div style="font-size:${this.fs(fontSize)};">${deal['dealData'].name}</div>\n<div style="font-size:${this.fs(fontSize)};"><span>${deal['dealData']['businessName']}</span>${this.takeDeal(deal._id, takeSize, padding, take)}</div>`;
        return html;
      }

      fs(size) {
        return size + this.uom;
      }

      takeDeal(dealId, fontSize, padding, take) {
        var style;
        if (take) {
          style = `font-size:${this.fs(fontSize)}; margin-left:${this.fs(fontSize)}; padding:${this.fs(padding)}; border-radius:${this.fs(padding * 2)}; background-color:#E2492F; color:white;`;
          return `<span dataid="${dealId}" style="${style}">Take Deal</span>`;
        } else {
          return '';
        }
      }

      enableTakeDealClick(dealId) {
        return this.$.find(`[dataid=${dealId}]`).click(() => {
          Util.dbg('Deal.TakeDeal', dealId);
          return this.stream.publish('TakeDeal', dealId);
        });
      }

      iAmExiting(dataId) {
        return `<div style="margin-top:0.5em;"><span dataid="${dataId}" style="font-size:0.9em; padding:0.3em; background-color:#658552; color:white;">I'M EXITING</span></div></div>`;
      }

      enableIamExitingClick(dataId, gritterId) {
        return $(`[dataid=${dataId}]`).click(function() {
          Util.dbg("I'M EXITING");
          return $.gritter.remove(gritterId);
        });
      }

    };

    Util.Export(DealsUC, 'uc/DealsUC');

    return DealsUC;

  }).call(this);

}).call(this);
