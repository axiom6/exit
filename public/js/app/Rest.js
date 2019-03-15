var Rest,
  hasProp = {}.hasOwnProperty;

import Util from '../util/Util.js';

Rest = class Rest {
  constructor(stream) {
    this.logSegments = this.logSegments.bind(this);
    this.logConditions = this.logConditions.bind(this);
    this.logDeals = this.logDeals.bind(this);
    this.logMileposts = this.logMileposts.bind(this);
    this.logForecasts = this.logForecasts.bind(this);
    this.stream = stream;
    this.localURL = 'http://localhost:63342/exit/public/json/exit/';
    this.baseURL = "http://104.154.46.117/";
    this.jessURL = "https://exit-now-admin-jesseporter32.c9.io/";
    this.forecastIoURL = "https://api.forecast.io/forecast/";
    this.forecastIoKey = '2c52a8974f127eee9de82ea06aadc7fb';
    this.currURL = this.baseURL;
    this.segmentURL = this.currURL + "api/segment";
    this.conditionsURL = this.currURL + "api/state";
    this.dealsURL = this.currURL + "api/deals";
    this.cors = 'json'; // jsonp for different origin
    this.subscribe();
    Util.noop(this.jessURL, this.accept, this.jsonParse);
  }

  subscribe() {}

  //@stream.subscribe( 'RequestSegments', 'Rest', (query) => @requestSegmentsBy( query, doSegments, # onSegmentsError ) )
  //@stream.subscribe( 'RequestConditionsBy', 'Rest', (query) =>  @requestConditionsBy( query, doConditions, onConditionsError ) )
  //@stream.subscribe( 'RequestDealsBy',      'Rest', (query) =>  @requestDealsBy(      query, doDeals,      onDealsError      ) )
  segmentsFromLocal(direction, onSuccess, onError) {
    var args, url;
    url = `${this.localURL}Segments${direction}.json`;
    args = {
      url: url,
      direction: direction
    };
    this.get(url, 'Segments', args, onSuccess, onError);
  }

  conditionsFromLocal(direction, onSuccess, onError) {
    var args, url;
    url = `${this.localURL}Conditions${direction}.json`;
    args = {
      url: url,
      direction: direction
    };
    this.get(url, 'Conditions', args, onSuccess, onError);
  }

  // At this point Deals are not queurid by direction
  dealsFromLocal(direction, onSuccess, onError) {
    var args, url;
    url = `${this.localURL}Deals.json`;
    args = {
      url: url,
      direction: direction
    };
    this.get(url, 'Deals', args, onSuccess, onError);
  }

  milePostsFromLocal(onSuccess, onError) {
    var args, url;
    url = `${this.localURL}I70Mileposts.json`;
    args = {
      url: url
    };
    this.get(url, 'Mileposts', args, onSuccess, onError);
  }

  // Like the other fromLocal methods this is plural,
  //   because it gets all the forecasts for all the towns
  forecastsFromLocal(onSuccess, onError) {
    var args, url;
    url = `${this.localURL}Forecasts.json`;
    args = {
      url: url
    };
    this.get(url, 'Forecasts', args, onSuccess, onError);
  }

  segmentsByPreset(preset, onSuccess, onError) {
    var args, url;
    args = {
      preset: preset
    };
    url = `${this.segmentURL}?start=1,1&end=1,1&preset=${preset}`;
    this.get(url, 'Segments', args, onSuccess, onError);
  }

  conditionsBySegments(segments, onSuccess, onError) {
    var args, csv, url;
    args = {
      segments: segments
    };
    csv = this.toCsv(segments);
    url = `${this.conditionsURL}?segments=${csv}`;
    this.get(url, 'Conditions', args, onSuccess, onError);
  }

  deals(latlon, segments, onSuccess, onError) {
    var args, csv, url;
    args = {
      segments: segments,
      lat: latlon[0],
      lon: latlon[1]
    };
    csv = this.toCsv(segments);
    url = `${this.dealsURL}?segments=${csv}&loc=${latlon[0]},${latlon[1]}`;
    this.get(url, 'Deals', args, onSuccess, onError);
  }

  // Unlike the other rest methods this is singular,
  //   because it has to be called for each towm with its town.lon town.lat and town.time
  forecastByTown(name, town, onSuccess, onError) {
    var args;
    args = {
      name: name,
      town: town,
      lat: town.lat,
      lon: town.lon,
      time: town.time,
      hms: Util.toHMS(town.time)
    };
    //console.log( 'Rest.forecastByTown', args )
    //url  = """#{@forecastIoURL}#{@forecastIoKey}}/#{town.lat},#{town.lon}"""  # ,#{town.time}
    //@get( url, 'Forecast', args, onSuccess, onError )
    this.getForecast(args, onSuccess, onError);
  }

  getForecast(args, onSuccess, onError) {
    var key, settings, town, url;
    town = args.town;
    key = '2c52a8974f127eee9de82ea06aadc7fb';
    url = `https://api.forecast.io/forecast/${key}/${town.lat},${town.lon // ,#{town.isoDateTime}
}`;
    settings = {
      url: url,
      type: 'GET',
      dataType: 'jsonp',
      contentType: 'text/plain'
    };
    settings.success = (json, textStatus, jqXHR) => {
      Util.noop(textStatus, jqXHR);
      return onSuccess(args, json);
    };
    settings.error = function(jqXHR, textStatus, errorThrown) {
      Util.noop(errorThrown);
      return onError({
        url: url,
        args: args,
        from: 'Forecast'
      });
    };
    return $.ajax(settings);
  }

  // Unlike the other rest methods this is singular,
  //   because it has to be called for each lon lat and time
  forecastByLatLonTime(lat, lon, time, onSuccess, onError) {
    var args, url;
    args = {
      lat: lat,
      lon: lon,
      time: Util.toTime(time)
    };
    url = `${this.forecastIoURL}${this.forecastIoKey}}/${lat},${lon},${time}`;
    this.get(url, 'Forecast', args, onSuccess, onError);
  }

  requestSegmentsBy(query, onSuccess, onError) {
    Util.noop('Stream.requestSegmentsBy', query, onSuccess, onError);
  }

  requestConditionsBy(query, onSuccess, onError) {
    Util.noop('Stream.requestConditionsBy', query, onSuccess, onError);
  }

  requestDealsBy(query, onSuccess, onError) {
    Util.noop('Stream.requestDealsBy', query, onSuccess, onError);
  }

  segmentsByLatLon(slat, slon, elat, elon, onSuccess, onError) {
    var args, url;
    args = {
      slat: slat,
      slon: slon,
      elat: elat,
      elon: elon
    };
    url = `${this.segmentURL}?start=${slat},${slon}&end=${elat},${elon}`;
    this.get(url, 'Segments', args, onSuccess, onError);
  }

  segmentsBySegments(segments, onSuccess, onError) {
    var args, csv, url;
    args = {
      segments: segments
    };
    csv = this.toCsv(segments);
    url = `${this.segmentURL}?segments=${csv}`;
    this.get(url, 'Segments', args, onSuccess, onError);
  }

  // Date is format like 01/01/2015
  conditionsBySegmentsDate(segments, date, onSuccess, onError) {
    var args, csv, url;
    args = {
      segments: segments,
      date: date
    };
    csv = this.toCsv(segments);
    url = `${this.conditionsURL}?segments=${csv}&setdate=${date}`;
    this.get(url, 'Conditions', args, onSuccess, onError);
  }

  dealsByUrl(url, onSuccess, onError) {
    console.log('isCall', typeof onSuccess, onSuccess != null);
    this.get(url, 'Deals', {}, onSuccess, onError);
  }

  // Needs work
  accept(userId, dealId, convert, onSuccess, onError) {
    var args, url;
    args = {
      userId: userId,
      dealId: dealId,
      convert: convert
    };
    url = `${this.dealsURL}?userId=${userId}&_id=${dealId}&convert=${convert}`;
    this.post(url, 'Accept', args, onSuccess, onError);
  }

  get(url, from, args, onSuccess, onError) {
    var settings;
    settings = {
      url: url,
      type: 'GET',
      dataType: this.cors,
      contentType: 'application/json; charset=utf-8'
    };
    settings.success = (json, textStatus, jqXHR) => {
      Util.noop(textStatus, jqXHR);
      onSuccess(args, json);
    };
    settings.error = (jqXHR, textStatus, errorThrown) => {
      Util.noop(errorThrown);
      console.error('Rest.' + from, {
        url: url,
        args: args,
        text: textStatus
      });
      onError({
        url: url,
        args: args,
        from: from
      });
    };
    $.ajax(settings);
  }

  // Needs work
  post(url, from, args, onSuccess, onError) {
    var settings;
    settings = {
      url: url,
      type: 'POST',
      dataType: 'jsonp' // , contentType:'text/plain'
    };
    settings.success = (response, textStatus, jqXHR) => {
      Util.noop(textStatus, jqXHR);
      if (onSuccess != null) {
        return onSuccess(args, response);
      }
    };
    settings.error = (jqXHR, textStatus, errorThrown) => {
      Util.noop(errorThrown);
      console.error('Rest.' + from, {
        url: url,
        text: textStatus
      });
      return onError({
        url: url,
        args: args,
        from: from
      });
    };
    $.ajax(settings);
  }

  toCsv(array) {
    var a, csv, i, len1;
    csv = '';
    for (i = 0, len1 = array.length; i < len1; i++) {
      a = array[i];
      csv += a.toString() + ',';
    }
    return csv.substring(0, csv.length - 1); // Trim last comma
  }

  segIdNum(segment) {
    var id, key, len, num, obj;
    id = "";
    num = 0;
    for (key in segment) {
      if (!hasProp.call(segment, key)) continue;
      obj = segment[key];
      len = key.length;
      if (len >= 2 && 'id' === key.substring(0, 1)) {
        id = key;
        num = key.substring(0, 1);
      }
    }
    return [id, num];
  }

  logSegments(args, obj) {
    var i, id, len1, num, results, segment, segments;
    args.size = segments.length;
    segments = obj.segments;
    console.log('logSegments args', args);
    results = [];
    for (i = 0, len1 = segments.length; i < len1; i++) {
      segment = segments[i];
      id = 0;
      num = 0;
      [id, num] = this.segIdNum(segment);
      results.push(console.log('logSegment', {
        id: id,
        num: num,
        name: segment.name
      }));
    }
    return results;
  }

  logConditions(args, conditions) {
    var c, cc, i, len1, results;
    args.size = conditions.length;
    console.log('logConditions args', args);
    console.log('logConditions conds');
    results = [];
    for (i = 0, len1 = conditions.length; i < len1; i++) {
      c = conditions[i];
      cc = c['Conditions'];
      console.log('  condition', {
        SegmentId: c['SegmentId'],
        TravelTime: cc['TravelTime'],
        AverageSpeed: cc['AverageSpeed']
      });
      results.push(console.log('  weather', cc['Weather']));
    }
    return results;
  }

  logDeals(args, deals) {
    var d, dd, i, len1, results;
    args.size = deals.length;
    console.log('logDeals args', args);
    results = [];
    for (i = 0, len1 = deals.length; i < len1; i++) {
      d = deals[i];
      dd = d['dealData'];
      results.push(console.log('  ', {
        segmentId: dd['segmentId'],
        lat: d['lat'],
        lon: d['lon'],
        buiness: d['businessName'],
        description: d['name']
      }));
    }
    return results;
  }

  logMileposts(args, mileposts) {
    var i, len1, milepost, results;
    args.size = mileposts.length;
    console.log('logMileposts args', args);
    results = [];
    for (i = 0, len1 = mileposts.length; i < len1; i++) {
      milepost = mileposts[i];
      results.push(console.log('  ', milepost));
    }
    return results;
  }

  logForecasts(args, forecasts) {
    var forecast, i, len1, results;
    args.size = forecasts.length;
    console.log('logForecasts args', args);
    results = [];
    for (i = 0, len1 = forecasts.length; i < len1; i++) {
      forecast = forecasts[i];
      results.push(console.log('  ', forecast));
    }
    return results;
  }

  // Deprecated
  jsonParse(url, from, args, json, onSuccess) {
    var error, objs;
    json = json.toString().replace(/(\r\n|\n|\r)/gm, ""); // Remove all line breaks
    console.log('--------------------------');
    console.log(json);
    console.log('--------------------------');
    try {
      objs = JSON.parse(json);
      return onSuccess(args, objs);
    } catch (error1) {
      error = error1;
      return console.error('Rest.jsonParse()', {
        url: url,
        from: from,
        args: args,
        error: error
      });
    }
  }

};

/*
 curl 'https://api.forecast.io/forecast/2c52a8974f127eee9de82ea06aadc7fb/39.759558,-105.654065?callback=jQuery21308299770827870816_1433124323587&_=1433124323588'

 * """https://api.forecast.io/forecast/#{key}/#{loc.lat},#{loc.lon},#{loc.time}"""
 */
export default Rest;
