

## To install bower dependencies

$ bower update 
    
## GeoJSON
  "Point", "MultiPoint", "LineString", "MultiLineString", "Polygon", "MultiPolygon", or "GeometryCollection"

## ogr2ogr - universal conversion tool
ogr2ogr -f GeoJSON -t_srs crs:84 [name].geojson [name].shp


### Polyline Style
color         String   '#03f'   Stroke color.
weight        Number   5   Stroke width in pixels.
opacity       Number   0.5   Stroke opacity.
fill          Boolean  depends   Whether to fill the path with color. Set it to false to disable filling on polygons or circles.
fillColor     String   same as color   Fill color.
fillOpacity   Number   0.2   Fill opacity.
dashArray     String   null   A string that defines the stroke dash pattern. Doesn't work on canvas-powered layers (e.g. Android 2).
lineCap       String   null   A string that defines shape to be used at the end of the stroke.
lineJoin      String   null   A string that defines shape to be used at the corners of the stroke.
clickable     Boolean  true   If false, the vector will not emit mouse events and will act as a part of the underlying map.
pointerEvents String   null   Sets the pointer-events attribute on the path if SVG backend is used.
className     String   ''   Custom class name set on an element.