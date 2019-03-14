(function() {
  var GeoJsonUtils;

  GeoJsonUtils = class GeoJsonUtils {
    constructor() {}

    boundingBoxAroundPolyCoords(coords) {
      var i, xAll, yAll;
      xAll = [];
      yAll = [];
      i = 0;
      while (i < coords[0].length) {
        xAll.push(coords[0][i][1]);
        yAll.push(coords[0][i][0]);
        i++;
      }
      xAll = xAll.sort(function(a, b) {
        return a - b;
      });
      yAll = yAll.sort(function(a, b) {
        return a - b;
      });
      return [[xAll[0], yAll[0]], [xAll[xAll.length - 1], yAll[yAll.length - 1]]];
    }

    // Point in Polygon
    // http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html#Listing the Vertices
    pnpoly(x, y, coords) {
      var i, inside, j, ref, vert;
      i = 0;
      j = 0;
      vert = [[0, 0]];
      i = 0;
      while (i < coords.length) {
        j = 0;
        while (j < coords[i].length) {
          vert.push(coords[i][j]);
          j++;
        }
        vert.push(coords[i][0]);
        vert.push([0, 0]);
        i++;
      }
      inside = false;
      i = 0;
      j = vert.length - 1;
      while (i < vert.length) {
        if (((vert[i][0] > y && y !== (ref = vert[j][0])) && ref > y) && x < (vert[j][1] - vert[i][1]) * (y - vert[i][0]) / (vert[j][0] - vert[i][0]) + vert[i][1]) {
          inside = !inside;
        }
        j = i++;
      }
      return inside;
    }

    // if typeof module != 'undefined' and module.exports
    //  module.exports = gju
    // adapted from http://www.kevlindev.com/gui/math/intersection/Intersection.js
    lineStringsIntersect(l1, l2) {
      var a1, a2, b1, b2, i, intersects, j, u_b, ua, ua_t, ub, ub_t;
      intersects = [];
      i = 0;
      while (i <= l1.coordinates.length - 2) {
        j = 0;
        while (j <= l2.coordinates.length - 2) {
          a1 = {
            x: l1.coordinates[i][1],
            y: l1.coordinates[i][0]
          };
          a2 = {
            x: l1.coordinates[i + 1][1],
            y: l1.coordinates[i + 1][0]
          };
          b1 = {
            x: l2.coordinates[j][1],
            y: l2.coordinates[j][0]
          };
          b2 = {
            x: l2.coordinates[j + 1][1],
            y: l2.coordinates[j + 1][0]
          };
          ua_t = (b2.x - b1.x) * (a1.y - b1.y) - (b2.y - b1.y) * (a1.x - b1.x);
          ub_t = (a2.x - a1.x) * (a1.y - b1.y) - (a2.y - a1.y) * (a1.x - b1.x);
          u_b = (b2.y - b1.y) * (a2.x - a1.x) - (b2.x - b1.x) * (a2.y - a1.y);
          if (u_b !== 0) {
            ua = ua_t / u_b;
            ub = ub_t / u_b;
            if (0 <= ua && ua <= 1 && 0 <= ub && ub <= 1) {
              intersects.push({
                'type': 'Point',
                'coordinates': [a1.x + ua * (a2.x - a1.x), a1.y + ua * (a2.y - a1.y)]
              });
            }
          }
          ++j;
        }
        ++i;
      }
      if (intersects.length === 0) {
        intersects = false;
      }
      return intersects;
    }

    pointInBoundingBox(point, bounds) {
      return !(point.coordinates[1] < bounds[0][0] || point.coordinates[1] > bounds[1][0] || point.coordinates[0] < bounds[0][1] || point.coordinates[0] > bounds[1][1]);
    }

    pointInPolygon(p, poly) {
      var coords, i, insideBox, insidePoly;
      coords = poly.type === 'Polygon' ? [poly.coordinates] : poly.coordinates;
      insideBox = false;
      i = 0;
      while (i < coords.length) {
        if (this.pointInBoundingBox(p, boundingBoxAroundPolyCoords(coords[i]))) {
          insideBox = true;
        }
        i++;
      }
      if (!insideBox) {
        return false;
      }
      insidePoly = false;
      i = 0;
      while (i < coords.length) {
        if (pnpoly(p.coordinates[1], p.coordinates[0], coords[i])) {
          insidePoly = true;
        }
        i++;
      }
      return insidePoly;
    }

    // support multi (but not donut) polygons
    pointInMultiPolygon(p, poly) {
      var coords, coords_array, i, insideBox, insidePoly, j;
      j = 0;
      coords_array = poly.type === 'MultiPolygon' ? [poly.coordinates] : poly.coordinates;
      insideBox = false;
      insidePoly = false;
      i = 0;
      while (i < coords_array.length) {
        coords = coords_array[i];
        j = 0;
        while (j < coords.length) {
          if (!insideBox) {
            if (this.pointInBoundingBox(p, boundingBoxAroundPolyCoords(coords[j]))) {
              insideBox = true;
            }
          }
          j++;
        }
        if (!insideBox) {
          return false;
        }
        j = 0;
        while (j < coords.length) {
          if (!insidePoly) {
            if (pnpoly(p.coordinates[1], p.coordinates[0], coords[j])) {
              insidePoly = true;
            }
          }
          j++;
        }
        i++;
      }
      return insidePoly;
    }

    numberToRadius(number) {
      return number * Math.PI / 180;
    }

    numberToDegree(number) {
      return number * 180 / Math.PI;
    }

    // written with help from @tautologe
    drawCircle(radiusInMeters, centerPoint, steps) {
      var brng, center, dist, lat, lng, poly, radCenter;
      center = [centerPoint.coordinates[1], centerPoint.coordinates[0]];
      dist = radiusInMeters / 1000 / 6371;
      radCenter = [this.numberToRadius(center[0]), this.numberToRadius(center[1])];
      steps = steps || 15;
      poly = [[center[0], center[1]]];
      while (i < steps) {
        brng = 2 * Math.PI * i / steps;
        lat = Math.asin(Math.sin(radCenter[0]) * Math.cos(dist) + Math.cos(radCenter[0]) * Math.sin(dist) * Math.cos(brng));
        lng = radCenter[1] + Math.atan2(Math.sin(brng) * Math.sin(dist) * Math.cos(radCenter[0]), Math.cos(dist) - Math.sin(radCenter[0]) * Math.sin(lat));
        poly[i] = [];
        poly[i][1] = this.numberToDegree(lat);
        poly[i][0] = this.numberToDegree(lng);
        i++;
      }
      return {
        'type': 'Polygon',
        'coordinates': [poly]
      };
    }

    // assumes rectangle starts at lower left point
    rectangleCentroid(rectangle) {
      var bbox, xmax, xmin, xwidth, ymax, ymin, ywidth;
      bbox = rectangle.coordinates[0];
      xmin = bbox[0][0];
      ymin = bbox[0][1];
      xmax = bbox[2][0];
      ymax = bbox[2][1];
      xwidth = xmax - xmin;
      ywidth = ymax - ymin;
      return {
        'type': 'Point',
        'coordinates': [xmin + xwidth / 2, ymin + ywidth / 2]
      };
    }

    // from http://www.movable-type.co.uk/scripts/latlong.html
    pointDistance(pt1, pt2) {
      var a, c, dLat, dLon, lat1, lat2, lon1, lon2;
      lon1 = pt1.coordinates[0];
      lat1 = pt1.coordinates[1];
      lon2 = pt2.coordinates[0];
      lat2 = pt2.coordinates[1];
      dLat = this.numberToRadius(lat2 - lat1);
      dLon = this.numberToRadius(lon2 - lon1);
      a = Math.sin(dLat / 2) ** 2 + Math.cos(this.numberToRadius(lat1)) * Math.cos(this.numberToRadius(lat2)) * Math.sin(dLon / 2) ** 2;
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return 6371 * c * 1000;
    }

    // returns meters
    geometryWithinRadius(geometry, center, radius) {
      var coordinates, i, point;
      if (geometry.type === 'Point') {
        return this.pointDistance(geometry, center) <= radius;
      } else if (geometry.type === 'LineString' || geometry.type === 'Polygon') {
        point = {};
        coordinates = void 0;
        if (geometry.type === 'Polygon') {
          // it's enough to check the exterior ring of the Polygon
          coordinates = geometry.coordinates[0];
        } else {
          coordinates = geometry.coordinates;
        }
        for (i in coordinates) {
          point.coordinates = coordinates[i];
          if (this.pointDistance(point, center) > radius) {
            return false;
          }
        }
        return true;
      }
    }

    // adapted from http://paulbourke.net/geometry/polyarea/javascript.txt
    area(polygon) {
      var area, i, j, p1, p2, points;
      p1 = void 0;
      p2 = void 0;
      area = 0;
      // To Do: polygon holes at coordinates[1]
      points = polygon.coordinates[0];
      j = points.length - 1;
      i = 0;
      while (i < points.length) {
        p1 = {
          x: points[i][1],
          y: points[i][0]
        };
        p2 = {
          x: points[j][1],
          y: points[j][0]
        };
        area += p1.x * p2.y;
        area -= p1.y * p2.x;
        j = i++;
      }
      area /= 2;
      return area;
    }

    centroid(polygon) {
      var f, i, j, p1, p2, points, x, y;
      p1 = void 0;
      p2 = void 0;
      f = void 0;
      x = 0;
      y = 0;
      // To Do: polygon holes at coordinates[1]
      points = polygon.coordinates[0];
      j = points.length - 1;
      i = 0;
      while (i < points.length) {
        p1 = {
          x: points[i][1],
          y: points[i][0]
        };
        p2 = {
          x: points[j][1],
          y: points[j][0]
        };
        f = p1.x * p2.y - p2.x * p1.y;
        x += (p1.x + p2.x) * f;
        y += (p1.y + p2.y) * f;
        j = i++;
      }
      f = area(polygon) * 6;
      return {
        'type': 'Point',
        'coordinates': [y / f, x / f]
      };
    }

    simplify(source, kink) {
      /* use avg lat to reduce lng */
      /* one or two points */
      /* more complex case. initialize stack */
      /* make return array */
      /* indices of start & end of working section */
      /* aray of indexes of source points to include in the reduced line */
      /* ... pop the top-most entries off the stacks */
      /* any intermediate points ? */
      /* ... yes, so find most deviant intermediate point to
      either side of line joining start & end points
      */
      var F, band_sqr, d12, d13, d23, dev_sqr, end, i, index, max_dev_sqr, n_dest, n_source, n_stack, r, sig, sig_end, sig_start, start, x12, x13, x23, y12, y13, y23;
      kink = kink || 20;
      source = source.map(function(o) {
        return {
          lng: o.coordinates[0],
          lat: o.coordinates[1]
        };
      });
      n_source = void 0;
      n_stack = void 0;
      n_dest = void 0;
      start = void 0;
      end = void 0;
      i = void 0;
      sig = void 0;
      dev_sqr = void 0;
      max_dev_sqr = void 0;
      band_sqr = void 0;
      x12 = void 0;
      y12 = void 0;
      d12 = void 0;
      x13 = void 0;
      y13 = void 0;
      d13 = void 0;
      x23 = void 0;
      y23 = void 0;
      d23 = void 0;
      F = Math.PI / 180.0 * 0.5;
      index = new Array;
      sig_start = new Array;
      sig_end = new Array;
      /* check for simple cases */
      if (source.length < 3) {
        return source;
      }
      n_source = source.length;
      band_sqr = kink * 360.0 / (2.0 * Math.PI * 6378137.0);
      /* Now in degrees */
      band_sqr *= band_sqr;
      n_dest = 0;
      sig_start[0] = 0;
      sig_end[0] = n_source - 1;
      n_stack = 1;
      /* while the stack is not empty  ... */
      while (n_stack > 0) {
        start = sig_start[n_stack - 1];
        end = sig_end[n_stack - 1];
        n_stack--;
        if (end - start > 1) {
          x12 = source[end].lng() - source[start].lng();
          y12 = source[end].lat() - source[start].lat();
          if (Math.abs(x12) > 180.0) {
            x12 = 360.0 - Math.abs(x12);
          }
          x12 *= Math.cos(F * (source[end].lat() + source[start].lat()));
          d12 = x12 * x12 + y12 * y12;
          i = start + 1;
          sig = start;
          max_dev_sqr = -1.0;
          while (i < end) {
            x13 = source[i].lng() - source[start].lng();
            y13 = source[i].lat() - source[start].lat();
            if (Math.abs(x13) > 180.0) {
              x13 = 360.0 - Math.abs(x13);
            }
            x13 *= Math.cos(F * (source[i].lat() + source[start].lat()));
            d13 = x13 * x13 + y13 * y13;
            x23 = source[i].lng() - source[end].lng();
            y23 = source[i].lat() - source[end].lat();
            if (Math.abs(x23) > 180.0) {
              x23 = 360.0 - Math.abs(x23);
            }
            x23 *= Math.cos(F * (source[i].lat() + source[end].lat()));
            d23 = x23 * x23 + y23 * y23;
            if (d13 >= d12 + d23) {
              dev_sqr = d23;
            } else if (d23 >= d12 + d13) {
              dev_sqr = d13;
            } else {
              dev_sqr = (x13 * y12 - y13 * x12) * (x13 * y12 - y13 * x12) / d12;
            }
            // solve triangle
            if (dev_sqr > max_dev_sqr) {
              sig = i;
              max_dev_sqr = dev_sqr;
            }
            i++;
          }
          if (max_dev_sqr < band_sqr) {
            /* is there a sig. intermediate point ? */
            /* ... no, so transfer current start point */
            index[n_dest] = start;
            n_dest++;
          } else {
            /* ... yes, so push two sub-sections on stack for further processing */
            n_stack++;
            sig_start[n_stack - 1] = sig;
            sig_end[n_stack - 1] = end;
            n_stack++;
            sig_start[n_stack - 1] = start;
            sig_end[n_stack - 1] = sig;
          }
        } else {
          /* ... no intermediate points, so transfer current start point */
          index[n_dest] = start;
          n_dest++;
        }
      }
      /* transfer last point */
      index[n_dest] = n_source - 1;
      n_dest++;
      r = new Array;
      i = 0;
      while (i < n_dest) {
        r.push(source[index[i]]);
        i++;
      }
      return r.map(function(o) {
        return {
          type: 'Point',
          coordinates: [o.lng, o.lat]
        };
      });
    }

    // http://www.movable-type.co.uk/scripts/latlong.html#destPoint
    destinationPoint(pt, brng, dist) {
      var lat1, lat2, lon1, lon2;
      dist = dist / 6371;
      // convert dist to angular distance in radians
      brng = this.numberToRadius(brng);
      lon1 = this.numberToRadius(pt.coordinates[0]);
      lat1 = this.numberToRadius(pt.coordinates[1]);
      lat2 = Math.asin(Math.sin(lat1) * Math.cos(dist) + Math.cos(lat1) * Math.sin(dist) * Math.cos(brng));
      lon2 = lon1 + Math.atan2(Math.sin(brng) * Math.sin(dist) * Math.cos(lat1), Math.cos(dist) - Math.sin(lat1) * Math.sin(lat2));
      lon2 = (lon2 + 3 * Math.PI) % 2 * Math.PI - Math.PI;
      return {
        // normalise to -180..+180º
        'type': 'Point',
        'coordinates': [this.numberToDegree(lon2), this.numberToDegree(lat2)]
      };
    }

  };

}).call(this);
