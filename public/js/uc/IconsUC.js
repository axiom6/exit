var IconsUC;

import Util from '../util/Util.js';

IconsUC = class IconsUC {
  constructor(stream, subject, port, land, specs, hover = true, stayHorz = true) {
    this.$find = this.$find.bind(this);
    this.stream = stream;
    this.subject = subject;
    this.port = port;
    this.land = land;
    this.specs = specs;
    this.hover = hover;
    this.stayHorz = stayHorz;
  }

  ready() {
    return this.$ = $(this.html());
  }

  html() {
    var htm, i, len, ref, spec;
    htm = `<div id="${Util.id('IconsUC', this.subject)}" class="${Util.css('IconsUC')}">`;
    if (this.hover) {
      htm += `<div id="${Util.id('IconsHover', this.subject)}" class="${Util.css('IconsHover')}"></div>`;
    }
    htm += `<div id="${Util.id('Icons', this.subject)}" class="${Util.css('Icons')}"><div>`;
    ref = this.specs;
    for (i = 0, len = ref.length; i < len; i++) {
      spec = ref[i];
      htm += `<div id="${Util.id(spec.name, 'Icon', this.subject)}" class="${Util.css(spec.css)}">\n<i class="${spec.icon}"></i><div>${spec.name}</div></div>`;
    }
    htm += "</div></div></div>";
    return htm;
  }

  position(screen) {
    this.onScreen(screen);
    this.events();
    this.subscribe();
    this.$Icons = this.$.find('#Icons' + this.subject);
    if (this.hover) {
      this.$IconsHover = this.$.find('#IconsHover' + this.subject);
      this.$IconsHover.mouseenter(() => {
        return this.$Icons.show();
      });
      return this.$Icons.mouseleave(() => {
        return this.$Icons.hide();
      });
    } else {
      return this.$Icons.show();
    }
  }

  $find(name) {
    return this.$.find('#' + name + 'Icon' + this.subject);
  }

  events() {
    var i, len, ref, results, spec;
    ref = this.specs;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      spec = ref[i];
      results.push(this.stream.event(this.subject, spec.name, this.$find(spec.name), 'click'));
    }
    return results;
  }

  subscribe() {
    return this.stream.subscribe('Screen', 'IconsUC', (screen) => {
      return this.onScreen(screen);
    });
  }

  onScreen(screen) {
    var h, i, isHorz, len, n, ref, spec, w, x, y;
    isHorz = this.stayHorz ? true : screen.orientation === 'Portrait' ? true : false;
    Util.cssPosition(this.$, screen, this.port, this.land);
    n = this.specs.length;
    x = 0;
    y = 0;
    w = isHorz ? 100 / n : 100;
    h = isHorz ? 100 : 100 / n;
    ref = this.specs;
    for (i = 0, len = ref.length; i < len; i++) {
      spec = ref[i];
      this.$find(spec.name).css({
        left: x + '%',
        top: y + '%',
        width: w + '%',
        height: h + '%'
      });
      if (isHorz) {
        x += w;
      } else {
        y += h;
      }
    }
  }

};

export default IconsUC;
