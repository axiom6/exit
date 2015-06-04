
class WeatherUI

  Util.Export( WeatherUI, 'ui/WeatherUI' )

  # Devner Lat 39.779062 -104.982605

  @Locs = [
    { key:"Evergreen",    index:1, lon:-105.334724, lat:39.701735, name:"Evergreen"      }
    { key:"US40",         index:2, lon:-105.654065, lat:39.759558, name:"US40"           }
    { key:"EastTunnel",   index:3, lon:-105.891111, lat:39.681757, name:"East Tunnel"    }
    { key:"WestTunnel",   index:4, lon:-105.878342, lat:39.692400, name:"West Tunnel"    }
    { key:"Silverthorne", index:5, lon:-106.072685, lat:39.624160, name:"Silverthorne"   }
    { key:"CopperMtn",    index:6, lon:-106.147382, lat:39.503512, name:"Copper Mtn"     }
    { key:"VailPass",     index:7, lon:-106.216071, lat:39.531042, name:"Vail Pass"      }
    { key:"Vail",         index:8, lon:-106.378767, lat:39.644407, name:"Vail"           } ]

  @Locs[0].fore = { key:"Evergreen",    name:"Evergreen",    lon:-105.334724, lat:39.701735, time:1430776040, summary:'Overcast',   fcIcon:'cloudy', style:{ back:'silver', icon:'wi-cloudy'  }, precipProbability:0.01, precipType:'rain', temperature:44.16, windSpeed:5.7, cloudCover:0.99  }
  @Locs[1].fore = { key:"US40",         name:"US40",         lon:-105.654065, lat:39.759558, time:1430776040, summary:'Drizzle',    fcIcon:'rain',   style:{ back:'silver', icon:'wi-showers' }, precipProbability:0.67, precipType:'rain', temperature:43.61, windSpeed:6.3, cloudCover:0.89  }
  @Locs[2].fore = { key:"EastTunnel",   name:"East Tunnel",  lon:-105.891111, lat:39.681757, time:1430776040, summary:'Overcast',   fcIcon:'cloudy', style:{ back:'silver', icon:'wi-cloudy'  }, precipProbability:0.19, precipType:'rain', temperature:39.49, windSpeed:6.9, cloudCover:0.97  }
  @Locs[3].fore = { key:"WestTunnel",   name:"West Tunnel",  lon:-105.878342, lat:39.692400, time:1430776040, summary:'Overcast',   fcIcon:'cloudy', style:{ back:'silver', icon:'wi-cloudy'  }, precipProbability:0.21, precipType:'rain', temperature:39.57, windSpeed:6.82, cloudCover:0.97 }
  @Locs[4].fore = { key:"Silverthorne", name:"Silverthorne", lon:-106.072685, lat:39.624160, time:1430776040, summary:'Light Rain', fcIcon:'rain',   style:{ back:'silver', icon:'wi-rain'    }, precipProbability:1,    precipType:'rain', temperature:47.4,  windSpeed:6.89, cloudCover:0.85 }
  @Locs[5].fore = { key:"CopperMtn",    name:"Copper Mtn",   lon:-106.147382, lat:39.503512, time:1430776040, summary:'Light Rain', fcIcon:'rain',   style:{ back:'silver', icon:'wi-rain'    }, precipProbability:1,    precipType:'rain', temperature:46.92, windSpeed:3.44, cloudCover:1    }
  @Locs[6].fore = { key:"VailPass",     name:"Vail Pass",    lon:-106.216071, lat:39.531042, time:1430776041, summary:'Drizzle',    fcIcon:'rain',   style:{ back:'silver', icon:'wi-showers' }, precipProbability:0.53, precipType:'rain', temperature:47.29, windSpeed:3.94, cloudCover:0.94 }
  @Locs[7].fore = { key:"Vail",         name:"Vail",         lon:-106.378767, lat:39.644407, time:1430776041, summary:'Light Rain', fcIcon:'rain',   style:{ back:'silver', icon:'wi-rain'    }, precipProbability:1,    precipType:'rain', temperature:44.83, windSpeed:2.43, cloudCover:0.87 }

  @Icons = {}
  @Icons['clear-day']           = { back:'lightblue',      icon:'wi-day-cloudy' }
  @Icons['clear-night']         = { back:'black',          icon:'wi-stars' }  # 'wi-night-clear'
  @Icons['rain']                = { back:'silver',         icon:'wi-rain' }   # 'lightslategray'
  @Icons['snow']                = { back:'silver',         icon:'wi-snow' }             # 'lategray'
  @Icons['sleet']               = { back:'silver',         icon:'wi-sleet' }           #
  @Icons['wind']                = { back:'silver',         icon:'wi-day-windy' }        # 'gray'
  @Icons['fog']                 = { back:'silver',         icon:'wi-fog' }                        # 'lightgray'
  @Icons['cloudy']              = { back:'silver',         icon:'wi-cloudy' }
  @Icons['partly-cloudy-day']   = { back:'gainsboro',      icon:'wi-night-cloudy' }
  @Icons['partly-cloudy-night'] = { back:'darkslategray',  icon:'wi-night-alt-cloudy' }
  @Icons['hail']                = { back:'dimgray',        icon:'wi-hail' }
  @Icons['thunderstorm']        = { back:'darkslategray',  icon:'wi-thunderstorm' }
  @Icons['tornado']             = { back:'black',          icon:'wi-tornado' }
  @Icons['unknown']             = { back:'black',          icon:'wi-wind-default _0-deg' }

  constructor:( @app, @stream ) ->
    @trip      = {}  # Set by onTrip()
    @forecasts = {}  # Set by onForecasts()

  ready:() ->
    @$ = $( """<div id="Weather" class="Weather"></div>""" )

  position:() ->
    @subscribe()

  # Trip subscribe to the full Monty of change
  subscribe:() ->
    @stream.subscribe( 'Trip',        (trip)        => @onTrip(      trip        ) )
    @stream.subscribe( 'Forecasts',   (forecasts)   => @onForecasts( forecasts   ) )
    @stream.subscribe( 'Location',    (location)    => @onLocation(  location    ) )
    @stream.subscribe( 'Orient',      (orientation) => @layout(      orientation ) )

  onLocation:( location ) ->
    Util.noop( 'Weather.onLocation()', location )

  layout:( orientation ) ->
    Util.dbg( 'Weather.layout()', orientation )

  onTrip:( trip ) ->
    Util.dbg( 'Weather.onTrip()', trip.name )
    @trip = trip
    return

  onForecasts:( forecasts ) ->
    for own name, forecast of forecasts
      $f = $( '#'+"Weather#{name}")
      w  = @toWeather( forecast )
      if Util.isJQuery($f)
        @updateForecastHtml( name, w, $f )
      else
        @createForecastHtml( name, w )
    return

  createForecastHtml:( name, w ) ->
    html = """<div   class="Weather#{w.index}" style="background-color:#{w.back}" id="Weather#{name}">
                <div class="WeatherName">#{name}</div>
                <div class="WeatherTime">#{w.hms}</div>
                <i   class="WeatherIcon wi #{w.icon}"></i>
                <div class="WeatherSum1">#{w.summary1}</div>
                <div class="WeatherSum2">#{w.summary2}</div>
                <div class="WeatherTemp">#{w.temperature}&deg;F</div>
              </div>"""
    @$.append( html )
    return

  updateForecastHtml:( name, w, $f ) ->
    $f.find(".WeatherTime").text(w.hms)
    $f.find(".WeatherIcon").attr('class',"WeatherIcon wi #{w.icon}")
    $f.find(".WeatherSum1").text(w.summary1)
    $f.find(".WeatherSum2").text(w.summary2)
    $f.find(".WeatherTemp").text("#{w.temperature}&deg;F")
    return

  toWeather:( forecast ) ->
    f = if forecast.currently? then forecast.currently else forecast # The current forecast data point
    w = {}
    w.index             = forecast.index
    w.temperature       = Util.toFixed(f.temperature,0)
    w.hms               = Util.toHMS( f.time )
    w.time              = f.time
    summaries           = f.summary.split(' ')
    w.summary1          =    summaries[0]
    w.summary2          = if summaries[1]? then summaries[1] else '&nbsp;'
    w.fcIcon            = f.icon
    if WeatherUI.Icons[w.fcIcon]?
      w.back            = WeatherUI.Icons[f.icon].back
      w.icon            = WeatherUI.Icons[f.icon].icon
    else
      w.back            = WeatherUI.Icons['unknown'].back
      w.icon            = WeatherUI.Icons['unknown'].icon
    w.icon              = 'wi-showers' if w.summary is 'Drizzle'
    w.precipProbability = f.precipProbability
    w.precipType        = f.precipType #rain, snow, sleet
    w.windSpeed         = f.windSpeed
    w.cloudCover        = f.cloudCover
    Util.dbg( 'WeatherUI.toWeather forecast', f )
    Util.dbg( 'WeatherUI.toWeather weather ', w )
    w


  # A numerical value between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds.
  # A value of 0 corresponds to clear sky, 0.4 to scattered clouds, 0.75 to broken cloud cover, and 1 to completely overcast skies.

  forecast:( loc ) ->
    key = '2c52a8974f127eee9de82ea06aadc7fb'
    url = """https://api.forecast.io/forecast/#{key}/#{loc.lat},#{loc.lon},#{loc.time}"""
    settings = { url:url, type:'GET', dataType:'jsonp', contentType:'text/plain' }
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      @createHtml( loc, json )
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
        Util.noop( errorThrown )
        Util.error('Weather.forcast', { url:url, text:textStatus } )
    $.ajax( settings )





