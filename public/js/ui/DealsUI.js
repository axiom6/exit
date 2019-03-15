var DealsUI;

import Util from '../util/Util.js';

import SearchUC from '../uc/SearchUC.js';

import IconsUC from '../uc/IconsUC.js';

import DealsUC from '../uc/DealsUC.js';

DealsUI = (function() {
  class DealsUI {
    constructor(stream) {
      this.stream = stream;
      this.searchUC = new SearchUC(this.stream, 'Deals', [4, 2, 92, 14], [2, 3, 14, 95]);
      this.iconsUC = new IconsUC(this.stream, 'Search', [4, 16, 92, 10], [16, 3, 10, 95], DealsUI.IconSpecs, false, false);
      this.dealsUC = new DealsUC(this.stream, 'Deals', [4, 26, 92, 72], [26, 3, 73, 95]);
    }

    ready() {
      this.searchUC.ready();
      this.iconsUC.ready();
      this.dealsUC.ready();
      this.$ = $(this.html());
      return this.$.append(this.searchUC.$, this.iconsUC.$, this.dealsUC.$);
    }

    position(screen) {
      this.searchUC.position(screen);
      this.iconsUC.position(screen);
      this.dealsUC.position(screen);
      return this.subscribe();
    }

    html() {
      return `<div id="${Util.id('DealsUI')}" class="${Util.css('DealsUI')}"></div>`;
    }

    show() {
      return this.$.show();
    }

    hide() {
      return this.$.hide();
    }

    subscribe() {
      this.stream.subscribe('Trip', 'DealsUI', (trip) => {
        return this.onTrip(trip);
      });
      this.stream.subscribe('Location', 'DealsUI', (location) => {
        return this.onLocation(location);
      });
      this.stream.subscribe('Screen', 'DealsUI', (screen) => {
        return this.onScreen(screen);
      });
      this.stream.subscribe('Deals', 'DealsUI', (deals) => {
        return this.onDeals(deals);
      });
      return this.stream.subscribe('Search', 'DealsUI', (search) => {
        return this.onSearch(search);
      });
    }

    //@stream.subscribe( 'Conditions', 'DealsUI', (conditions)  => @onConditions( conditions) )
    onTrip(trip) {
      return Util.noop('Deals.onTrip()', trip);
    }

    onLocation(location) {
      return Util.noop('DealsUI.onLocation()', this.ext, location);
    }

    onScreen(screen) {
      return Util.noop('TripUI.onScreen()', screen);
    }

    onDeals(deals) {
      return Util.dbg('DealsUI.onDeals()', deals[0].exit);
    }

    onSearch(search) {
      return Util.dbg('DealsUI.onSearch()', search);
    }

    onConditions(conditions) {
      return Util.noop('Deals.onConditions()', conditions);
    }

  };

  DealsUI.IconSpecs = [
    {
      name: 'Food',
      css: 'Icon',
      icon: 'cutlery'
    },
    {
      name: 'Drink',
      css: 'Icon',
      icon: 'glass'
    },
    {
      name: 'Lodging',
      css: 'Icon',
      icon: 'bed'
    },
    {
      name: 'Shop',
      css: 'Icon',
      icon: 'cart-plus'
    },
    {
      name: 'Museam',
      css: 'Icon',
      icon: 'building'
    },
    {
      name: 'Hospital',
      css: 'Icon',
      icon: 'hospital-o'
    }
  ];

  return DealsUI;

}).call(this);

export default DealsUI;
