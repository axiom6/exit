// Generated by CoffeeScript 1.9.1
(function() {
  var DriveBar,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    hasProp = {}.hasOwnProperty;

  DriveBar = (function() {
    Util.Export(DriveBar, 'ui/DriveBar');

    function DriveBar(app, stream, ext1, parent, orientation1) {
      this.app = app;
      this.stream = stream;
      this.ext = ext1;
      this.parent = parent;
      this.orientation = orientation1;
      this.onTrip = bind(this.onTrip, this);
      this.Data = Util.Import('app/Data');
      this.name = 'DriveBar';
      this.created = false;
    }

    DriveBar.prototype.html = function() {
      var htm;
      this.htmlId = this.app.id(this.name, this.ext);
      htm = "<div id=\"" + this.htmlId + "\" class=\"" + (this.app.css(this.name)) + "\"></div>";
      this.$ = $(htm);
      return htm;
    };

    DriveBar.prototype.ready = function() {};

    DriveBar.prototype.position = function() {
      var ref;
      ref = this.createSvg(this.$, this.htmlId, this.name, this.ext, this.svgWidth(), this.svgHeight(), this.barTop()), this.svg = ref[0], this.$svg = ref[1], this.g = ref[2], this.$g = ref[3], this.gw = ref[4], this.gh = ref[5], this.y0 = ref[6];
      this.left = this.parent.$.offset().left;
      this.top = this.parent.$.offset().top;
      return this.subscribe();
    };

    DriveBar.prototype.subscribe = function() {
      this.stream.subscribe('Location', (function(_this) {
        return function(object) {
          return _this.onLocation(object.content);
        };
      })(this));
      this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
      return this.stream.subscribe('Trip', (function(_this) {
        return function(object) {
          return _this.onTrip(object.content);
        };
      })(this));
    };

    DriveBar.prototype.onLocation = function(latlon) {
      return Util.dbg('DriveBar.onLocation()', this.ext, latlon);
    };

    DriveBar.prototype.onTrip = function(trip) {
      if (!this.created) {
        return this.createBars(trip, this.Data);
      } else {
        return this.updateBars(trip, this.Data);
      }
    };

    DriveBar.prototype.layout = function(orientation) {
      Util.noop(orientation);
    };

    DriveBar.prototype.svgWidth = function() {
      if (this.orientation === 'Portrait') {
        return this.app.width() * 0.92;
      } else {
        return this.app.height();
      }
    };

    DriveBar.prototype.svgHeight = function() {
      if (this.orientation === 'Portrait') {
        return this.app.height() * 0.33;
      } else {
        return this.app.width() * 0.50;
      }
    };

    DriveBar.prototype.barHeight = function() {
      return this.svgHeight() * 0.33;
    };

    DriveBar.prototype.barTop = function() {
      return this.svgHeight() * 0.50;
    };

    DriveBar.prototype.createSvg = function($, htmlId, name, ext, width, height, barTop) {
      var $g, $svg, g, gId, svg, svgId;
      svgId = this.app.svgId(name, ext, 'Svg');
      gId = this.app.svgId(name, ext, 'G');
      svg = d3.select('#' + htmlId).append("svg:svg").attr("id", svgId).attr("width", width).attr("height", height);
      g = svg.append("svg:g").attr("id", gId);
      $svg = $.find('#' + svgId);
      $g = $.find('#' + gId);
      return [svg, $svg, g, $g, width, height, barTop];
    };

    DriveBar.prototype.createBars = function(trip, Data) {
      var beg, end, eta, fill, h, key, m1, m2, ref, seg, segId, thick, w, x, y;
      Util.dbg('createBars', this.ext);
      this.mileBeg = Util.toFloat(this.app.model.begSeg(trip).StartMileMarker);
      this.mileEnd = Util.toFloat(this.app.model.endSeg(trip).EndMileMarker);
      this.mileRef = trip.direction === 'West' ? this.mileBeg : this.mileEnd;
      this.distRel = this.mileEnd - this.mileBeg;
      this.distance = Math.abs(this.mileEnd - this.mileBeg);
      thick = 1;
      x = 0;
      y = this.barTop();
      w = this.svgWidth();
      h = this.barHeight();
      eta = this.app.model.etaHoursMins(Util.toInt(trip.eta));
      this.createTravelTime(this.g, x, y, w, h, eta);
      ref = trip.segments.segments;
      for (key in ref) {
        if (!hasProp.call(ref, key)) continue;
        seg = ref[key];
        m1 = Util.toFloat(seg.StartMileMarker);
        m2 = Util.toFloat(seg.EndMileMarker);
        beg = w * Math.abs(m1 - this.mileRef) / this.distance;
        end = w * Math.abs(m2 - this.mileRef) / this.distance;
        segId = Util.toInt(key.substring(2));
        fill = this.fillCondition(segId, trip.conditions);
        this.rect(this.g, segId, beg, y, end - beg, h, fill, 'black', thick, '');
        this.created = true;
      }
    };

    DriveBar.prototype.createTravelTime = function(g, x, y, w, h, eta) {
      var fontSize, fontSizePx;
      fontSize = 18;
      fontSizePx = fontSize + 'px';
      g.append("svg:text").text(this.app.source).attr("x", 4).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "start").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
      g.append("svg:text").text('TRAVEL TIME').attr("x", w / 2).attr("y", y - fontSize * 2.2).attr('fill', 'white').attr("text-anchor", "middle").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
      g.append("svg:text").text(eta).attr("x", w / 2).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "middle").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
      return g.append("svg:text").text(this.app.dest).attr("x", w - 4).attr("y", y - fontSize).attr('fill', 'white').attr("text-anchor", "end").attr("font-size", fontSizePx).attr("font-family", "Droid Sans");
    };

    DriveBar.prototype.fillCondition = function(segId, conditions) {
      var Conditions;
      Conditions = this.getTheCondition(segId, conditions);
      if ((Conditions == null) || (Conditions.AverageSpeed == null)) {
        return 'gray';
      }
      return this.fillSpeed(Conditions.AverageSpeed);
    };

    DriveBar.prototype.getTheCondition = function(segId, conditions) {
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

    DriveBar.prototype.fillSpeed = function(speed) {
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

    DriveBar.prototype.updateBars = function(trip, Data) {
      var condition, fill, i, len, ref, segId;
      Util.dbg('updateBars', this.ext);
      ref = trip.conditions;
      for (i = 0, len = ref.length; i < len; i++) {
        condition = ref[i];
        segId = Util.toInt(condition.SegmentId);
        fill = this.fillSpeed(condition.Conditions.AverageSpeed);
        this.updateRectFill(segId, fill);
      }
    };

    DriveBar.prototype.updateBars2 = function(trip, Data) {
      var condition, fill, i, len, ref, segId;
      Util.dbg('updateBars', this.ext);
      ref = trip.conditions;
      for (i = 0, len = ref.length; i < len; i++) {
        condition = ref[i];
        segId = Util.toInt(condition.SegmentId);
        fill = this.fillCondition(segId, trip.conditions);
        this.updateRectFill(segId, fill);
      }
    };

    DriveBar.prototype.rect = function(g, segId, x0, y0, w, h, fill, stroke, thick, text) {
      var onClick, svgId;
      svgId = this.app.svgId(this.name, segId.toString(), this.ext);
      onClick = (function(_this) {
        return function() {
          x = d3.mouse(this)[0];
          var mile, mile1, mile2;
          mile1 = _this.mileRef + _this.distRel * x0 / _this.svgWidth();
          mile = _this.mileRef + _this.distRel * x / _this.svgWidth();
          mile2 = _this.mileRef + _this.distRel * (x0 + w) / _this.svgWidth();
          return _this.doSeqmentDeals(segId, mile);
        };
      })(this);
      g.append("svg:rect").attr('id', svgId).attr("x", x0).attr("y", y0).attr("width", w).attr("height", h).attr('segId', segId).attr("fill", fill).attr("stroke", stroke).attr("stroke-width", thick).on('click', onClick);
      if (text !== '') {
        g.append("svg:text").text(text).attr("x", x0 + w / 2).attr("y", y0 + h / 2 + 2).attr('fill', fill).attr("text-anchor", "middle").attr("font-size", "4px").attr("font-family", "Droid Sans");
      }
    };

    DriveBar.prototype.doSeqmentDeals = function(segId, mile) {
      var deals, exit;
      deals = this.app.model.getDealsBySegId(segId);
      exit = Util.toInt(mile);
      if (deals.length > 0) {
        this.app.deals.popupMultipleDeals('Deals', "for Exit ", "" + exit, deals);
        return $('#gritter-notice-wrapper').show();
      }
    };

    DriveBar.prototype.updateRectFill = function(segId, fill) {
      var rect, rectId;
      rectId = this.app.svgId(this.name, segId.toString(), this.ext);
      rect = $svg.find('#' + rectId);
      rect.attr('fill', fill);
    };

    DriveBar.prototype.layout2 = function(orientation) {
      var xs, ys;
      this.orientation = orientation;
      this.svg.attr("width", this.svgWidth()).attr('height', this.svgHeight());
      xs = this.gw > 0 ? this.gw / this.svgWidth() : 1.0;
      ys = 1.0;
      this.g.attr('transform', "scale(" + xs + "," + ys + ")");
    };

    return DriveBar;

  })();

}).call(this);
