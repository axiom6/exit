(function() {
  var UI;

  UI = (function() {
    class UI {
      constructor(stream, destinationUI, goUI, tripUI, dealsUI, navigateUI) {
        var IconsUC;
        this.onIcons = this.onIcons.bind(this);
        this.stream = stream;
        this.destinationUI = destinationUI;
        this.goUI = goUI;
        this.tripUI = tripUI;
        this.dealsUI = dealsUI;
        this.navigateUI = navigateUI;
        IconsUC = Util.Import('uc/IconsUC');
        this.iconsUC = new IconsUC(this.stream, 'Icons', [0, 0, 100, 10], [0, 0, 100, 18], UI.IconSpecs, true, true);
        this.orientation = 'Portrait';
        this.recommendation = '?';
      }

      ready() {
        this.$ = $(this.html());
        $('#App').append(this.$);
        this.iconsUC.ready();
        this.destinationUI.ready();
        this.goUI.ready();
        this.tripUI.ready();
        this.dealsUI.ready();
        this.navigateUI.ready();
        this.$.append(this.iconsUC.$);
        this.$view = this.$.find('#View');
        this.$view.append(this.destinationUI.$);
        this.$view.append(this.goUI.$);
        this.$view.append(this.tripUI.$);
        this.$view.append(this.dealsUI.$);
        this.$view.append(this.navigateUI.$);
        this.subscribe();
        return this.stream.publish('Icons', 'Destination'); // We publish the first screen selection to be Destionaion
      }

      position(screen) {
        this.onScreen(screen);
        this.iconsUC.position(screen);
        this.destinationUI.position(screen);
        this.goUI.position(screen);
        this.tripUI.position(screen);
        this.dealsUI.position(screen);
        return this.navigateUI.position(screen);
      }

      subscribe() {
        this.stream.subscribe('Icons', 'UI', (name) => {
          return this.onIcons(name);
        });
        this.stream.subscribe('Screen', 'UI', (screen) => {
          return this.onScreen(screen);
        });
        return this.stream.subscribe('Trip', 'UI', (trip) => {
          return this.onTrip(trip);
        });
      }

      id(name, type) {
        return Util.id(name, type);
      }

      css(name, type) {
        return Util.css(name, type);
      }

      icon(name, type, fa) {
        return Util.icon(name, type, fa);
      }

      html() {
        return `<div   id="${this.id('UI')}"   class="${this.css('UI')}">\n <div id="${this.id('View')}" class="${this.css('View')}"></div>\n</div>`;
      }

      onTrip(trip) {
        if (this.recommendation !== trip.recommendation) {
          this.changeRecommendation(trip.recommendation);
        }
      }

      reverseRecommendation() {
        if (this.recommendation === 'GO') {
          return 'NO GO';
        } else {
          return 'GO';
        }
      }

      reverseOrientation() {
        if (this.orientation === 'Portrait') {
          return 'Landscape';
        } else {
          return 'Portrait';
        }
      }

      changeRecommendation(recommendation) {
        var $icon, faClass;
        this.onIcons('Recommendation');
        faClass = recommendation === 'GO' ? 'fas fa-thumbs-up' : 'fas fa-thumbs-down';
        $icon = this.iconsUC.$find('Recommendation');
        $icon.find('i').attr('class', faClass);
        $icon.find('div').text(recommendation);
        this.goUI.bannerUC.changeRecommendation(recommendation);
        this.recommendation = recommendation;
      }

      onScreen(screen) {
        var url;
        if (this.orientation !== screen.orientation) {
          this.orientation = screen.orientation;
          url = `css/img/app/phone6x12${screen.orientation}.png`;
          $('body').css({
            "background-image": `url(${url})`
          });
          return $('#App').attr('class', `App${screen.orientation}`);
        }
      }

      onIcons(name) {
        if (this.lastSelect != null) {
          // Util.dbg( 'UI.onIcon() Beg', name, @lastSelect.$.attr('id') )
          this.lastSelect.hide();
        }
        switch (name) {
          case 'Destination':
            this.lastSelect = this.destinationUI;
            break;
          case 'Recommendation':
            this.lastSelect = this.goUI;
            break;
          case 'Trip':
            this.lastSelect = this.tripUI;
            break;
          case 'Deals':
            this.lastSelect = this.dealsUI;
            break;
          case 'Navigate':
            this.lastSelect = this.navigateUI;
            break;
          case 'Fork':
            this.changeRecommendation(this.reverseRecommendation());
            break;
          case 'Point':
            this.stream.publish('Screen', this.toScreen(this.reverseOrientation()));
            break;
          default:
            Util.error("UI.select unknown name", name);
        }
        this.lastSelect.show();
      }

      width() {
        return this.$.width();
      }

      height() {
        return this.$.height();
      }

      toScreen(orientation) {
        if (orientation === this.orientation) {
          return {
            orientation: orientation,
            width: this.width(),
            height: this.height()
          };
        } else {
          return {
            orientation: orientation,
            width: this.height(),
            height: this.width()
          };
        }
      }

    };

    Util.Export(UI, 'ui/UI');

    UI.IconSpecs = [
      {
        name: 'Destination',
        css: 'Icon',
        icon: 'fas fa-file-image'
      },
      {
        name: 'Recommendation',
        css: 'Icon',
        icon: 'fas fa-thumbs-up'
      },
      {
        name: 'Trip',
        css: 'Icon',
        icon: 'fas fa-road'
      },
      {
        name: 'Deals',
        css: 'Icon',
        icon: 'fas fa-trophy'
      },
      {
        name: 'Navigate',
        css: 'Icon',
        icon: 'fas fa-car'
      },
      {
        name: 'Point',
        css: 'Icon',
        icon: 'fas fa-compass'
      },
      {
        name: 'Fork',
        css: 'Icon',
        icon: 'fas fa-code-branch'
      }
    ];

    return UI;

  }).call(this);

}).call(this);
