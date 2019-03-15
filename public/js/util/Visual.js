(function() {
  var Visual;

  Visual = class Visual {
    static rad(deg) {
      return deg * Math.PI / 180;
    }

    static deg(rad) {
      return rad * 180 / Math.PI;
    }

    static sin(deg) {
      return Math.sin(Visual.rad(deg));
    }

    static cos(deg) {
      return Math.cos(Visual.rad(deg));
    }

    static svgDeg(deg) {
      return 360 - deg;
    }

    static svgRad(rad) {
      return 2 * Math.PI - rad;
    }

    static radSvg(deg) {
      return Visual.rad(360 - deg);
    }

    static degSvg(rad) {
      return Visual.deg(2 * Math.PI - rad);
    }

    static sinSvg(deg) {
      return Math.sin(Visual.radSvg(deg));
    }

    static cosSvg(deg) {
      return Math.cos(Visual.radSvg(deg));
    }

    static pad2(n) {
      var s;
      s = n.toString();
      if (0 <= n && n <= 9) {
        s = '&nbsp;' + s;
      }
      return s;
    }

    static pad3(n) {
      var s;
      s = n.toString();
      if (0 <= n && n <= 9) {
        s = '&nbsp;&nbsp;' + s;
      }
      if (10 <= n && n <= 99) {
        s = '&nbsp;' + s;
      }
      //Util.dbg( 'pad', { s:'|'+s+'|', n:n,  } )
      return s;
    }

    static dec(f) {
      return Math.round(f * 100) / 100;
    }

    static quotes(str) {
      return '"' + str + '"';
    }

    static within(beg, deg, end) {
      return beg <= deg && deg <= end; // Closed interval with <=
    }

    static isZero(v) {
      return -0.01 < v && v < 0.01;
    }

    static floor(x, dx) {
      var dr;
      dr = Math.round(dx);
      return Math.floor(x / dr) * dr;
    }

    static ceil(x, dx) {
      var dr;
      dr = Math.round(dx);
      return Math.ceil(x / dr) * dr;
    }

    static to(a, a1, a2, b1, b2) {
      return (a - a1) / (a2 - a1) * (b2 - b1) + b1; // Linear transforms that calculates b from a
    }

    
    // Need to fully determine if these isZero checks are really necessary. Also need to account for SVG angles
    static angle(x, y) {
      var ang;
      if (!this.isZero(x) && !this.isZero(y)) {
        ang = Visual.deg(Math.atan2(y, x));
      }
      if (this.isZero(x) && this.isZero(y)) {
        ang = 0;
      }
      if (x > 0 && this.isZero(y)) {
        ang = 0;
      }
      if (this.isZero(x) && y > 0) {
        ang = 90;
      }
      if (x < 0 && this.isZero(y)) {
        ang = 180;
      }
      if (this.isZero(x) && y < 0) {
        ang = 270;
      }
      ang = Visual.deg(Math.atan2(y, x));
      return ang = ang < 0 ? 360 + ang : ang;
    }

    static angleSvg(x, y) {
      return Visual.angle(x, -y);
    }

    static minRgb(rgb) {
      return Math.min(rgb.r, rgb.g, rgb.b);
    }

    static maxRgb(rgb) {
      return Math.max(rgb.r, rgb.g, rgb.b);
    }

    static sumRgb(rgb) {
      return rgb.r + rgb.g + rgb.b;
    }

    //hexCss:( hex ) -> """##{hex.toString(16)}""" # For orthogonality
    static rgbCss(rgb) {
      return `rgb(${rgb.r},${rgb.g},${rgb.b})`;
    }

    static hslCss(hsl) {
      return `hsl(${hsl.h},${hsl.s * 100}%,${hsl.l * 100}%)`;
    }

    static hsiCss(hsi) {
      return Visual.hslCss(Visual.rgbToHsl(Visual.hsiToRgb(hsi)));
    }

    static hsvCss(hsv) {
      return Visual.hslCss(Visual.rgbToHsl(Visual.hsvToRgb(hsv)));
    }

    static roundRgb(rgb, f = 1.0) {
      return {
        r: Math.round(rgb.r * f),
        g: Math.round(rgb.g * f),
        b: Math.round(rgb.b * f)
      };
    }

    static roundHsl(hsl) {
      return {
        h: Math.round(hsl.h),
        s: Visual.dec(hsl.s),
        l: Visual.dec(hsl.l)
      };
    }

    static roundHsi(hsi) {
      return {
        h: Math.round(hsi.h),
        s: Visual.dec(hsi.s),
        i: Math.round(hsi.i)
      };
    }

    static roundHsv(hsv) {
      return {
        h: Math.round(hsv.h),
        s: Visual.dec(hsv.s),
        v: Visual.dec(hsv.v)
      };
    }

    static fixedDec(rgb) {
      return {
        r: Visual.dec(rgb.r),
        g: Visual.dec(rgb.g),
        b: Visual.dec(rgb.b)
      };
    }

    static hexRgb(hex) {
      return Visual.roundRgb({
        r: (hex & 0xFF0000) >> 16,
        g: (hex & 0x00FF00) >> 8,
        b: hex & 0x0000FF
      });
    }

    static rgbHex(rgb) {
      return rgb.r * 4096 + rgb.g * 256 + rgb.b;
    }

    static cssRgb(str) {
      var hex, hsl, rgb, toks;
      rgb = {
        r: 0,
        g: 0,
        b: 0
      };
      if (str[0] === '#') {
        hex = parseInt(str.substr(1), 16);
        rgb = Visual.hexRgb(hex);
      } else if (str.slice(0, 3) === 'rgb') {
        toks = str.split(/[\s,\(\)]+/);
        rgb = Visual.roundRgb({
          r: parseInt(toks[1]),
          g: parseInt(toks[2]),
          b: parseInt(toks[3])
        });
      } else if (str.slice(0, 3) === 'hsl') {
        toks = str.split(/[\s,\(\)]+/);
        hsl = {
          h: parseInt(toks[1]),
          s: parseInt(toks[2]),
          l: parseInt(toks[3])
        };
        rgb = Visual.hslToRgb(hsl);
      } else {
        console.error('Visual.cssRgb() unknown CSS color', str);
      }
      return rgb;
    }

    // Util.dbg( 'Visual.cssRgb', toks.length, { r:toks[1], g:toks[2], b:toks[3] } )
    static rgbToHsi(rgb) {
      var a, b, g, h, i, r, s, sum;
      sum = Visual.sumRgb(rgb);
      r = rgb.r / sum;
      g = rgb.g / sum;
      b = rgb.b / sum;
      i = sum / 3;
      s = 1 - 3 * Math.min(r, g, b);
      a = Visual.deg(Math.acos((r - 0.5 * (g + b)) / Math.sqrt((r - g) * (r - g) + (r - b) * (g - b))));
      h = b <= g ? a : 360 - a;
      return Visual.roundHsi({
        h: h,
        s: s,
        i: i
      });
    }

    static hsiToRgb(hsi) {
      var fac, h, i, max, rgb, s, x, y, z;
      h = hsi.h;
      s = hsi.s;
      i = hsi.i;
      x = 1 - s;
      y = function(a) {
        return 1 + s * Visual.cos(h - a) / Visual.cos(a + 60 - h);
      };
      z = function(a) {
        return 3 - x - y(a);
      };
      rgb = {
        r: 0,
        g: 0,
        b: 0
      };
      if (0 <= h && h < 120) {
        rgb = {
          r: y(0),
          g: z(0),
          b: x
        };
      }
      if (120 <= h && h < 240) {
        rgb = {
          r: x,
          g: y(120),
          b: z(120)
        };
      }
      if (240 <= h && h < 360) {
        rgb = {
          r: z(240),
          g: x,
          b: y(240)
        };
      }
      max = Visual.maxRgb(rgb) * i;
      fac = max > 255 ? i * 255 / max : i;
      //Util.dbg('Visual.hsiToRgb', hsi, Visual.roundRgb(rgb,fac), Visual.fixedDec(rgb), Visual.dec(max) )
      return Visual.roundRgb(rgb, fac);
    }

    static hsvToRgb(hsv) {
      var f, i, p, q, rgb, t, v;
      i = Math.floor(hsv.h / 60);
      f = hsv.h / 60 - i;
      p = hsv.v * (1 - hsv.s);
      q = hsv.v * (1 - f * hsv.s);
      t = hsv.v * (1 - (1 - f) * hsv.s);
      v = hsv.v;
      rgb = (function() {
        switch (i % 6) {
          case 0:
            return {
              r: v,
              g: t,
              b: p
            };
          case 1:
            return {
              r: q,
              g: v,
              b: p
            };
          case 2:
            return {
              r: p,
              g: v,
              b: t
            };
          case 3:
            return {
              r: p,
              g: q,
              b: v
            };
          case 4:
            return {
              r: t,
              g: p,
              b: v
            };
          case 5:
            return {
              r: v,
              g: p,
              b: q
            };
          default:
            console.error('Visual.hsvToRgb()');
            return {
              r: v,
              g: t,
              b: p // Should never happend
            };
        }
      })();
      return Visual.roundRgb(rgb, 255);
    }

    /*
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
    */
    static hslToRgb(hsl) {
      var b, g, h, l, p, q, r, s;
      h = hsl.h;
      s = hsl.s;
      l = hsl.l;
      r = 1;
      g = 1;
      b = 1;
      if (s !== 0) {
        q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        p = 2 * l - q;
        r = Visual.hue2rgb(p, q, h + 1 / 3);
        g = Visual.hue2rgb(p, q, h);
        b = Visual.hue2rgb(p, q, h - 1 / 3);
      }
      return {
        r: Math.round(r * 255),
        g: Math.round(g * 255),
        b: Math.round(b * 255)
      };
    }

    static hue2rgb(p, q, t) {
      if (t < 0) {
        t += 1;
      }
      if (t > 1) {
        t -= 1;
      }
      if (t < 1 / 6) {
        return p + (q - p) * 6 * t;
      }
      if (t < 1 / 2) {
        return q;
      }
      if (t < 2 / 3) {
        return p + (q - p) * (2 / 3 - t) * 6;
      }
      return p;
    }

    static rgbsToHsl(red, green, blue) {
      return this.rgbToHsl({
        r: red,
        g: green,
        b: blue
      });
    }

    static rgbToHsl(rgb) {
      var b, d, g, h, l, max, min, r, s;
      r = rgb.r / 255;
      g = rgb.g / 255;
      b = rgb.b / 255;
      max = Math.max(r, g, b);
      min = Math.min(r, g, b);
      h = 0; // achromatic
      l = (max + min) / 2;
      s = 0;
      if (max !== min) {
        d = max - min;
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        h = (function() {
          switch (max) {
            case r:
              return (g - b) / d + (g < b ? 6 : 0);
            case g:
              return (b - r) / d + 2;
            case b:
              return (r - g) / d + 4;
            default:
              console.error('Visual.@rgbToHsl()');
              return 0;
          }
        })();
      }
      return {
        h: Math.round(h * 60),
        s: Visual.dec(s),
        l: Visual.dec(l)
      };
    }

  };

  export default Visual;

}).call(this);
