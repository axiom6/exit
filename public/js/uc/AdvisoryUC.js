var AdvisoryUC;

import Util from '../util/Util.js';

AdvisoryUC = class AdvisoryUC {
  constructor(stream, role, port, land) {
    this.stream = stream;
    this.role = role;
    this.port = port;
    this.land = land;
  }

  ready() {
    return this.$ = $(this.html());
  }

  position(screen) {
    this.onScreen(screen);
    return this.subscribe();
  }

  subscribe() {
    this.stream.subscribe('Location', 'AdvisoryUC', (location) => {
      return this.onLocation(location);
    });
    return this.stream.subscribe('Screen', 'AdvisoryUC', (screen) => {
      return this.onScreen(screen);
    });
  }

  onLocation(location) {
    return Util.noop('AdvisoryUC.onLocation()', this.ext, location);
  }

  onScreen(screen) {
    return Util.cssPosition(this.$, screen, this.port, this.land);
  }

  html() {
    return `<div id="${Util.id('AdvisoryUC', this.role)}" class="${Util.css('AdvisoryUC')}"></div>`;
  }

};

export default AdvisoryUC;
