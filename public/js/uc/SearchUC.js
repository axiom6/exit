var SearchUC;

import Util from '../util/Util.js';

SearchUC = class SearchUC {
  constructor(stream, role, port, land, dealsUC) {
    this.stream = stream;
    this.role = role;
    this.port = port;
    this.land = land;
    this.dealsUC = dealsUC;
  }

  ready() {
    return this.$ = $(this.html());
  }

  position(screen) {
    this.onScreen(screen);
    return this.subscribe();
  }

  subscribe() {
    this.stream.subscribe('Location', 'SearchUC', (location) => {
      return this.onLocation(location);
    });
    return this.stream.subscribe('Screen', 'SearchUC', (screen) => {
      return this.onScreen(screen);
    });
  }

  onLocation(location) {
    return Util.noop('SearchUC.onLocation()', this.ext, location);
  }

  onScreen(screen) {
    return Util.cssPosition(this.$, screen, this.port, this.land);
  }

  html() {
    return `<div id="${Util.id('SearchUC', this.role)}" class="${Util.css('SearchUC')}"></div>`;
  }

};

export default SearchUC;
