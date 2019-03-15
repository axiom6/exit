var TripUI;

import Util from '../util/Util.js';

import WeatherUC from '../uc/WeatherUC.js';

import AdvisoryUC from '../uc/AdvisoryUC.js';

import DriveBarUC from '../uc/DriveBarUC.js';

TripUI = class TripUI {
  constructor(stream) {
    this.stream = stream;
    this.weatherUC = new WeatherUC(this.stream, 'Trip', [0, 0, 100, 54], [0, 0, 100, 50]);
    this.advisoryUC = new AdvisoryUC(this.stream, 'Trip', [0, 54, 100, 10], [0, 50, 100, 10]);
    this.driveBarUC = new DriveBarUC(this.stream, 'Trip', [4, 64, 92, 36], [4, 60, 92, 40]);
  }

  ready() {
    this.weatherUC.ready();
    this.advisoryUC.ready();
    this.driveBarUC.ready();
    this.$ = $(this.html());
    return this.$.append(this.weatherUC.$, this.advisoryUC.$, this.driveBarUC.$);
  }

  position(screen) {
    this.weatherUC.position(screen);
    this.advisoryUC.position(screen);
    this.driveBarUC.position(screen);
    return this.subscribe();
  }

  // Trip subscribe to the full Monty of change
  subscribe() {
    return this.stream.subscribe('Screen', 'TripUI', (screen) => {
      return this.onScreen(screen);
    });
  }

  // All positioning happens in the components
  onScreen(screen) {
    return Util.noop('TripUI.onScreen()', screen);
  }

  html() {
    return `<div id="${Util.id('TripUI')}" class="${Util.css('TripUI')}"></div>`;
  }

  show() {
    return this.$.show();
  }

  hide() {
    return this.$.hide();
  }

};

export default TripUI;
