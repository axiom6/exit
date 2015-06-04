// Generated by CoffeeScript 1.9.1
(function() {
  var WeatherUI,
    hasProp = {}.hasOwnProperty;

  WeatherUI = (function() {
    Util.Export(WeatherUI, 'ui/WeatherUI');

    WeatherUI.Locs = [
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

    WeatherUI.Locs[0].fore = {
      key: "Evergreen",
      name: "Evergreen",
      lon: -105.334724,
      lat: 39.701735,
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

    WeatherUI.Locs[1].fore = {
      key: "US40",
      name: "US40",
      lon: -105.654065,
      lat: 39.759558,
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

    WeatherUI.Locs[2].fore = {
      key: "EastTunnel",
      name: "East Tunnel",
      lon: -105.891111,
      lat: 39.681757,
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

    WeatherUI.Locs[3].fore = {
      key: "WestTunnel",
      name: "West Tunnel",
      lon: -105.878342,
      lat: 39.692400,
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

    WeatherUI.Locs[4].fore = {
      key: "Silverthorne",
      name: "Silverthorne",
      lon: -106.072685,
      lat: 39.624160,
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

    WeatherUI.Locs[5].fore = {
      key: "CopperMtn",
      name: "Copper Mtn",
      lon: -106.147382,
      lat: 39.503512,
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

    WeatherUI.Locs[6].fore = {
      key: "VailPass",
      name: "Vail Pass",
      lon: -106.216071,
      lat: 39.531042,
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

    WeatherUI.Locs[7].fore = {
      key: "Vail",
      name: "Vail",
      lon: -106.378767,
      lat: 39.644407,
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

    WeatherUI.Icons = {};

    WeatherUI.Icons['clear-day'] = {
      back: 'lightblue',
      icon: 'wi-day-cloudy'
    };

    WeatherUI.Icons['clear-night'] = {
      back: 'black',
      icon: 'wi-stars'
    };

    WeatherUI.Icons['rain'] = {
      back: 'silver',
      icon: 'wi-rain'
    };

    WeatherUI.Icons['snow'] = {
      back: 'silver',
      icon: 'wi-snow'
    };

    WeatherUI.Icons['sleet'] = {
      back: 'silver',
      icon: 'wi-sleet'
    };

    WeatherUI.Icons['wind'] = {
      back: 'silver',
      icon: 'wi-day-windy'
    };

    WeatherUI.Icons['fog'] = {
      back: 'silver',
      icon: 'wi-fog'
    };

    WeatherUI.Icons['cloudy'] = {
      back: 'silver',
      icon: 'wi-cloudy'
    };

    WeatherUI.Icons['partly-cloudy-day'] = {
      back: 'gainsboro',
      icon: 'wi-night-cloudy'
    };

    WeatherUI.Icons['partly-cloudy-night'] = {
      back: 'darkslategray',
      icon: 'wi-night-alt-cloudy'
    };

    WeatherUI.Icons['hail'] = {
      back: 'dimgray',
      icon: 'wi-hail'
    };

    WeatherUI.Icons['thunderstorm'] = {
      back: 'darkslategray',
      icon: 'wi-thunderstorm'
    };

    WeatherUI.Icons['tornado'] = {
      back: 'black',
      icon: 'wi-tornado'
    };

    WeatherUI.Icons['unknown'] = {
      back: 'black',
      icon: 'wi-wind-default _0-deg'
    };

    function WeatherUI(stream) {
      this.stream = stream;
      this.trip = {};
      this.forecasts = {};
    }

    WeatherUI.prototype.ready = function() {
      return this.$ = $("<div id=\"Weather\" class=\"Weather\"></div>");
    };

    WeatherUI.prototype.position = function(screen) {
      Util.noop(screen);
      return this.subscribe();
    };

    WeatherUI.prototype.subscribe = function() {
      this.stream.subscribe('Trip', (function(_this) {
        return function(trip) {
          return _this.onTrip(trip);
        };
      })(this));
      this.stream.subscribe('Forecasts', (function(_this) {
        return function(forecasts) {
          return _this.onForecasts(forecasts);
        };
      })(this));
      this.stream.subscribe('Location', (function(_this) {
        return function(location) {
          return _this.onLocation(location);
        };
      })(this));
      return this.stream.subscribe('Screen', (function(_this) {
        return function(screen) {
          return _this.onScreen(screen);
        };
      })(this));
    };

    WeatherUI.prototype.onLocation = function(location) {
      return Util.noop('WeatherUI.onLocation()', location);
    };

    WeatherUI.prototype.onScreen = function(screen) {
      return Util.noop('WeatherUI.screen()', screen);
    };

    WeatherUI.prototype.onTrip = function(trip) {
      this.trip = trip;
    };

    WeatherUI.prototype.onForecasts = function(forecasts) {
      var $f, forecast, name, w;
      for (name in forecasts) {
        if (!hasProp.call(forecasts, name)) continue;
        forecast = forecasts[name];
        $f = $('#' + ("Weather" + name));
        w = this.toWeather(forecast);
        if (Util.isJQuery($f)) {
          this.updateForecastHtml(name, w, $f);
        } else {
          this.createForecastHtml(name, w);
        }
      }
    };

    WeatherUI.prototype.createForecastHtml = function(name, w) {
      var html;
      html = "<div   class=\"Weather" + w.index + "\" style=\"background-color:" + w.back + "\" id=\"Weather" + name + "\">\n  <div class=\"WeatherName\">" + name + "</div>\n  <div class=\"WeatherTime\">" + w.hms + "</div>\n  <i   class=\"WeatherIcon wi " + w.icon + "\"></i>\n  <div class=\"WeatherSum1\">" + w.summary1 + "</div>\n  <div class=\"WeatherSum2\">" + w.summary2 + "</div>\n  <div class=\"WeatherTemp\">" + w.temperature + "&deg;F</div>\n</div>";
      this.$.append(html);
    };

    WeatherUI.prototype.updateForecastHtml = function(name, w, $f) {
      $f.find(".WeatherTime").text(w.hms);
      $f.find(".WeatherIcon").attr('class', "WeatherIcon wi " + w.icon);
      $f.find(".WeatherSum1").text(w.summary1);
      $f.find(".WeatherSum2").text(w.summary2);
      $f.find(".WeatherTemp").text(w.temperature + "&deg;F");
    };

    WeatherUI.prototype.toWeather = function(forecast) {
      var f, summaries, w;
      f = forecast.currently != null ? forecast.currently : forecast;
      w = {};
      w.index = forecast.index;
      w.temperature = Util.toFixed(f.temperature, 0);
      w.hms = Util.toHMS(f.time);
      w.time = f.time;
      summaries = f.summary.split(' ');
      w.summary1 = summaries[0];
      w.summary2 = summaries[1] != null ? summaries[1] : '&nbsp;';
      w.fcIcon = f.icon;
      if (WeatherUI.Icons[w.fcIcon] != null) {
        w.back = WeatherUI.Icons[f.icon].back;
        w.icon = WeatherUI.Icons[f.icon].icon;
      } else {
        w.back = WeatherUI.Icons['unknown'].back;
        w.icon = WeatherUI.Icons['unknown'].icon;
      }
      if (w.summary === 'Drizzle') {
        w.icon = 'wi-showers';
      }
      w.precipProbability = f.precipProbability;
      w.precipType = f.precipType;
      w.windSpeed = f.windSpeed;
      w.cloudCover = f.cloudCover;
      return w;
    };

    WeatherUI.prototype.forecast = function(loc) {
      var key, settings, url;
      key = '2c52a8974f127eee9de82ea06aadc7fb';
      url = "https://api.forecast.io/forecast/" + key + "/" + loc.lat + "," + loc.lon + "," + loc.time;
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

    return WeatherUI;

  })();

}).call(this);
