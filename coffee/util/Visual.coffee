
class Visual

  @rad:( deg ) -> deg * Math.PI / 180
  @deg:( rad ) -> rad * 180 / Math.PI
  @sin:( deg ) -> Math.sin(Visual.rad(deg))
  @cos:( deg ) -> Math.cos(Visual.rad(deg))

  @svgDeg:( deg ) -> 360-deg
  @svgRad:( rad ) -> 2*Math.PI-rad

  @radSvg:( deg ) -> Visual.rad(360-deg)
  @degSvg:( rad ) -> Visual.deg(2*Math.PI-rad)
  @sinSvg:( deg ) -> Math.sin(Visual.radSvg(deg))
  @cosSvg:( deg ) -> Math.cos(Visual.radSvg(deg))

  @pad2:( n  ) ->
    s = n.toString()
    if 0 <= n && n <= 9 then  s = '&nbsp;'  + s
    s

  @pad3:( n ) ->
    s = n.toString()
    if  0 <= n && n <= 9 then s = '&nbsp;&nbsp;' + s
    if 10 <= n && n <=99 then s = '&nbsp;'  + s
    #Util.dbg( 'pad', { s:'|'+s+'|', n:n,  } )
    s

  @dec:( f )      -> Math.round(f*100) / 100
  @quotes:( str ) -> '"' + str + '"'

  @within:( beg, deg, end ) -> beg   <= deg and deg <= end # Closed interval with <=
  @isZero:( v )             -> -0.01 <  v   and v   <  0.01

  @floor:( x, dx ) ->  dr = Math.round(dx); Math.floor( x / dr ) * dr
  @ceil:(  x, dx ) ->  dr = Math.round(dx); Math.ceil(  x / dr ) * dr

  @to:( a, a1, a2, b1, b2 ) -> (a-a1) / (a2-a1) * (b2-b1) + b1  # Linear transforms that calculates b from a

  # Need to fully determine if these isZero checks are really necessary. Also need to account for SVG angles
  @angle:( x, y ) ->
    ang = Visual.deg(Math.atan2(y,x)) if not @isZero(x) and not @isZero(y)
    ang =   0 if @isZero(x) and @isZero(y)
    ang =   0 if x > 0      and @isZero(y)
    ang =  90 if @isZero(x) and y > 0
    ang = 180 if x < 0      and @isZero(y)
    ang = 270 if @isZero(x) and y < 0
    ang = Visual.deg(Math.atan2(y,x))
    ang = if ang < 0 then 360+ang else ang

  @angleSvg:( x, y ) -> Visual.angle( x, -y )

  @minRgb:( rgb ) -> Math.min( rgb.r,  rgb.g,  rgb.b )
  @maxRgb:( rgb ) -> Math.max( rgb.r,  rgb.g,  rgb.b )
  @sumRgb:( rgb ) ->           rgb.r + rgb.g + rgb.b

  #hexCss:( hex ) -> """##{hex.toString(16)}""" # For orthogonality
  @rgbCss:( rgb ) -> """rgb(#{rgb.r},#{rgb.g},#{rgb.b})"""
  @hslCss:( hsl ) -> """hsl(#{hsl.h},#{hsl.s*100}%,#{hsl.l*100}%)"""
  @hsiCss:( hsi ) -> Visual.hslCss( Visual.rgbToHsl( Visual.hsiToRgb(hsi) ) )
  @hsvCss:( hsv ) -> Visual.hslCss( Visual.rgbToHsl( Visual.hsvToRgb(hsv) ) )

  @roundRgb:( rgb, f=1.0 ) -> { r:Math.round(rgb.r*f), g:Math.round(rgb.g*f), b:Math.round(rgb.b*f) }
  @roundHsl:( hsl ) -> { h:Math.round(hsl.h), s:Visual.dec(hsl.s), l:Visual.dec(hsl.l)    }
  @roundHsi:( hsi ) -> { h:Math.round(hsi.h), s:Visual.dec(hsi.s), i:Math.round(hsi.i) }
  @roundHsv:( hsv ) -> { h:Math.round(hsv.h), s:Visual.dec(hsv.s), v:Visual.dec(hsv.v)    }
  @fixedDec:( rgb ) -> { r:Visual.dec(rgb.r),    g:Visual.dec(rgb.g), b:Visual.dec(rgb.b)    }

  @hexRgb:( hex ) -> Visual.roundRgb( { r:(hex & 0xFF0000) >> 16, g:(hex & 0x00FF00) >> 8, b:hex & 0x0000FF } )
  @rgbHex:( rgb ) -> rgb.r * 4096 + rgb.g * 256 + rgb.b
  @cssRgb:( str ) ->
    rgb = { r:0, g:0, b:0 }
    if str[0]=='#'
      hex = parseInt( str.substr(1), 16 )
      rgb = Visual.hexRgb(hex)
    else if str.slice(0,3)=='rgb'
      toks = str.split(/[\s,\(\)]+/)
      rgb  = Visual.roundRgb( { r:parseInt(toks[1]), g:parseInt(toks[2]), b:parseInt(toks[3]) } )
    else if str.slice(0,3)=='hsl'
      toks = str.split(/[\s,\(\)]+/)
      hsl  = { h:parseInt(toks[1]), s:parseInt(toks[2]), l:parseInt(toks[3]) }
      rgb  = Visual.hslToRgb(hsl)
    else
      console.error( 'Visual.cssRgb() unknown CSS color', str )
    rgb

  # Util.dbg( 'Visual.cssRgb', toks.length, { r:toks[1], g:toks[2], b:toks[3] } )

  @rgbToHsi:( rgb ) ->
    sum = Visual.sumRgb( rgb )
    r = rgb.r/sum; g = rgb.g/sum; b = rgb.b/sum
    i = sum / 3
    s = 1 - 3 * Math.min(r,g,b)
    a = Visual.deg( Math.acos( ( r - 0.5*(g+b) ) / Math.sqrt((r-g)*(r-g)+(r-b)*(g-b)) ) )
    h = if b <= g then a else 360 - a
    Visual.roundHsi( { h:h, s:s, i:i } )

  @hsiToRgb:( hsi ) ->
    h = hsi.h; s = hsi.s; i = hsi.i
    x =        1 - s
    y = (a) -> 1 + s * Visual.cos(h-a) / Visual.cos(a+60-h)
    z = (a) -> 3 - x - y(a)
    rgb = { r:0,      g:0,      b:0      }
    rgb = { r:y(0),   g:z(0),   b:x      }  if   0 <= h && h < 120
    rgb = { r:x,      g:y(120), b:z(120) }  if 120 <= h && h < 240
    rgb = { r:z(240), g:x,      b:y(240) }  if 240 <= h && h < 360
    max = Visual.maxRgb(rgb) * i
    fac = if max > 255 then i*255/max else i
    #Util.dbg('Visual.hsiToRgb', hsi, Visual.roundRgb(rgb,fac), Visual.fixedDec(rgb), Visual.dec(max) )
    Visual.roundRgb( rgb, fac )

  @hsvToRgb:( hsv ) ->
    i = Math.floor( hsv.h / 60 )
    f = hsv.h / 60 - i
    p = hsv.v * (1 - hsv.s)
    q = hsv.v * (1 - f * hsv.s)
    t = hsv.v * (1 - (1 - f) * hsv.s)
    v = hsv.v
    rgb = switch i % 6
      when 0 then { r:v, g:t, b:p }
      when 1 then { r:q, g:v, b:p }
      when 2 then { r:p, g:v, b:t }
      when 3 then { r:p, g:q, b:v }
      when 4 then { r:t, g:p, b:v }
      when 5 then { r:v, g:p, b:q }
      else console.error('Visual.hsvToRgb()'); { r:v, g:t, b:p } # Should never happend
    Visual.roundRgb( rgb, 255 )

  ###
  @rgbToHsv:( rgb ) ->
    rgb = Visual.rgbRound( rgb, 1/255 )
    max = Visual.maxRgb( rgb )
    min = Visual.maxRgb( rgb )
    v   = max
    d   = max - min
    s   = if max == 0 then 0 else d / max
    h   = 0 # achromatic
    if max != min
      h = switch max
        when r
          ( rgb.g - rgb.b ) / d + if g < b then 6 else 0
        when g then  ( rgb.b - rgb.r ) / d + 2
        when b then  ( rgb.r - rgb.g ) / d + 4
        else console.error('Visual.rgbToHsv')
    { h:Math.round(h*60), s:Visual.dec(s), v:Visual.dec(v) } 
  ###

  @hslToRgb:( hsl ) ->
    h = hsl.h; s = hsl.s; l = hsl.l
    r = 1;     g = 1;     b = 1
    if s != 0
      q = if l < 0.5 then l * (1 + s) else l + s - l * s
      p = 2 * l - q;
      r = Visual.hue2rgb(p, q, h+1/3 )
      g = Visual.hue2rgb(p, q, h     )
      b = Visual.hue2rgb(p, q, h-1/3 )
    { r:Math.round(r*255), g:Math.round(g*255), b:Math.round(b*255) }

  @hue2rgb:( p, q, t ) ->
    if(t < 0     ) then t += 1
    if(t > 1     ) then t -= 1
    if(t < 1 / 6 ) then return p + (q - p) * 6 * t
    if(t < 1 / 2 ) then return q
    if(t < 2 / 3 ) then return p + (q - p) * (2 / 3 - t) * 6
    p

  @rgbsToHsl:( red, green, blue ) ->
    @rgbToHsl( { r:red, g:green, b:blue } )

  @rgbToHsl:( rgb ) ->
    r   = rgb.r / 255; g = rgb.g / 255; b = rgb.b / 255
    max = Math.max( r, g, b )
    min = Math.min( r, g, b )
    h   = 0 # achromatic
    l   = (max + min) / 2
    s   = 0
    if max != min
      d = max - min
      s = if l > 0.5 then d / (2 - max - min) else d / (max + min)
      h = switch max
        when r
          ( g - b ) / d + if g < b then 6 else 0
        when g then ( b - r ) / d + 2
        when b then ( r - g ) / d + 4
        else console.error('Visual.@rgbToHsl()'); 0
    { h:Math.round(h*60), s:Visual.dec(s), l:Visual.dec(l) }

`export default Visual`