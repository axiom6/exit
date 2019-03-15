
import Util  from '../util/Util.js'

class Geo

  constructor:() ->
    Util.noop( @boundingBoxAroundPolyCoords, @pnpoly, @lineStringsIntersect, @pointInPolygon )
    Util.noop( @pointInMultiPolygon, @drawCircle, @rectangleCentroid, @geometryWithinRadius )
    Util.noop( @centroid, @simplify, @destinationPoint, Geo )

  boundingBoxAroundPolyCoords:(coords) ->
    xAll = []
    yAll = []
    i = 0
    while i < coords[0].length
      xAll.push coords[0][i][1]
      yAll.push coords[0][i][0]
      i++
    xAll = xAll.sort((a, b) ->
      a - b
    )
    yAll = yAll.sort((a, b) ->
      a - b
    )
    [
      [
        xAll[0]
        yAll[0]
      ]
      [
        xAll[xAll.length - 1]
        yAll[yAll.length - 1]
      ]
    ]

  # Point in Polygon
  # http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html#Listing the Vertices

  pnpoly:(x, y, coords) ->
    i = 0
    j = 0
    vert = [ [
      0
      0
    ] ]
    i = 0
    while i < coords.length
      j = 0
      while j < coords[i].length
        vert.push coords[i][j]
        j++
      vert.push coords[i][0]
      vert.push [
        0
        0
      ]
      i++
    inside = false
    i = 0
    j = vert.length - 1
    while i < vert.length
      if vert[i][0] > y != vert[j][0] > y and x < (vert[j][1] - vert[i][1]) * (y - vert[i][0]) / (vert[j][0] - vert[i][0]) + vert[i][1]
        inside = !inside
      j = i++
    inside

  # if typeof module != 'undefined' and module.exports
  #  module.exports = gju
  # adapted from http://www.kevlindev.com/gui/math/intersection/Intersection.js

  lineStringsIntersect:(l1, l2) ->
    intersects = []
    i = 0
    while i <= l1.coordinates.length - 2
      j = 0
      while j <= l2.coordinates.length - 2
        a1 = 
          x: l1.coordinates[i][1]
          y: l1.coordinates[i][0]
        a2 = 
          x: l1.coordinates[i + 1][1]
          y: l1.coordinates[i + 1][0]
        b1 = 
          x: l2.coordinates[j][1]
          y: l2.coordinates[j][0]
        b2 = 
          x: l2.coordinates[j + 1][1]
          y: l2.coordinates[j + 1][0]
        ua_t = (b2.x - b1.x) * (a1.y - b1.y) - (b2.y - b1.y) * (a1.x - b1.x)
        ub_t = (a2.x - a1.x) * (a1.y - b1.y) - (a2.y - a1.y) * (a1.x - b1.x)
        u_b = (b2.y - b1.y) * (a2.x - a1.x) - (b2.x - b1.x) * (a2.y - a1.y)
        if u_b != 0
          ua = ua_t / u_b
          ub = ub_t / u_b
          if 0 <= ua and ua <= 1 and 0 <= ub and ub <= 1
            intersects.push
              'type': 'Point'
              'coordinates': [
                a1.x + ua * (a2.x - a1.x)
                a1.y + ua * (a2.y - a1.y)
              ]
        ++j
      ++i
    if intersects.length == 0
      intersects = false
    intersects

  pointInBoundingBox:(point, bounds) ->
    !(point.coordinates[1] < bounds[0][0] or point.coordinates[1] > bounds[1][0] or point.coordinates[0] < bounds[0][1] or point.coordinates[0] > bounds[1][1])

  pointInPolygon:(p, poly) ->
    coords = if poly.type == 'Polygon' then [ poly.coordinates ] else poly.coordinates
    insideBox = false
    i = 0
    while i < coords.length
      if @pointInBoundingBox(p, boundingBoxAroundPolyCoords(coords[i]))
        insideBox = true
      i++
    if !insideBox
      return false
    insidePoly = false
    i = 0
    while i < coords.length
      if pnpoly(p.coordinates[1], p.coordinates[0], coords[i])
        insidePoly = true
      i++
    insidePoly

  # support multi (but not donut) polygons

  pointInMultiPolygon:(p, poly) ->
    j = 0
    coords_array = if poly.type == 'MultiPolygon' then [ poly.coordinates ] else poly.coordinates
    insideBox = false
    insidePoly = false
    i = 0
    while i < coords_array.length
      coords = coords_array[i]
      j = 0
      while j < coords.length
        if !insideBox
          if @pointInBoundingBox(p, boundingBoxAroundPolyCoords(coords[j]))
            insideBox = true
        j++
      if !insideBox
        return false
      j = 0
      while j < coords.length
        if !insidePoly
          if pnpoly(p.coordinates[1], p.coordinates[0], coords[j])
            insidePoly = true
        j++
      i++
    insidePoly

  numberToRadius:(number) ->
    number * Math.PI / 180

  numberToDegree:(number) ->
    number * 180 / Math.PI

  # written with help from @tautologe

  drawCircle:(radiusInMeters, centerPoint, steps) ->
    center = [
      centerPoint.coordinates[1]
      centerPoint.coordinates[0]
    ]
    dist = radiusInMeters / 1000 / 6371
    radCenter = [@numberToRadius(center[0]),@numberToRadius(center[1])]
    steps = steps or 15
    poly = [ [ center[0], center[1] ] ]
    while i < steps
      brng = 2 * Math.PI * i / steps
      lat = Math.asin(Math.sin(radCenter[0]) * Math.cos(dist) + Math.cos(radCenter[0]) * Math.sin(dist) * Math.cos(brng))
      lng = radCenter[1] + Math.atan2(Math.sin(brng) * Math.sin(dist) * Math.cos(radCenter[0]), Math.cos(dist) - Math.sin(radCenter[0]) * Math.sin(lat))
      poly[i] = []
      poly[i][1] = @numberToDegree(lat)
      poly[i][0] = @numberToDegree(lng)
      i++
    {
      'type': 'Polygon'
      'coordinates': [ poly ]
    }

  # assumes rectangle starts at lower left point

  rectangleCentroid:(rectangle) ->
    bbox = rectangle.coordinates[0]
    xmin = bbox[0][0]
    ymin = bbox[0][1]
    xmax = bbox[2][0]
    ymax = bbox[2][1]
    xwidth = xmax - xmin
    ywidth = ymax - ymin
    {
      'type': 'Point'
      'coordinates': [
        xmin + xwidth / 2
        ymin + ywidth / 2
      ]
    }

  # from http://www.movable-type.co.uk/scripts/latlong.html

  pointDistance:(pt1, pt2) ->
    lon1 = pt1.coordinates[0]
    lat1 = pt1.coordinates[1]
    lon2 = pt2.coordinates[0]
    lat2 = pt2.coordinates[1]
    dLat = @numberToRadius(lat2 - lat1)
    dLon = @numberToRadius(lon2 - lon1)
    a    = Math.sin(dLat/2) ** 2 + Math.cos(@numberToRadius(lat1)) * Math.cos(@numberToRadius(lat2)) * Math.sin(dLon / 2) ** 2
    c    = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    6371 * c * 1000 # returns meters


  geometryWithinRadius:(geometry, center, radius) ->
    if geometry.type == 'Point'
      return @pointDistance(geometry, center) <= radius
    else if geometry.type == 'LineString' or geometry.type == 'Polygon'
      point = {}
      coordinates = undefined
      if geometry.type == 'Polygon'
        # it's enough to check the exterior ring of the Polygon
        coordinates = geometry.coordinates[0]
      else
        coordinates = geometry.coordinates
      for i of coordinates
        point.coordinates = coordinates[i]
        if @pointDistance(point, center) > radius
          return false
      true

  # adapted from http://paulbourke.net/geometry/polyarea/javascript.txt

  area:(polygon) ->
    p1 = undefined
    p2 = undefined
    area = 0
    # To Do: polygon holes at coordinates[1]
    points = polygon.coordinates[0]
    j = points.length - 1
    i = 0
    while i < points.length
      p1 = 
        x: points[i][1]
        y: points[i][0]
      p2 = 
        x: points[j][1]
        y: points[j][0]
      area += p1.x * p2.y
      area -= p1.y * p2.x
      j = i++
    area /= 2
    area

  centroid:(polygon) ->
      p1 = undefined
      p2 = undefined
      f = undefined
      x = 0
      y = 0
      # To Do: polygon holes at coordinates[1]
      points = polygon.coordinates[0]
      j = points.length - 1

      i = 0
      while i < points.length
        p1 =
          x: points[i][1]
          y: points[i][0]
        p2 =
          x: points[j][1]
          y: points[j][0]
        f = p1.x * p2.y - p2.x * p1.y
        x += (p1.x + p2.x) * f
        y += (p1.y + p2.y) * f
        j = i++
      f = @area(polygon) * 6
      {
        'type': 'Point'
        'coordinates': [
          y / f
          x / f
        ]
      }

  simplify:(source, kink) ->

    ### source[] array of geojson points ###

    ### kink	in metres, kinks above this depth kept  ###

    ### kink depth is the height of the triangle abc where a-b and b-c are two consecutive line segments ###

    kink = kink or 20
    source = source.map( (o) ->
      { lng: o.coordinates[0], lat: o.coordinates[1] } )
    n_source = undefined
    n_stack = undefined
    n_dest = undefined
    start = undefined
    end = undefined
    i = undefined
    sig = undefined
    dev_sqr = undefined
    max_dev_sqr = undefined
    band_sqr = undefined
    x12 = undefined
    y12 = undefined
    d12 = undefined
    x13 = undefined
    y13 = undefined
    d13 = undefined
    x23 = undefined
    y23 = undefined
    d23 = undefined
    F = Math.PI / 180.0 * 0.5
    index = new Array

    ### aray of indexes of source points to include in the reduced line ###

    sig_start = new Array

    ### indices of start & end of working section ###

    sig_end = new Array

    ### check for simple cases ###

    if source.length < 3
      return source

    ### one or two points ###

    ### more complex case. initialize stack ###

    n_source = source.length
    band_sqr = kink * 360.0 / (2.0 * Math.PI * 6378137.0)

    ### Now in degrees ###

    band_sqr *= band_sqr
    n_dest = 0
    sig_start[0] = 0
    sig_end[0] = n_source - 1
    n_stack = 1

    ### while the stack is not empty  ... ###

    while n_stack > 0

      ### ... pop the top-most entries off the stacks ###

      start = sig_start[n_stack - 1]
      end = sig_end[n_stack - 1]
      n_stack--
      if end - start > 1

        ### any intermediate points ? ###

        ### ... yes, so find most deviant intermediate point to
        either side of line joining start & end points
        ###

        x12 = source[end].lng() - source[start].lng()
        y12 = source[end].lat() - source[start].lat()
        if Math.abs(x12) > 180.0
          x12 = 360.0 - Math.abs(x12)
        x12 *= Math.cos(F * (source[end].lat() + source[start].lat()))

        ### use avg lat to reduce lng ###

        d12 = x12 * x12 + y12 * y12
        i = start + 1
        sig = start
        max_dev_sqr = -1.0
        while i < end
          x13 = source[i].lng() - source[start].lng()
          y13 = source[i].lat() - source[start].lat()
          if Math.abs(x13) > 180.0
            x13 = 360.0 - Math.abs(x13)
          x13 *= Math.cos(F * (source[i].lat() + source[start].lat()))
          d13 = x13 * x13 + y13 * y13
          x23 = source[i].lng() - source[end].lng()
          y23 = source[i].lat() - source[end].lat()
          if Math.abs(x23) > 180.0
            x23 = 360.0 - Math.abs(x23)
          x23 *= Math.cos(F * (source[i].lat() + source[end].lat()))
          d23 = x23 * x23 + y23 * y23
          if d13 >= d12 + d23
            dev_sqr = d23
          else if d23 >= d12 + d13
            dev_sqr = d13
          else
            dev_sqr = (x13 * y12 - y13 * x12) * (x13 * y12 - y13 * x12) / d12
          # solve triangle
          if dev_sqr > max_dev_sqr
            sig = i
            max_dev_sqr = dev_sqr
          i++
        if max_dev_sqr < band_sqr

          ### is there a sig. intermediate point ? ###

          ### ... no, so transfer current start point ###

          index[n_dest] = start
          n_dest++
        else

          ### ... yes, so push two sub-sections on stack for further processing ###

          n_stack++
          sig_start[n_stack - 1] = sig
          sig_end[n_stack - 1] = end
          n_stack++
          sig_start[n_stack - 1] = start
          sig_end[n_stack - 1] = sig
      else

        ### ... no intermediate points, so transfer current start point ###

        index[n_dest] = start
        n_dest++

    ### transfer last point ###

    index[n_dest] = n_source - 1
    n_dest++

    ### make return array ###

    r = new Array
    i = 0
    while i < n_dest
      r.push( source[index[i]] )
      i++

    r.map( (o) ->
      { type:'Point', coordinates:[ o.lng, o.lat ] } )

  # http://www.movable-type.co.uk/scripts/latlong.html#destPoint

  destinationPoint:(pt, brng, dist) ->
    dist = dist / 6371
    # convert dist to angular distance in radians
    brng = @numberToRadius(brng)
    lon1 = @numberToRadius(pt.coordinates[0])
    lat1 = @numberToRadius(pt.coordinates[1])
    lat2 = Math.asin(Math.sin(lat1) * Math.cos(dist) + Math.cos(lat1) * Math.sin(dist) * Math.cos(brng))
    lon2 = lon1 + Math.atan2(Math.sin(brng) * Math.sin(dist) * Math.cos(lat1), Math.cos(dist) - Math.sin(lat1) * Math.sin(lat2))
    lon2 = (lon2 + 3 * Math.PI) % 2 * Math.PI - Math.PI
    # normalise to -180..+180º
    {
      'type': 'Point'
      'coordinates': [
        @numberToDegree(lon2)
        @numberToDegree(lat2)
      ]
    }

`export default Geo`