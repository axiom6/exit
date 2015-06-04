// Generated by CoffeeScript 1.9.1
(function() {
  var DriveBarUI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  DriveBarUI = (function() {
    Util.Export(DriveBarUI, 'ui/DriveBarUI');

    function DriveBarUI(app, stream, ext1, parent, orientation1) {
      this.app = app;
      this.stream = stream;
      this.ext = ext1;
      this.parent = parent;
      this.orientation = orientation1;
      this.onTrip = bind(this.onTrip, this);
      this.name = 'DriveBar';
      this.lastTrip = {
        name: ''
      };
      this.created = false;
    }

    DriveBarUI.prototype.html = function() {
      var htm;
      this.htmlId = Util.id(this.name, this.ext);
      htm = "<div id=\"" + this.htmlId + "\" class=\"" + (Util.css(this.name)) + "\"></div>";
      this.$ = $(htm);
      return htm;
    };

    DriveBarUI.prototype.ready = function() {};

    DriveBarUI.prototype.position = function() {
      var ref;
      ref = this.createSvg(this.$, this.htmlId, this.name, this.ext, this.svgWidth(), this.svgHeight(), this.barTop()), this.svg = ref[0], this.$svg = ref[1], this.g = ref[2], this.$g = ref[3], this.gId = ref[4], this.gw = ref[5], this.gh = ref[6], this.y0 = ref[7];
      this.left = this.parent.$.offset().left;
      this.top = this.parent.$.offset().top;
      return this.subscribe();
    };

    DriveBarUI.prototype.subscribe = function() {
      this.stream.subscribe('Location', (function(_this) {
        return function(location) {
          return _this.onLocation(location);
        };
      })(this));
      this.stream.subscribe('Orient', (function(_this) {
        return function(orientation) {
          return _this.layout(orientation);
        };
      })(this));
      return this.stream.subscribe('Trip', (function(_this) {
        return function(trip) {
          return _this.onTrip(trip);
        };
      })(this));
    };

    DriveBarUI.prototype.onLocation = function(location) {
      return Util.noop('DriveBar.onLocation()', this.ext, location);
    };

    DriveBarUI.prototype.onTrip = function(trip) {
      if (!this.created || trip.name !== this.lastTrip.name) {
        this.createBars(trip);
      } else {
        this.updateFills(trip);
      }
      return this.lastTrip = trip;
    };

    DriveBarUI.prototype.layout = function(orientation) {
      Util.noop(orientation);
    };

    DriveBarUI.prototype.svgWidth = function() {
      if (this.orientation === 'Portrait') {
        return this.app.width() * 0.92;
      } else {
        return this.app.height();
      }
    };

    DriveBarUI.prototype.svgHeight = function() {
      if (this.orientation === 'Portrait') {
        return this.app.height() * 0.33;
      } else {
        return this.app.width() * 0.50;
      }
    };

    DriveBarUI.prototype.barHeight = function() {
      return this.svgHeight() * 0.33;
    };

    DriveBarUI.prototype.barTop = function() {
      return this.svgHeight() * 0.50;
    };

    DriveBarUI.prototype.createSvg = function($, htmlId, name, ext, width, height, barTop) {
      var $g, $svg, g, gId, svg, svgId;
      svgId = Util.svgId(name, ext, 'Svg');
      gId = Util.svgId(name, ext, 'G');
      svg = d3.select('#' + htmlId).append("svg:svg").attr("id", svgId).attr("width", width).attr("height", height);
      g = svg.append("svg:g").attr("id", gId);
      $svg = $.find('#' + svgId);
      $g = $.find('#' + gId);
      return [svg, $svg, g, $g, gId, width, height, barTop];
    };

    DriveBarUI.prototype.createBars = function(trip) {
      var beg, end, fill, h, i, len, ref, seg, thick, w, x, y;
      d3.select('#' + this.gId).selectAll("*").remove();
      this.mileBeg = trip.begMile();
      this.mileEnd = trip.endMile();
      this.distance = Math.abs(this.mileEnd - this.mileBeg);
      thick = 1;
      x = 0;
      y = this.barTop();
      w = this.svgWidth();
      h = this.barHeight();
      this.createTravelTime(trip, this.g, x, y, w, h);
      this.rect(trip, this.g, trip.segments[0], this.ext + 'Border', x, y, w, h, 'transparent', 'white', thick * 4, '');
      ref = trip.segments;
      for (i = 0, len = ref.length; i < len; i++) {
        seg = ref[i];
        beg = w * Math.abs(Util.toFloat(seg.StartMileMarker) - this.mileBeg) / this.distance;
        end = w * Math.abs(Util.toFloat(seg.EndMileMarker) - this.mileBeg) / this.distance;
        fill = this.fillCondition(seg.segId, trip.conditions);
        this.rect(trip, this.g, seg, seg.segId, beg, y, Math.abs(end - beg), h, fill, 'black', thick, '');
      }
      this.created = true;
    };

    DriveBarUI.prototype.createTravelTime = function(trip, g, x, y, w, h) {
      var fontSize, fontSizePx;
      fontSize = 18;
      fontSizePx = fontSize + 'px';
      g.append("svg:text").text(trip.source).attr("x", 4).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "start").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
      g.append("svg:text").text('TRAVEL TIME').attr("x", w / 2).attr("y", y - fontSize * 3.3).attr('fill', 'white').attr("text-anchor", "middle").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
      g.append("svg:text").text(trip.etaHoursMins()).attr("x", w / 2).attr("y", y - fontSize * 2.2).attr('fill', 'white').attr("text-anchor", "middle").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
      return g.append("svg:text").text(trip.destination).attr("x", w - 4).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "end").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
    };

    DriveBarUI.prototype.fillCondition = function(segId, conditions) {
      var Conditions;
      Conditions = this.getTheCondition(segId, conditions);
      if ((Conditions == null) || (Conditions.AverageSpeed == null)) {
        return 'gray';
      }
      return this.fillSpeed(Conditions.AverageSpeed);
    };

    DriveBarUI.prototype.getTheCondition = function(segId, conditions) {
      var condition, i, len;
      for (i = 0, len = conditions.length; i < len; i++) {
        condition = conditions[i];
        if ((condition.SegmentId != null) && (condition.Conditions != null)) {
          if (segId === condition.SegmentId) {
            return condition.Conditions;
          }
        }
      }
      return void 0;
    };

    DriveBarUI.prototype.fillSpeed = function(speed) {
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
    };

    DriveBarUI.prototype.updateFills = function(trip) {
      var condition, fill, i, len, ref, segId;
      ref = trip.conditions;
      for (i = 0, len = ref.length; i < len; i++) {
        condition = ref[i];
        segId = Util.toInt(condition.SegmentId);
        fill = this.fillSpeed(condition.Conditions.AverageSpeed);
        this.updateRectFill(segId, fill);
      }
    };

    DriveBarUI.prototype.rect = function(trip, g, seg, segId, x0, y0, w, h, fill, stroke, thick, text) {
      var onClick, svgId;
      svgId = Util.svgId(this.name, segId.toString(), this.ext);
      onClick = (function(_this) {
        return function() {
          x = d3.mouse(this)[0];
          var mile;
          mile = _this.mileBeg + (_this.mileEnd - _this.mileBeg) * x / _this.svgWidth();
          Util.dbg('DriveBar.rect()', {
            segId: segId,
            beg: seg.StartMileMarker,
            mile: Util.toFixed(mile, 1),
            end: seg.EndMileMarker
          });
          return _this.doSeqmentDeals(trip, segId, mile);
        };
      })(this);
      g.append("svg:rect").attr('id', svgId).attr("x", x0).attr("y", y0).attr("width", w).attr("height", h).attr('segId', segId).attr("fill", fill).attr("stroke", stroke).attr("stroke-width", thick).on('click', onClick);
      if (text !== '') {
        g.append("svg:text").text(text).attr("x", x0 + w / 2).attr("y", y0 + h / 2 + 2).attr('fill', fill).attr("text-anchor", "middle").attr("font-size", "4px").attr("font-family", "Droid Sans");
      }
    };

    DriveBarUI.prototype.doSeqmentDeals = function(trip, segId, mile) {
      var deals, exit;
      deals = trip.getDealsBySegId(segId);
      exit = Util.toInt(mile);
      if (deals.length > 0) {
        this.app.dealsUI.popupMultipleDeals('Deals', "for Exit ", "" + exit, deals);
        return $('#gritter-notice-wrapper').show();
      }
    };

    DriveBarUI.prototype.updateRectFill = function(segId, fill) {
      var rect, rectId;
      rectId = Util.svgId(this.name, segId.toString(), this.ext);
      rect = $svg.find('#' + rectId);
      rect.attr('fill', fill);
    };

    DriveBarUI.prototype.layout2 = function(orientation) {
      var xs, ys;
      this.orientation = orientation;
      this.svg.attr("width", this.svgWidth()).attr('height', this.svgHeight());
      xs = this.gw > 0 ? this.gw / this.svgWidth() : 1.0;
      ys = 1.0;
      this.g.attr('transform', "scale(" + xs + "," + ys + ")");
    };

    return DriveBarUI;

  })();

}).call(this);
