// Generated by CoffeeScript 1.9.1
(function() {
  var Weather;

  Weather = (function() {
    Util.Export(Weather, 'ui/Weather');

    Weather.Locs = [
      {
        key: "Evergreen",
        index: 1,
        lon: -105.334724,
        lat: 39.701735,
        name: "Evergreen"
      }, {
        key: "US40",
        index: 2,
        lon: -105.654065,
        lat: 39.759558,
        name: "US40"
      }, {
        key: "EastTunnel",
        index: 3,
        lon: -105.891111,
        lat: 39.681757,
        name: "East Tunnel"
      }, {
        key: "WestTunnel",
        index: 4,
        lon: -105.878342,
        lat: 39.692400,
        name: "West Tunnel"
      }, {
        key: "Silverthorne",
        index: 5,
        lon: -106.072685,
        lat: 39.624160,
        name: "Silverthorne"
      }, {
        key: "CopperMtn",
        index: 6,
        lon: -106.147382,
        lat: 39.503512,
        name: "Copper Mtn"
      }, {
        key: "VailPass",
        index: 7,
        lon: -106.216071,
        lat: 39.531042,
        name: "Vail Pass"
      }, {
        key: "Vail",
        index: 8,
        lon: -106.378767,
        lat: 39.644407,
        name: "Vail"
      }
    ];

    Weather.Locs[0].fore = {
      time: 1430776040,
      summary: 'Overcast',
      fcIcon: 'cloudy',
      style: {
        back: 'silver',
        icon: 'wi-cloudy'
      },
      precipProbability: 0.01,
      precipType: 'rain',
      temperature: 44.16,
      windSpeed: 5.7,
      cloudCover: 0.99
    };

    Weather.Locs[1].fore = {
      time: 1430776040,
      summary: 'Drizzle',
      fcIcon: 'rain',
      style: {
        back: 'silver',
        icon: 'wi-showers'
      },
      precipProbability: 0.67,
      precipType: 'rain',
      temperature: 43.61,
      windSpeed: 6.3,
      cloudCover: 0.89
    };

    Weather.Locs[2].fore = {
      time: 1430776040,
      summary: 'Overcast',
      fcIcon: 'cloudy',
      style: {
        back: 'silver',
        icon: 'wi-cloudy'
      },
      precipProbability: 0.19,
      precipType: 'rain',
      temperature: 39.49,
      windSpeed: 6.9,
      cloudCover: 0.97
    };

    Weather.Locs[3].fore = {
      time: 1430776040,
      summary: 'Overcast',
      fcIcon: 'cloudy',
      style: {
        back: 'silver',
        icon: 'wi-cloudy'
      },
      precipProbability: 0.21,
      precipType: 'rain',
      temperature: 39.57,
      windSpeed: 6.82,
      cloudCover: 0.97
    };

    Weather.Locs[4].fore = {
      time: 1430776040,
      summary: 'Light Rain',
      fcIcon: 'rain',
      style: {
        back: 'silver',
        icon: 'wi-rain'
      },
      precipProbability: 1,
      precipType: 'rain',
      temperature: 47.4,
      windSpeed: 6.89,
      cloudCover: 0.85
    };

    Weather.Locs[5].fore = {
      time: 1430776040,
      summary: 'Light Rain',
      fcIcon: 'rain',
      style: {
        back: 'silver',
        icon: 'wi-rain'
      },
      precipProbability: 1,
      precipType: 'rain',
      temperature: 46.92,
      windSpeed: 3.44,
      cloudCover: 1
    };

    Weather.Locs[6].fore = {
      time: 1430776041,
      summary: 'Drizzle',
      fcIcon: 'rain',
      style: {
        back: 'silver',
        icon: 'wi-showers'
      },
      precipProbability: 0.53,
      precipType: 'rain',
      temperature: 47.29,
      windSpeed: 3.94,
      cloudCover: 0.94
    };

    Weather.Locs[7].fore = {
      time: 1430776041,
      summary: 'Light Rain',
      fcIcon: 'rain',
      style: {
        back: 'silver',
        icon: 'wi-rain'
      },
      precipProbability: 1,
      precipType: 'rain',
      temperature: 44.83,
      windSpeed: 2.43,
      cloudCover: 0.87
    };

    Weather.Icons = {};

    Weather.Icons['clear-day'] = {
      back: 'lightblue',
      icon: 'wi-day-cloudy'
    };

    Weather.Icons['clear-night'] = {
      back: 'black',
      icon: 'wi-stars'
    };

    Weather.Icons['rain'] = {
      back: 'silver',
      icon: 'wi-rain'
    };

    Weather.Icons['snow'] = {
      back: 'silver',
      icon: 'wi-snow'
    };

    Weather.Icons['sleet'] = {
      back: 'silver',
      icon: 'wi-sleet'
    };

    Weather.Icons['wind'] = {
      back: 'silver',
      icon: 'wi-day-windy'
    };

    Weather.Icons['fog'] = {
      back: 'silver',
      icon: 'wi-fog'
    };

    Weather.Icons['cloudy'] = {
      back: 'silver',
      icon: 'wi-cloudy'
    };

    Weather.Icons['partly-cloudy-day'] = {
      back: 'gainsboro',
      icon: 'wi-night-cloudy'
    };

    Weather.Icons['partly-cloudy-night'] = {
      back: 'darkslategray',
      icon: 'wi-night-alt-cloudy'
    };

    Weather.Icons['hail'] = {
      back: 'dimgray',
      icon: 'wi-hail'
    };

    Weather.Icons['thunderstorm'] = {
      back: 'darkslategray',
      icon: 'wi-thunderstorm'
    };

    Weather.Icons['tornado'] = {
      back: 'black',
      icon: 'wi-tornado'
    };

    function Weather(app, stream) {
      this.app = app;
      this.stream = stream;
    }

    Weather.prototype.ready = function() {
      var i, len, loc, ref, results;
      this.$ = $("<div id=\"Weather\" class=\"Weather\"></div>");
      ref = Weather.Locs;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        loc = ref[i];
        results.push(this.createHtml(loc));
      }
      return results;
    };

    Weather.prototype.postReady = function() {
      return this.subscribe();
    };

    Weather.prototype.subscribe = function() {
      this.stream.subscribe('Destination', (function(_this) {
        return function(object) {
          return _this.onDestination(object.content);
        };
      })(this));
      this.stream.subscribe('Location', (function(_this) {
        return function(object) {
          return _this.onLocation(object.content);
        };
      })(this));
      return this.stream.subscribe('Conditions', (function(_this) {
        return function(object) {
          return _this.onConditions(object.content);
        };
      })(this));
    };

    Weather.prototype.onDestination = function(destination) {
      return Util.dbg('Weather.onDestination()', destination);
    };

    Weather.prototype.onLocation = function(latlon) {
      return Util.dbg('Weather.onLocation() latlon', latlon);
    };

    Weather.prototype.layout = function(orientation) {
      return Util.dbg('Weather.layout() latlon', orientation);
    };

    Weather.prototype.onConditions = function(conditions) {
      Util.noop(conditions);
      return Util.dbg('Weather.onConditions()');
    };

    Weather.prototype.exitJSON = function(json) {
      var ej, fc;
      ej = {};
      fc = json.currently;
      ej.time = fc.time;
      ej.summary = fc.summary;
      ej.fcIcon = fc.icon;
      ej.style = Weather.Icons[fc.icon];
      if (ej.summary === 'Drizzle') {
        ej.style.icon = 'wi-showers';
      }
      ej.precipProbability = fc.precipProbability;
      ej.precipType = fc.precipType;
      ej.temperature = Util.toFixed(fc.temperature, 0);
      ej.windSpeed = fc.windSpeed;
      ej.cloudCover = fc.cloudCover;
      Util.dbg(ej);
      return ej;
    };

    Weather.prototype.createHtml = function(loc, json) {
      var f, html, time;
      if (json == null) {
        json = null;
      }
      if (json != null) {
        loc.forecast = this.exitJSON(json);
        f = loc.forecast;
      } else {
        f = loc.fore;
      }
      f.temperature = Util.toFixed(f.temperature, 0);
      time = Util.toTime(f.time);
      html = "<div   class=\"Weather" + loc.index + "\" style=\"background-color:beige\">\n  <div class=\"WeatherName\">" + loc.name + "</div>\n  <div class=\"WeatherTime\">" + time + "</div>\n  <i   class=\"WeatherIcon wi " + f.style.icon + "\"></i>\n  <div class=\"WeatherSumm\">" + f.summary + "</div>\n  <div class=\"WeatherTemp\">" + f.temperature + "&deg;F</div>\n</div>";
      return this.$.append(html);
    };

    Weather.prototype.forecast = function(loc) {
      var key, settings, url;
      key = '2c52a8974f127eee9de82ea06aadc7fb';
      url = "https://api.forecast.io/forecast/" + key + "/" + loc.lat + "," + loc.lon;
      settings = {
        url: url,
        type: 'GET',
        dataType: 'jsonp',
        contentType: 'text/plain'
      };
      settings.success = (function(_this) {
        return function(json, textStatus, jqXHR) {
          Util.noop(textStatus, jqXHR);
          return _this.createHtml(loc, json);
        };
      })(this);
      settings.error = function(jqXHR, textStatus, errorThrown) {
        Util.noop(errorThrown);
        return Util.error('Weather.forcast', {
          url: url,
          text: textStatus
        });
      };
      return $.ajax(settings);
    };

    return Weather;

  })();

}).call(this);
