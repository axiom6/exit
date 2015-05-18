
class Weather

  Util.Export( Weather, 'ui/Weather' )

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

  @Locs[0].fore = { time:1430776040, summary:'Overcast',   fcIcon:'cloudy', style:{ back:'silver', icon:'wi-cloudy'  }, precipProbability:0.01, precipType:'rain', temperature:44.16, windSpeed:5.7, cloudCover:0.99  }
  @Locs[1].fore = { time:1430776040, summary:'Drizzle',    fcIcon:'rain',   style:{ back:'silver', icon:'wi-showers' }, precipProbability:0.67, precipType:'rain', temperature:43.61, windSpeed:6.3, cloudCover:0.89  }
  @Locs[2].fore = { time:1430776040, summary:'Overcast',   fcIcon:'cloudy', style:{ back:'silver', icon:'wi-cloudy'  }, precipProbability:0.19, precipType:'rain', temperature:39.49, windSpeed:6.9, cloudCover:0.97  }
  @Locs[3].fore = { time:1430776040, summary:'Overcast',   fcIcon:'cloudy', style:{ back:'silver', icon:'wi-cloudy'  }, precipProbability:0.21, precipType:'rain', temperature:39.57, windSpeed:6.82, cloudCover:0.97 }
  @Locs[4].fore = { time:1430776040, summary:'Light Rain', fcIcon:'rain',   style:{ back:'silver', icon:'wi-rain'    }, precipProbability:1,    precipType:'rain', temperature:47.4,  windSpeed:6.89, cloudCover:0.85 }
  @Locs[5].fore = { time:1430776040, summary:'Light Rain', fcIcon:'rain',   style:{ back:'silver', icon:'wi-rain'    }, precipProbability:1,    precipType:'rain', temperature:46.92, windSpeed:3.44, cloudCover:1    }
  @Locs[6].fore = { time:1430776041, summary:'Drizzle',    fcIcon:'rain',   style:{ back:'silver', icon:'wi-showers' }, precipProbability:0.53, precipType:'rain', temperature:47.29, windSpeed:3.94, cloudCover:0.94 }
  @Locs[7].fore = { time:1430776041, summary:'Light Rain', fcIcon:'rain',   style:{ back:'silver', icon:'wi-rain'    }, precipProbability:1,    precipType:'rain', temperature:44.83, windSpeed:2.43, cloudCover:0.87 }

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

  constructor:( @app, @stream ) ->

  ready:() ->
    @$ = $( """<div id="Weather" class="Weather"></div>""" )
    for loc in Weather.Locs
      @createHtml( loc ) # @forecast( loc )

  position:() ->
    @subscribe()

  # Trip subscribe to the full Monty of change
  subscribe:() ->
    #@stream.subscribe( 'Trip',        (object) =>        @onTrip(object.content) )
    @stream.subscribe( 'Location',    (object) =>    @onLocation(object.content) )
    #@stream.subscribe( 'Conditions',  (object) => @onConditions( object.content) )

  onTrip:( trip ) ->
    Util.dbg( 'Weather.onTrip()', trip )

  onLocation:( latlon ) ->
    Util.dbg( 'Weather.onLocation() latlon', latlon )

  layout:( orientation ) ->
    Util.dbg( 'Weather.layout() latlon', orientation )

# For now the DriveBars handle most of the changing conditions
  onConditions:( conditions ) ->
    Util.noop(   conditions )
    Util.dbg( 'Weather.onConditions()' )

  exitJSON:(  json ) ->
    ej = {}            # Exit Now JSON forecast
    fc = json.currently # The current forecast data point
    ej.time              = fc.time
    ej.summary           = fc.summary
    ej.fcIcon            = fc.icon  
    ej.style             = Weather.Icons[fc.icon]
    ej.style.icon        = 'wi-showers' if ej.summary is 'Drizzle'
    ej.precipProbability = fc.precipProbability
    ej.precipType        = fc.precipType #rain, snow, sleet
    ej.temperature       = Util.toFixed(fc.temperature,0) # Farenheit
    ej.windSpeed         = fc.windSpeed
    ej.cloudCover        = fc.cloudCover
    Util.dbg( ej )
    ej

  createHtml:( loc, json=null ) ->
    if json?
      loc.forecast = @exitJSON( json )
      f = loc.forecast
    else
      f = loc.fore
    f.temperature = Util.toFixed(f.temperature,0)
    time          = Util.toTime( f.time )   # {f.style.back}
    html = """<div   class="Weather#{loc.index}" style="background-color:beige">
                <div class="WeatherName">#{loc.name}</div>
                <div class="WeatherTime">#{time}</div>
                <i   class="WeatherIcon wi #{f.style.icon}"></i>
                <div class="WeatherSumm">#{f.summary}</div>
                <div class="WeatherTemp">#{f.temperature}&deg;F</div>
              </div>"""
    @$.append( html )


  # A numerical value between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds.
  # A value of 0 corresponds to clear sky, 0.4 to scattered clouds, 0.75 to broken cloud cover, and 1 to completely overcast skies.

  forecast:( loc ) ->
    key = '2c52a8974f127eee9de82ea06aadc7fb'
    url = """https://api.forecast.io/forecast/#{key}/#{loc.lat},#{loc.lon}"""
    settings = { url:url, type:'GET', dataType:'jsonp', contentType:'text/plain' }
    settings.success = ( json, textStatus, jqXHR ) =>
      Util.noop( textStatus, jqXHR )
      @createHtml( loc, json )
    settings.error = ( jqXHR, textStatus, errorThrown ) ->
        Util.noop( errorThrown )
        Util.error('Weather.forcast', { url:url, text:textStatus } )
    $.ajax( settings )





