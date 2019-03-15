
import Util          from '../util/Util.js'

# Static data for demo that will be gradually be replaced with dynamic data from the server

class Data

  Util.noop( Data.DestinationsWest )

  Data.Destinations     =  ['','Denver',        'Idaho Springs',       'Georgetown',        'Silverthorne',       'Frisco',        'Copper Mtn',        'Vail'        ]
  Data.DestinationsMile =     {"Denver":260.79, "Idaho Springs":239.70,"Georgetown":227.90, "Silverthorne":205.50,"Frisco":200.70, "Copper Mtn":195.40, "Vail":177.00 }

  Data.DestinationsWest   =  ['Denver', 'Idaho Springs','Georgetown',   'Silverthorne','Frisco',        'Copper Mtn', 'Vail' ]
  Data.DestinationsEast   =  ['Vail', 'Copper Mtn','Frisco',        'Silverthorne','Georgetown',  'Idaho Springs', 'Denver']

  Data.scenario1 = { preset:1, dir:'East', beg:"Vail",       end:"Denver",     begCDOT:"East Vail to Vail Pass",           endCDOT:"Morrison / Heritage to C-470" }
  Data.scenario2 = { preset:2, dir:'West', beg:"Denver",     end:"Vail",       begCDOT:"US 6 to C-470",                    endCDOT:"East Vail to Vail Pass" }
  Data.scenario3 = { preset:3, dir:'East', beg:"Vail",       end:"Bakerville", begCDOT:"East Vail to Vail Pass",           endCDOT:"Loveland to Bakerville" }
  Data.scenario4 = { preset:4, dir:'West', beg:"Georgetown", end:"Frisco",     begCDOT:"Georgetown to Bakerville",         endCDOT:"Silverthorne to Frisco (Main St)" }
  Data.scenario5 = { preset:5, dir:'East', beg:"Frisco",     end:"Morrison",   begCDOT:"Frisco (Main St) to Silverthorne", endCDOT:"Lookout Mountain to Morrison / Heritage" }
  Data.scenario6 = { preset:6, dir:'East', beg:"Frisco",     end:"Bakerville", begCDOT:"Frisco (Main St) to Silverthorne", endCDOT:"Loveland to Bakerville" }



  Data.WestSegmentIds = [16,17,266,267,274,275,20,21,22,23,24,25,270,271,27,28,29,30]
  Data.EastSegmentIds = [31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45]

  Data.WestSegmentsURL = "http://104.154.46.117/api/state?segments=16,17,266,267,274,275,20,21,22,23,24,25,270,271,27,28,29,30"
  Data.EastSegmentsURL = "http://104.154.46.117/api/state?segments=31,32,33,34,272,273,36,37,39,40,41,276,277,268,269,44,45"

  Data.WestBegLatLon  = [39.713024,-105.194595]
  Data.WestEndLatLon  = [39.539680,-106.215126]

  Data.gitPush = "git push https://github.com/GoCodeColorado/Exit-Now-App"


  Data.DealSegmentIds = []

  Data.EastSegments = {
    "type":"FeatureCollection",
    "crs":{ "type":"name", "properties": { "name":"urn:ogc:def:crs:OGC:1.3:CRS84" } },
    "features":[
      { "type":"Feature", "properties":{ "name":"East Vail to Vail Pass",     "id":"31",  "dir":"East", "beg":"177.00", "end":"189.40", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Vail Pass to Copper",        "id":"32",  "dir":"East", "beg":"189.40", "end":"195.20", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Copper to Frisco",           "id":"33",  "dir":"East", "beg":"195.20", "end":"200.80", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Frisco to Silverthorne",     "id":"34",  "dir":"East", "beg":"200.80", "end":"205.55", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Silverthorne to MM211",      "id":"272", "dir":"East", "beg":"205.55", "end":"211.00", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"MM211 to Tunnel West",       "id":"273", "dir":"East", "beg":"211.00", "end":"213.60", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Tunnel West to Loveland",    "id":"36",  "dir":"East", "beg":"213.60", "end":"216.30", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Loveland to Bakerville",     "id":"37",  "dir":"East", "beg":"216.30", "end":"221.20", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Bakerville to Georgetown",   "id":"38",  "dir":"East", "beg":"221.20", "end":"227.90", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Georgetown to US40",         "id":"39",  "dir":"East", "beg":"227.90", "end":"232.30", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"US40 to Idaho Springs",      "id":"40",  "dir":"East", "beg":"232.30", "end":"239.69", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Idaho Springs to US6",       "id":"41",  "dir":"East", "beg":"239.69", "end":"244.20", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"US6 to Beaver Brook",        "id":"276", "dir":"East", "beg":"244.20", "end":"247.60", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Beaver Brook to Evergreen",  "id":"277", "dir":"East", "beg":"247.60", "end":"251.40", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Evergreen to Lookout",       "id":"268", "dir":"East", "beg":"251.40", "end":"256.00", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Lookout to Morrison",        "id":"269", "dir":"East", "beg":"256.00", "end":"258.70", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Morrison to C-470",          "id":"44",  "dir":"East", "beg":"258.70", "end":"259.80", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"C-470 to US 6",              "id":"45",  "dir":"East", "beg":"259.80", "end":"261.00", "time":"12",  "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } }
    ]
  }

  Data.WestSegments = {
    "type":"FeatureCollection",
    "crs":{ "type":"name", "properties": { "name":"urn:ogc:def:crs:OGC:1.3:CRS84" } },
    "features":[
      { "type":"Feature", "properties":{ "name":"US 6 to C-470",              "id":"16",  "dir":"West", "beg":"260.79", "end":"259.85", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"C470 to Morrison",           "id":"17",  "dir":"West", "beg":"259.85", "end":"258.70", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Morrison to Lookout",        "id":"266", "dir":"West", "beg":"258.70", "end":"256.00", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Lookout to Evergreen",       "id":"267", "dir":"West", "beg":"256.00", "end":"251.50", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Evergreen to Beaver Brook",  "id":"274", "dir":"West", "beg":"251.50", "end":"247.60", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Beaver Brook to US6",        "id":"275", "dir":"West", "beg":"247.60", "end":"244.40", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"US6 to Idaho Springs",       "id":"20",  "dir":"West", "beg":"244.4",  "end":"239.70", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Idaho Springs to US40",      "id":"21",  "dir":"West", "beg":"239.70", "end":"232.70", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"US40 to Georgetown",         "id":"22",  "dir":"West", "beg":"232.70", "end":"227.90", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Georgetown to Bakerville",   "id":"23",  "dir":"West", "beg":"227.90", "end":"221.30", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Bakerville to Loveland",     "id":"24",  "dir":"West", "beg":"221.30", "end":"216.30", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Loveland to Tunnel West",    "id":"25",  "dir":"West", "beg":"216.30", "end":"213.60", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Tunnel West to MN211",       "id":"270", "dir":"West", "beg":"213.60", "end":"211.00", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"MM211 to Silverthorne",      "id":"271", "dir":"West", "beg":"211.00", "end":"205.50", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Silverthorne to Frisco",     "id":"27",  "dir":"West", "beg":"205.00", "end":"200.70", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Frisco to Copper",           "id":"28",  "dir":"West", "beg":"200.70", "end":"195.40", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Copper to Vail Pass",        "id":"29",  "dir":"West", "beg":"195.40", "end":"189.40", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } },
      { "type":"Feature", "properties":{ "name":"Vail Pass to East Vail",     "id":"30",  "dir":"West", "beg":"189.40", "end":"177.00", "time":"12", "speed":"60" }, "geometry":{ "type":"LineString", "coordinates":[] } }
    ]
  }

  Data.Exits = {
    "type":"FeatureCollection",
    "crs":{ "type":"name", "properties": { "name":"urn:ogc:def:crs:OGC:1.3:CRS84" } },
    "features":[
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Avon",                 "Dir":"Both", "Class":"Exit", "Milepost":167, "ExitNum":"167" }, "geometry":{ "type":"Point", "coordinates":[ -106.567579,39.642711 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Midturn",              "Dir":"Both", "Class":"Exit", "Milepost":171, "ExitNum":"171" }, "geometry":{ "type":"Point", "coordinates":[ -106.450713,39.608377 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Vail-West",            "Dir":"Both", "Class":"Exit", "Milepost":173, "ExitNum":"173" }, "geometry":{ "type":"Point", "coordinates":[ -106.424723,39.623960 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Vail-Mid",             "Dir":"Both", "Class":"Exit", "Milepost":176, "ExitNum":"176" }, "geometry":{ "type":"Point", "coordinates":[ -106.378767,39.644407 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Vail-East",            "Dir":"Both", "Class":"Exit", "Milepost":180, "ExitNum":"180" }, "geometry":{ "type":"Point", "coordinates":[ -106.305389,39.643470 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Vail-Pass",            "Dir":"Both", "Class":"Exit", "Milepost":190, "ExitNum":"190" }, "geometry":{ "type":"Point", "coordinates":[ -106.216071,39.531042 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Copper",               "Dir":"Both", "Class":"Exit", "Milepost":195, "ExitNum":"195" }, "geometry":{ "type":"Point", "coordinates":[ -106.147382,39.503512 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Officers-Gulch",       "Dir":"Both", "Class":"Exit", "Milepost":198, "ExitNum":"198" }, "geometry":{ "type":"Point", "coordinates":[ -106.143089,39.537548 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Frisco",               "Dir":"Both", "Class":"Exit", "Milepost":201, "ExitNum":"201" }, "geometry":{ "type":"Point", "coordinates":[ -106.111970,39.577934 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Silverthorne",         "Dir":"Both", "Class":"Exit", "Milepost":205, "ExitNum":"205" }, "geometry":{ "type":"Point", "coordinates":[ -106.072685,39.624160 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Loveland",             "Dir":"Both", "Class":"Exit", "Milepost":216, "ExitNum":"216" }, "geometry":{ "type":"Point", "coordinates":[ -105.891111,39.681757 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Herman-Gulch",         "Dir":"Both", "Class":"Exit", "Milepost":218, "ExitNum":"218" }, "geometry":{ "type":"Point", "coordinates":[ -105.863727,39.701232 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Silverplume",          "Dir":"Both", "Class":"Exit", "Milepost":226, "ExitNum":"226" }, "geometry":{ "type":"Point", "coordinates":[ -105.720368,39.697607 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Georgetown",           "Dir":"Both", "Class":"Exit", "Milepost":228, "ExitNum":"228" }, "geometry":{ "type":"Point", "coordinates":[ -105.696435,39.716707 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Hwy40",                "Dir":"Both", "Class":"Exit", "Milepost":232, "ExitNum":"232" }, "geometry":{ "type":"Point", "coordinates":[ -105.654065,39.759558 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Lawson",               "Dir":"Both", "Class":"Exit", "Milepost":233, "ExitNum":"233" }, "geometry":{ "type":"Point", "coordinates":[ -105.636026,39.763824 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Dumont",               "Dir":"Both", "Class":"Exit", "Milepost":234, "ExitNum":"234" }, "geometry":{ "type":"Point", "coordinates":[ -105.617902,39.766115 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Fall-River",           "Dir":"Both", "Class":"Exit", "Milepost":238, "ExitNum":"238" }, "geometry":{ "type":"Point", "coordinates":[ -105.548821,39.749691 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Idaho-Springs-West",   "Dir":"Both", "Class":"Exit", "Milepost":239, "ExitNum":"239" }, "geometry":{ "type":"Point", "coordinates":[ -105.532258,39.743542 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Idaho-Springs-Hwy103", "Dir":"Both", "Class":"Exit", "Milepost":240, "ExitNum":"240" }, "geometry":{ "type":"Point", "coordinates":[ -105.513981,39.741333 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Idaho-Springs-East",   "Dir":"Both", "Class":"Exit", "Milepost":241, "ExitNum":"241" }, "geometry":{ "type":"Point", "coordinates":[ -105.496008,39.741248 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Hidden-Valley",        "Dir":"Both", "Class":"Exit", "Milepost":243, "ExitNum":"243" }, "geometry":{ "type":"Point", "coordinates":[ -105.460502,39.746313 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"US6-Canyon",           "Dir":"Both", "Class":"Exit", "Milepost":244, "ExitNum":"244" }, "geometry":{ "type":"Point", "coordinates":[ -105.443446,39.743465 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Beaver-Brook",         "Dir":"Both", "Class":"Exit", "Milepost":247, "ExitNum":"247" }, "geometry":{ "type":"Point", "coordinates":[ -105.401919,39.719308 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Evergreen-Pkwy",       "Dir":"Both", "Class":"Exit", "Milepost":251, "ExitNum":"251" }, "geometry":{ "type":"Point", "coordinates":[ -105.334724,39.701735 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Genesee",              "Dir":"Both", "Class":"Exit", "Milepost":256, "ExitNum":"256" }, "geometry":{ "type":"Point", "coordinates":[ -105.25042, 39.703874 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Lookout Mtn",          "Dir":"Both", "Class":"Exit", "Milepost":257, "ExitNum":"257" }, "geometry":{ "type":"Point", "coordinates":[ -105.234106,39.698332 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"Morrison",             "Dir":"Both", "Class":"Exit", "Milepost":259, "ExitNum":"259" }, "geometry":{ "type":"Point", "coordinates":[ -105.202145,39.701911 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"C470",                 "Dir":"Both", "Class":"Exit", "Milepost":280, "ExitNum":"260" }, "geometry":{ "type":"Point", "coordinates":[ -105.192522,39.714378 ] } },
      { "type":"Feature", "properties":{ "Route":"070A", "Name":"US6-Denver",           "Dir":"Both", "Class":"Exit", "Milepost":261, "ExitNum":"261" }, "geometry":{ "type":"Point", "coordinates":[ -105.192522,39.714378 ] } }
    ]
  }

  Data.MilePosts = {
    "type":   "FeatureCollection",
    "crs": {  "type": "name", "properties": {"name": "urn:ogc:def:crs:OGC:1.3:CRS84"} },
    "features": [
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 164 }, "geometry": { "type": "Point", "coordinates": [ -106.567579,39.642711 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 165 }, "geometry": { "type": "Point", "coordinates": [ -106.549988,39.639609 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 166 }, "geometry": { "type": "Point", "coordinates": [ -106.532359,39.64037  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 167 }, "geometry": { "type": "Point", "coordinates": [ -106.567579,39.642711 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 168 }, "geometry": { "type": "Point", "coordinates": [ -106.497416,39.629116 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 169 }, "geometry": { "type": "Point", "coordinates": [ -106.482846,39.621838 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 170 }, "geometry": { "type": "Point", "coordinates": [ -106.463183,39.617648 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 171 }, "geometry": { "type": "Point", "coordinates": [ -106.450713,39.608377 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 172 }, "geometry": { "type": "Point", "coordinates": [ -106.439274,39.615508 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 173 }, "geometry": { "type": "Point", "coordinates": [ -106.424723,39.62396  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 174 }, "geometry": { "type": "Point", "coordinates": [ -106.411475,39.634018 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 175 }, "geometry": { "type": "Point", "coordinates": [ -106.396455,39.642613 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 176 }, "geometry": { "type": "Point", "coordinates": [ -106.378767,39.644407 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 177 }, "geometry": { "type": "Point", "coordinates": [ -106.359455,39.641359 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 178 }, "geometry": { "type": "Point", "coordinates": [ -106.341754,39.644162 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 179 }, "geometry": { "type": "Point", "coordinates": [ -106.323525,39.647163 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 180 }, "geometry": { "type": "Point", "coordinates": [ -106.305389,39.64347  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 181 }, "geometry": { "type": "Point", "coordinates": [ -106.291314,39.634263 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 182 }, "geometry": { "type": "Point", "coordinates": [ -106.277793,39.624935 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 183 }, "geometry": { "type": "Point", "coordinates": [ -106.277444,39.610202 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 184 }, "geometry": { "type": "Point", "coordinates": [ -106.269479,39.59776  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 185 }, "geometry": { "type": "Point", "coordinates": [ -106.251388,39.594515 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 186 }, "geometry": { "type": "Point", "coordinates": [ -106.248208,39.581316 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 187 }, "geometry": { "type": "Point", "coordinates": [ -106.239927,39.568672 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 188 }, "geometry": { "type": "Point", "coordinates": [ -106.228965,39.557269 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 189 }, "geometry": { "type": "Point", "coordinates": [ -106.219363,39.546056 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 190 }, "geometry": { "type": "Point", "coordinates": [ -106.216071,39.531042 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 191 }, "geometry": { "type": "Point", "coordinates": [ -106.212722,39.517778 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 192 }, "geometry": { "type": "Point", "coordinates": [ -106.202343,39.50668  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 193 }, "geometry": { "type": "Point", "coordinates": [ -106.183255,39.503921 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 194 }, "geometry": { "type": "Point", "coordinates": [ -106.164831,39.50138  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 195 }, "geometry": { "type": "Point", "coordinates": [ -106.147382,39.503512 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 196 }, "geometry": { "type": "Point", "coordinates": [ -106.145771,39.516981 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 197 }, "geometry": { "type": "Point", "coordinates": [ -106.13809,39.526784  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 198 }, "geometry": { "type": "Point", "coordinates": [ -106.143089,39.537548 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 199 }, "geometry": { "type": "Point", "coordinates": [ -106.135335,39.552539 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 200 }, "geometry": { "type": "Point", "coordinates": [ -106.121317,39.567904 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 201 }, "geometry": { "type": "Point", "coordinates": [ -106.11197,39.577934  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 202 }, "geometry": { "type": "Point", "coordinates": [ -106.101598,39.589414 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 203 }, "geometry": { "type": "Point", "coordinates": [ -106.089572,39.600276 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 204 }, "geometry": { "type": "Point", "coordinates": [ -106.076818,39.611188 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 205 }, "geometry": { "type": "Point", "coordinates": [ -106.072685,39.62416  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 206 }, "geometry": { "type": "Point", "coordinates": [ -106.058072,39.632276 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 207 }, "geometry": { "type": "Point", "coordinates": [ -106.042914,39.640907 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 208 }, "geometry": { "type": "Point", "coordinates": [ -106.02553,39.646614  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 209 }, "geometry": { "type": "Point", "coordinates": [ -106.009908,39.653029 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 210 }, "geometry": { "type": "Point", "coordinates": [ -105.992954,39.65732  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 211 }, "geometry": { "type": "Point", "coordinates": [ -105.977944,39.66563  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 212 }, "geometry": { "type": "Point", "coordinates": [ -105.963321,39.673957 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 213 }, "geometry": { "type": "Point", "coordinates": [ -105.946582,39.676944 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 214 }, "geometry": { "type": "Point", "coordinates": [ -105.925585,39.678832 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 215 }, "geometry": { "type": "Point", "coordinates": [ -105.907121,39.679081 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 216 }, "geometry": { "type": "Point", "coordinates": [ -105.891111,39.681757 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 217 }, "geometry": { "type": "Point", "coordinates": [ -105.878342,39.6924   ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 218 }, "geometry": { "type": "Point", "coordinates": [ -105.863727,39.701232 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 219 }, "geometry": { "type": "Point", "coordinates": [ -105.84537,39.702015  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 220 }, "geometry": { "type": "Point", "coordinates": [ -105.828494,39.6963   ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 221 }, "geometry": { "type": "Point", "coordinates": [ -105.810805,39.691813 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 222 }, "geometry": { "type": "Point", "coordinates": [ -105.792841,39.695793 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 223 }, "geometry": { "type": "Point", "coordinates": [ -105.774475,39.694949 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 224 }, "geometry": { "type": "Point", "coordinates": [ -105.756202,39.696455 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 225 }, "geometry": { "type": "Point", "coordinates": [ -105.739132,39.695662 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 226 }, "geometry": { "type": "Point", "coordinates": [ -105.720368,39.697607 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 227 }, "geometry": { "type": "Point", "coordinates": [ -105.704225,39.704079 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 228 }, "geometry": { "type": "Point", "coordinates": [ -105.696435,39.716707 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 229 }, "geometry": { "type": "Point", "coordinates": [ -105.69252,39.730684  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 230 }, "geometry": { "type": "Point", "coordinates": [ -105.683122,39.742915 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 231 }, "geometry": { "type": "Point", "coordinates": [ -105.667138,39.749973 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 232 }, "geometry": { "type": "Point", "coordinates": [ -105.654065,39.759558 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 233 }, "geometry": { "type": "Point", "coordinates": [ -105.636026,39.763824 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 234 }, "geometry": { "type": "Point", "coordinates": [ -105.617902,39.766115 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 235 }, "geometry": { "type": "Point", "coordinates": [ -105.599202,39.764038 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 236 }, "geometry": { "type": "Point", "coordinates": [ -105.580687,39.763358 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 237 }, "geometry": { "type": "Point", "coordinates": [ -105.564378,39.756437 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 238 }, "geometry": { "type": "Point", "coordinates": [ -105.548821,39.749691 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 239 }, "geometry": { "type": "Point", "coordinates": [ -105.532258,39.743542 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 240 }, "geometry": { "type": "Point", "coordinates": [ -105.513981,39.741333 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 241 }, "geometry": { "type": "Point", "coordinates": [ -105.496008,39.741248 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 242 }, "geometry": { "type": "Point", "coordinates": [ -105.481033,39.743907 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 243 }, "geometry": { "type": "Point", "coordinates": [ -105.460502,39.746313 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 244 }, "geometry": { "type": "Point", "coordinates": [ -105.443446,39.743465 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 245 }, "geometry": { "type": "Point", "coordinates": [ -105.431198,39.73769  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 246 }, "geometry": { "type": "Point", "coordinates": [ -105.42065,39.725697  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 247 }, "geometry": { "type": "Point", "coordinates": [ -105.401919,39.719308 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 248 }, "geometry": { "type": "Point", "coordinates": [ -105.383566,39.715552 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 249 }, "geometry": { "type": "Point", "coordinates": [ -105.367838,39.71348  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 250 }, "geometry": { "type": "Point", "coordinates": [ -105.349986,39.710199 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 251 }, "geometry": { "type": "Point", "coordinates": [ -105.334724,39.701735 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 252 }, "geometry": { "type": "Point", "coordinates": [ -105.319835,39.708876 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 253 }, "geometry": { "type": "Point", "coordinates": [ -105.304159,39.712624 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 254 }, "geometry": { "type": "Point", "coordinates": [ -105.286271,39.709166 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 255 }, "geometry": { "type": "Point", "coordinates": [ -105.268829,39.704885 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 256 }, "geometry": { "type": "Point", "coordinates": [ -105.25042,39.703874  ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 257 }, "geometry": { "type": "Point", "coordinates": [ -105.234106,39.698332 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 258 }, "geometry": { "type": "Point", "coordinates": [ -105.216032,39.696098 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 259 }, "geometry": { "type": "Point", "coordinates": [ -105.202145,39.701911 ] } },
      { "type": "Feature", "properties": { "Route": "070A", "Milepost": 260 }, "geometry": { "type": "Point", "coordinates": [ -105.192522,39.714378 ] } }
    ]
  }
  
export default Data