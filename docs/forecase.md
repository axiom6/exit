
 https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE

latitude: The requested latitude.
longitude: The requested longitude.
timezone: The IANA timezone name for the requested location (e.g. America/New_York). This is the timezone used for text forecast summaries and for determining the exact start time of daily data points. (Developers are advised to rely on local system settings rather than this value if at all possible: users may deliberately set an unusual timezone, and furthermore are likely to know what they actually want better than our timezone database does.)
offset: The current timezone offset in hours from GMT.
currently: A data point (see below) containing the current weather conditions at the requested location.
minutely: A data block (see below) containing the weather conditions minute-by-minute for the next hour. (This property’s name should be read as an adjective—analogously to “hourly” or “daily” and meaning “reckoned by the minute”—rather than as an adverb meaning “meticulously.” Yes, we know that this is not proper English. No, we will not change it. Complaints to this effect will be deleted with utmost prejudice.)
hourly: A data block (see below) containing the weather conditions hour-by-hour for the next two days.
daily: A data block (see below) containing the weather conditions day-by-day for the next week.
alerts: An array of alert objects (see below), which, if present, contains any severe weather alerts, issued by a governmental weather authority, pertinent to the requested location.
flags: An object containing miscellaneous metadata concerning this request. (See flags object, below.)

Data point objects may contain the following properties:

time: The UNIX time (that is, seconds since midnight GMT on 1 Jan 1970) at which this data point occurs.
summary: A human-readable text summary of this data point.
icon: A machine-readable text summary of this data point, suitable for selecting an icon for display. If defined, this property will have one of the following values: clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night. (Developers should ensure that a sensible default is defined, as additional values, such as hail, thunderstorm, or tornado, may be defined in the future.)
sunriseTime and sunsetTime (only defined on daily data points): The UNIX time (that is, seconds since midnight GMT on 1 Jan 1970) of the last sunrise before and first sunset after the solar noon closest to local noon on the given day. (Note: near the poles, these may occur on a different day entirely!)
moonPhase (only defined on daily data points): A number representing the fractional part of the lunation number of the given day. This can be thought of as the “percentage complete” of the current lunar month: a value of 0 represents a new moon, a value of 0.25 represents a first quarter moon, a value of 0.5 represents a full moon, and a value of 0.75 represents a last quarter moon. (The ranges in between these represent waxing crescent, waxing gibbous, waning gibbous, and waning crescent moons, respectively.)
nearestStormDistance (only defined on currently data points): A numerical value representing the distance to the nearest storm in miles. (This value is very approximate and should not be used in scenarios requiring accurate results. In particular, a storm distance of zero doesn’t necessarily refer to a storm at the requested location, but rather a storm in the vicinity of that location.)
nearestStormBearing (only defined on currently data points): A numerical value representing the direction of the nearest storm in degrees, with true north at 0° and progressing clockwise. (If nearestStormDistance is zero, then this value will not be defined. The caveats that apply to nearestStormDistance also apply to this value.)
precipIntensity: A numerical value representing the average expected intensity (in inches of liquid water per hour) of precipitation occurring at the given time conditional on probability (that is, assuming any precipitation occurs at all). A very rough guide is that a value of 0 in./hr. corresponds to no precipitation, 0.002 in./hr. corresponds to very light precipitation, 0.017 in./hr. corresponds to light precipitation, 0.1 in./hr. corresponds to moderate precipitation, and 0.4 in./hr. corresponds to heavy precipitation.
precipIntensityMax, and precipIntensityMaxTime (only defined on daily data points): numerical values representing the maximumum expected intensity of precipitation (and the UNIX time at which it occurs) on the given day in inches of liquid water per hour.
precipProbability: A numerical value between 0 and 1 (inclusive) representing the probability of precipitation occuring at the given time.
precipType: A string representing the type of precipitation occurring at the given time. If defined, this property will have one of the following values: rain, snow, sleet (which applies to each of freezing rain, ice pellets, and “wintery mix”), or hail. (If precipIntensity is zero, then this property will not be defined.)
precipAccumulation (only defined on hourly and daily data points): the amount of snowfall accumulation expected to occur on the given day. (If no accumulation is expected, this property will not be defined.)
temperature (not defined on daily data points): A numerical value representing the temperature at the given time in degrees Fahrenheit.
temperatureMin, temperatureMinTime, temperatureMax, and temperatureMaxTime (only defined on daily data points): numerical values representing the minimum and maximumum temperatures (and the UNIX times at which they occur) on the given day in degrees Fahrenheit.
apparentTemperature (not defined on daily data points): A numerical value representing the apparent (or “feels like”) temperature at the given time in degrees Fahrenheit.
apparentTemperatureMin, apparentTemperatureMinTime, apparentTemperatureMax, and apparentTemperatureMaxTime (only defined on daily data points): numerical values representing the minimum and maximumum apparent temperatures (and the UNIX times at which they occur) on the given day in degrees Fahrenheit.
dewPoint: A numerical value representing the dew point at the given time in degrees Fahrenheit.
windSpeed: A numerical value representing the wind speed in miles per hour.
windBearing: A numerical value representing the direction that the wind is coming from in degrees, with true north at 0° and progressing clockwise. (If windSpeed is zero, then this value will not be defined.)
cloudCover: A numerical value between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds. A value of 0 corresponds to clear sky, 0.4 to scattered clouds, 0.75 to broken cloud cover, and 1 to completely overcast skies.
humidity: A numerical value between 0 and 1 (inclusive) representing the relative humidity.
pressure: A numerical value representing the sea-level air pressure in millibars.
visibility: A numerical value representing the average visibility in miles, capped at 10 miles.
ozone: A numerical value representing the columnar density of total atmospheric ozone at the given time in Dobson units.

All of the above numeric, non-time fields may, optionally, have an associated Error value defined (with the property precipIntensityError, windSpeedError, pressureError, etc.), representing our system’s confidence in its prediction. Such properties represent standard deviations of the value of their associated property; small error values therefore represent a strong confidence, while large error values represent a weak confidence. These properties are omitted where the confidence is not precisely known (though generally considered to be adequate).

Access-Control-Allow-Origin: http://api.bob.com
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: FooBar
Content-Type: text/html; charset=utf-8