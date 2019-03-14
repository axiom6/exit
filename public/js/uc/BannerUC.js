(function() {
  var BannerUC;

  BannerUC = (function() {
    class BannerUC {
      constructor(stream, role, port, land) {
        this.stream = stream;
        this.role = role;
        this.port = port;
        this.land = land;
        this.screen = {};
        this.recommendation = '?';
      }

      ready() {
        this.$ = $(this.html());
        return this.$bannerText = this.$.find('#BannerText');
      }

      position(screen) {
        this.onScreen(screen);
        return this.subscribe();
      }

      subscribe() {
        this.stream.subscribe('Location', 'BannerUC', (location) => {
          return this.onLocation(location);
        });
        this.stream.subscribe('Screen', 'BannerUC', (screen) => {
          return this.onScreen(screen);
        });
        return this.stream.subscribe('Trip', 'BannerUC', (trip) => {
          return this.onTrip(trip);
        });
      }

      onLocation(location) {
        return Util.noop('BannerUC.onLocation()', this.ext, location);
      }

      onTrip(trip) {
        return this.changeRecommendation(trip.recommendation);
      }

      changeRecommendation(recommendation) {
        var klass;
        this.recommendation = recommendation;
        klass = recommendation === 'GO' ? 'GoBanner' : 'NoGoBanner';
        this.$.attr('class', klass);
        return this.resetText();
      }

      resetText() {
        var html;
        html = this.recommendation === 'NO GO' && this.screen.orientation === 'Landscape' ? 'NO<br/>GO' : this.recommendation;
        return this.$bannerText.html(html);
      }

      //@$.css( { fontSize:'60px' } )
      //Util.dbg( 'BannerUC.changeRecommendation() fontSize', screen.height*scale+'px', screen.height, scale )
      onScreen(screen) {
        this.screen = screen;
        Util.cssPosition(this.$, screen, this.port, this.land);
        return this.resetText();
      }

      html() {
        return `<div   id="${Util.id('BannerUC')}"   class="${Util.css('GoBannerUC')}">\n  <div id="${Util.id('BannerText')}" class="${Util.css('BannerText')}">GO</div>\n</div>`;
      }

    };

    Util.Export(BannerUC, 'uc/BannerUC');

    return BannerUC;

  }).call(this);

}).call(this);
