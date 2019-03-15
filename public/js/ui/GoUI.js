var GoUI;

import Util from '../util/Util.js';

import BannerUC from '../uc/BannerUC.js';

import DealsUC from '../uc/DealsUC.js';

import DriveBarUC from '../uc/DriveBarUC.js';

GoUI = class GoUI {
  constructor(stream) {
    this.stream = stream;
    this.bannerUC = new BannerUC(this.stream, 'Go', [4, 2, 92, 16], [2, 4, 24, 46]);
    this.dealsUC = new DealsUC(this.stream, 'Go', [4, 20, 92, 46], [26, 4, 72, 46]);
    this.driveBarUC = new DriveBarUC(this.stream, 'Go', [4, 68, 92, 30], [2, 54, 96, 42]);
  }

  ready() {
    this.bannerUC.ready();
    this.dealsUC.ready();
    this.driveBarUC.ready();
    this.$ = $(this.html());
    return this.$.append(this.bannerUC.$, this.dealsUC.$, this.driveBarUC.$);
  }

  position(screen) {
    this.bannerUC.position(screen);
    this.dealsUC.position(screen);
    this.driveBarUC.position(screen);
    return this.subscribe();
  }

  subscribe() {
    this.stream.subscribe('Screen', 'GoUI', (screen) => {
      return this.onScreen(screen);
    });
    return this.stream.subscribe('Trip', 'GoUI', (trip) => {
      return this.onTrip(trip);
    });
  }

  onScreen(screen) {
    return Util.noop('GoUI.screen()', screen);
  }

  onTrip(trip) {
    return Util.noop('GoUI.onTrip()', trip.recommendation);
  }

  html() {
    return `<div id="${Util.id('GoUI')}" class="${Util.css('GoUI')}"></div>`;
  }

  show() {
    return this.$.show();
  }

  hide() {
    return this.$.hide();
  }

};

export default GoUI;
