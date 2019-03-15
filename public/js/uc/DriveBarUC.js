var DriveBarUC;

import Util from '../util/Util.js';

DriveBarUC = class DriveBarUC {
  // @port [0,0,92,33] @land =[0,0,100,50
  constructor(stream, role, port, land) {
    this.onTrip = this.onTrip.bind(this);
    this.stream = stream;
    this.role = role;
    this.port = port;
    this.land = land;
    this.name = 'DriveBar';
    this.lastTrip = {
      name: ''
    };
    this.created = false;
    this.screen = null; // Set by position() updated by position()
    Util.noop(this.onScreenTransform);
  }

  html() {
    this.htmlId = Util.id(this.name, this.role); // For createSvg()
    return `<div id="${this.htmlId}" class="${Util.css(this.name)
// May or may not need ext for CSS
}"></div>`;
  }

  ready() {
    return this.$ = $(this.html());
  }

  position(screen) {
    // Util.dbg( 'DriveBarUC.position()', @role, screen )
    this.screen = screen;
    //@screenOrig = screen
    Util.cssPosition(this.$, this.screen, this.port, this.land);
    [this.svg, this.$svg, this.g, this.$g, this.gId, this.gw, this.gh, this.y0] = this.createSvg(this.$, this.htmlId, this.name, this.role, this.svgWidth(), this.svgHeight(), this.barTop());
    return this.subscribe();
  }

  subscribe() {
    this.stream.subscribe('Location', 'Deals', (location) => {
      return this.onLocation(location);
    });
    this.stream.subscribe('Screen', 'Deals', (screen) => {
      return this.onScreen(screen);
    });
    return this.stream.subscribe('Trip', 'Deals', (trip) => {
      return this.onTrip(trip);
    });
  }

  onLocation(location) {
    return Util.noop('DriveBarUC.onLocation()', this.role, location);
  }

  onTrip(trip) {
    if (!this.created || trip.name !== this.lastTrip.name) {
      this.createBars(trip);
    } else {
      this.updateFills(trip);
    }
    return this.lastTrip = trip;
  }

  onScreen(screen) {
    this.screen = screen;
    Util.cssPosition(this.$, this.screen, this.port, this.land);
    this.svg.attr("width", this.svgWidth()).attr('height', this.svgHeight());
    return this.createBars(this.lastTrip);
  }

  // Screenlayout changes base on orientation not working
  onScreenTransform(next) {
    var prev, xn, xp, xs, yn, yp, ys;
    prev = this.screen;
    this.screen = next;
    Util.cssPosition(this.$, this.screen, this.port, this.land);
    this.svg.attr("width", this.svgWidth()).attr('height', this.svgHeight());
    xp = 0;
    yp = 0;
    xn = 0;
    yn = 0;
    [xp, yp] = prev.orientation === 'Portrait' ? [this.port[2], this.port[3]] : [this.land[2], this.land[3]];
    [xn, yn] = next.orientation === 'Portrait' ? [this.port[2], this.port[3]] : [this.land[2], this.land[3]];
    xs = next.width * xn / (prev.width * xp);
    ys = next.height * yn / (prev.height * yp);
    this.g.attr('transform', `scale(${xs},${ys})`);
  }

  // index 2 is width index 3 is height
  svgWidth() {
    if (this.screen.orientation === 'Portrait') {
      return this.screen.width * this.port[2] / 100;
    } else {
      return this.screen.width * this.land[2] / 100;
    }
  }

  svgHeight() {
    if (this.screen.orientation === 'Portrait') {
      return this.screen.height * this.port[3] / 100;
    } else {
      return this.screen.height * this.land[3] / 100;
    }
  }

  barHeight() {
    return this.svgHeight() * 0.33;
  }

  barTop() {
    return this.svgHeight() * 0.50;
  }

  // d3 Svg dependency
  createSvg($, htmlId, name, ext, width, height, barTop) {
    var $g, $svg, g, gId, svg, svgId;
    svgId = Util.svgId(name, ext, 'Svg');
    gId = Util.svgId(name, ext, 'G');
    svg = d3.select('#' + htmlId).append("svg:svg").attr("id", svgId).attr("width", width).attr("height", height);
    g = svg.append("svg:g").attr("id", gId); // All tranforms are applied to g
    $svg = $.find('#' + svgId);
    $g = $.find('#' + gId);
    return [svg, $svg, g, $g, gId, width, height, barTop];
  }

  createBars(trip) {
    var beg, end, fill, h, i, len, ref, seg, thick, w, x, y;
    d3.select('#' + this.gId).selectAll("*").remove();
    this.mileBeg = trip.begMile();
    this.mileEnd = trip.endMile();
    this.distance = Math.abs(this.mileEnd - this.mileBeg);
    // Util.dbg( 'DriveBarUC.createBars() 1', { mileBeg:@mileBeg, mileEnd:@mileEnd, distance:@distance } )
    thick = 1;
    x = 0;
    y = this.barTop();
    w = this.svgWidth();
    h = this.barHeight();
    this.createTravelTime(trip, this.g, x, y, w, h);
    this.rect(trip, this.g, trip.segments[0], this.role + 'Border', x, y, w, h, 'transparent', 'white', thick * 4, '');
    ref = trip.segments;
    for (i = 0, len = ref.length; i < len; i++) {
      seg = ref[i];
      beg = w * Math.abs(Util.toFloat(seg['StartMileMarker']) - this.mileBeg) / this.distance;
      end = w * Math.abs(Util.toFloat(seg['EndMileMarker']) - this.mileBeg) / this.distance;
      fill = this.fillCondition(seg.segId, trip.conditions);
      // Util.dbg( 'DriveBarUC.createBars() 2', { segId:seg.segId, beg:beg, end:end,  w:Math.abs(end-beg) } )
      this.rect(trip, this.g, seg, seg.segId, beg, y, Math.abs(end - beg), h, fill, 'black', thick, '');
    }
    this.created = true;
  }

  createTravelTime(trip, g, x, y, w, h) {
    var fontSize, fontSizePx;
    Util.noop(h);
    fontSize = 18;
    fontSizePx = fontSize + 'px';
    g.append("svg:text").text(trip.source).attr("x", 4).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "start").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
    g.append("svg:text").text('TRAVEL TIME').attr("x", w / 2).attr("y", y - fontSize * 3.3).attr('fill', 'white').attr("text-anchor", "middle").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
    g.append("svg:text").text(trip.etaHoursMins()).attr("x", w / 2).attr("y", y - fontSize * 2.2).attr('fill', 'white').attr("text-anchor", "middle").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
    return g.append("svg:text").text(trip.destination).attr("x", w - 4).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "end").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
  }

  fillCondition(segId, conditions) {
    var Conditions;
    Conditions = this.getTheCondition(segId, conditions);
    if ((Conditions == null) || (Conditions.AverageSpeed == null)) {
      return 'gray';
    }
    return this.fillSpeed(Conditions.AverageSpeed);
  }

  // Brute force array interation
  getTheCondition(segId, conditions) {
    var condition, i, len;
    for (i = 0, len = conditions.length; i < len; i++) {
      condition = conditions[i];
      if ((condition.SegmentId != null) && (condition['Conditions'] != null)) {
        if (segId === condition.SegmentId) {
          return condition['Conditions'];
        }
      }
    }
    return void 0;
  }

  fillSpeed(speed) {
    var fill;
    fill = 'gray';
    if (50 < speed) {
      fill = 'green';
    } else if (25 < speed && speed <= 50) {
      fill = 'yellow';
    } else if (15 < speed && speed <= 25) {
      fill = 'red';
    } else if (0 < speed && speed <= 15) {
      fill = 'black';
    }
    return fill;
  }

  updateFills(trip) {
    var condition, fill, i, len, ref, segId;
    ref = trip.conditions;
    for (i = 0, len = ref.length; i < len; i++) {
      condition = ref[i];
      segId = Util.toInt(condition.SegmentId);
      fill = this.fillSpeed(condition['Conditions'].AverageSpeed);
      this.updateRectFill(segId, fill);
    }
  }

  rect(trip, g, seg, segId, x0, y0, w, h, fill, stroke, thick, text) {
    var onClick, svgId;
    svgId = Util.svgId(this.name, segId.toString(), this.role);
    onClick = () => {
      x = d3.mouse(this)[0];
      var mile;
      mile = this.mileBeg + (this.mileEnd - this.mileBeg) * x / this.svgWidth();
      console.log('DriveBar.rect()', {
        segId: segId,
        beg: seg['StartMileMarker'],
        mile: Util.toFixed(mile, 1),
        end: seg['EndMileMarker']
      });
      return this.doSeqmentDeals(trip, segId, mile);
    };
    g.append("svg:rect").attr('id', svgId).attr("x", x0).attr("y", y0).attr("width", w).attr("height", h).attr('segId', segId).attr("fill", fill).attr("stroke", stroke).attr("stroke-width", thick).on('click', onClick); //.on('mouseover',onMouseOver)
    if (text !== '') {
      g.append("svg:text").text(text).attr("x", x0 + w / 2).attr("y", y0 + h / 2 + 2).attr('fill', fill).attr("text-anchor", "middle").attr("font-size", "4px").attr("font-family", "Droid Sans");
    }
  }

  doSeqmentDeals(trip, segId, mile) {
    var deals;
    deals = trip.getDealsBySegId(segId);
    Util.dbg('DriveBarUC.doSeqmentDeals()', deals.length);
    if (deals.length > 0) {
      deals[0].exit = Util.toInt(mile);
      return this.stream.publish('Deals', deals);
    }
  }

  updateRectFill(segId, fill) {
    var rect, rectId;
    rectId = Util.svgId(this.name, segId.toString(), this.role);
    rect = this.$svg.find('#' + rectId);
    rect.attr('fill', fill);
  }

};

export default DriveBarUC;
