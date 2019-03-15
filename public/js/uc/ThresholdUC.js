var ThresholdUC;

import Util from '../util/Util.js';

ThresholdUC = class ThresholdUC {
  constructor(stream, ext, port, land) {
    this.stream = stream;
    this.ext = ext;
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
    return this.stream.subscribe('Screen', 'ThresholdUC', (screen) => {
      return this.onScreen(screen);
    });
  }

  onScreen(screen) {
    return Util.cssPosition(this.$, screen, this.port, this.land);
  }

  html() {
    return `<div id="${Util.id('Threshold')}"       class="${Util.css('Threshold')}">\n   <div id="${Util.id('ThresholdAdjust')}" class="${Util.css('ThresholdAdjust')}">Adjust Threshold</div>\n   <img src="css/img/app/Threshold.png" width="300" height="200">\n</div>`;
  }

  show() {
    return this.$.show();
  }

  hide() {
    return this.$.hide();
  }

};

export default ThresholdUC;
