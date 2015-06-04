// Generated by CoffeeScript 1.9.1
var Visual;

Visual = (function() {
  function Visual() {}

  Util.Export(Visual, 'app/Visual');

  Visual.rad = function(deg) {
    return deg * Math.PI / 180;
  };

  Visual.deg = function(rad) {
    return rad * 180 / Math.PI;
  };

  Visual.sin = function(deg) {
    return Math.sin(Visual.rad(deg));
  };

  Visual.cos = function(deg) {
    return Math.cos(Visual.rad(deg));
  };

  Visual.svgDeg = function(deg) {
    return 360 - deg;
  };

  Visual.svgRad = function(rad) {
    return 2 * Math.PI - rad;
  };

  Visual.radSvg = function(deg) {
    return Visual.rad(360 - deg);
  };

  Visual.degSvg = function(rad) {
    return Visual.deg(2 * Math.PI - rad);
  };

  Visual.sinSvg = function(deg) {
    return Math.sin(Visual.radSvg(deg));
  };

  Visual.cosSvg = function(deg) {
    return Math.cos(Visual.radSvg(deg));
  };

  Visual.pad2 = function(n) {
    var s;
    s = n.toString();
    if (0 <= n && n <= 9) {
      s = '&nbsp;' + s;
    }
    return s;
  };

  Visual.pad3 = function(n) {
    var s;
    s = n.toString();
    if (0 <= n && n <= 9) {
      s = '&nbsp;&nbsp;' + s;
    }
    if (10 <= n && n <= 99) {
      s = '&nbsp;' + s;
    }
    return s;
  };

  Visual.dec = function(f) {
    return Math.round(f * 100) / 100;
  };

  Visual.quotes = function(str) {
    return '"' + str + '"';
  };

  Visual.within = function(beg, deg, end) {
    return beg <= deg && deg <= end;
  };

  Visual.isZero = function(v) {
    return -0.01 < v && v < 0.01;
  };

  Visual.floor = function(x, dx) {
    var dr;
    dr = Math.round(dx);
    return Math.floor(x / dr) * dr;
  };

  Visual.ceil = function(x, dx) {
    var dr;
    dr = Math.round(dx);
    return Math.ceil(x / dr) * dr;
  };

  Visual.to = function(a, a1, a2, b1, b2) {
    return (a - a1) / (a2 - a1) * (b2 - b1) + b1;
  };

  Visual.angle = function(x, y) {
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
  };

  Visual.angleSvg = function(x, y) {
    return Visual.angle(x, -y);
  };

  Visual.minRgb = function(rgb) {
    return Math.min(rgb.r, rgb.g, rgb.b);
  };

  Visual.maxRgb = function(rgb) {
    return Math.max(rgb.r, rgb.g, rgb.b);
  };

  Visual.sumRgb = function(rgb) {
    return rgb.r + rgb.g + rgb.b;
  };

  Visual.hexCss = function(hex) {
    return "#" + (hex.toString(16));
  };

  Visual.rgbCss = function(rgb) {
    return "rgb(" + rgb.r + "," + rgb.g + "," + rgb.b + ")";
  };

  Visual.hslCss = function(hsl) {
    return "hsl(" + hsl.h + "," + (hsl.s * 100) + "%," + (hsl.l * 100) + "%)";
  };

  Visual.hsiCss = function(hsi) {
    return Visual.hslCss(Visual.rgbToHsl(Visual.hsiToRgb(hsi)));
  };

  Visual.hsvCss = function(hsv) {
    return Visual.hslCss(Visual.rgbToHsl(Visual.hsvToRgb(hsv)));
  };

  Visual.roundRgb = function(rgb, f) {
    if (f == null) {
      f = 1.0;
    }
    return {
      r: Math.round(rgb.r * f),
      g: Math.round(rgb.g * f),
      b: Math.round(rgb.b * f)
    };
  };

  Visual.roundHsl = function(hsl) {
    return {
      h: Math.round(hsl.h),
      s: Visual.dec(hsl.s),
      l: Visual.dec(hsl.l)
    };
  };

  Visual.roundHsi = function(hsi) {
    return {
      h: Math.round(hsi.h),
      s: Visual.dec(hsi.s),
      i: Math.round(hsi.i)
    };
  };

  Visual.roundHsv = function(hsv) {
    return {
      h: Math.round(hsv.h),
      s: Visual.dec(hsv.s),
      v: Visual.dec(hsv.v)
    };
  };

  Visual.fixedDec = function(rgb) {
    return {
      r: Visual.dec(rgb.r),
      g: Visual.dec(rgb.g),
      b: Visual.dec(rgb.b)
    };
  };

  Visual.hexRgb = function(hex) {
    return Visual.roundRgb({
      r: (hex & 0xFF0000) >> 16,
      g: (hex & 0x00FF00) >> 8,
      b: hex & 0x0000FF
    });
  };

  Visual.rgbHex = function(rgb) {
    return rgb.r * 4096 + rgb.g * 256 + rgb.b;
  };

  Visual.cssRgb = function(str) {
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
      Util.error('Visual.cssRgb() unknown CSS color', str);
    }
    return rgb;
  };

  Visual.rgbToHsi = function(rgb) {
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
  };

  Visual.hsiToRgb = function(hsi) {
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
    return Visual.roundRgb(rgb, fac);
  };

  Visual.hsvToRgb = function(hsv) {
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
          Util.error('Visual.hsvToRgb()');
          return {
            r: v,
            g: t,
            b: p
          };
      }
    })();
    return Visual.roundRgb(rgb, 255);
  };

  Visual.rgbToHsv = function(rgb) {
    var d, h, max, min, s, v;
    rgb = Visual.rgbRound(rgb, 1 / 255);
    max = Visual.maxRgb(rgb);
    min = Visual.maxRgb(rgb);
    v = max;
    d = max - min;
    s = max === 0 ? 0 : d / max;
    h = 0;
    if (max !== min) {
      h = (function() {
        switch (max) {
          case r:
            return (rgb.g - rgb.b) / d + (g < b ? 6 : 0);
          case g:
            return (rgb.b - rgb.r) / d + 2;
          case b:
            return (rgb.r - rgb.g) / d + 4;
          default:
            return Util.error('Visual.rgbToHsv');
        }
      })();
    }
    return {
      h: Math.round(h * 60),
      s: Visual.dec(s),
      v: Visual.dec(v)
    };
  };

  Visual.hslToRgb = function(hsl) {
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
  };

  Visual.hue2rgb = function(p, q, t) {
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
  };

  Visual.rgbsToHsl = function(red, green, blue) {
    return this.rgbToHsl({
      r: red,
      g: green,
      b: blue
    });
  };

  Visual.rgbToHsl = function(rgb) {
    var b, d, g, h, l, max, min, r, s;
    r = rgb.r / 255;
    g = rgb.g / 255;
    b = rgb.b / 255;
    max = Math.max(r, g, b);
    min = Math.min(r, g, b);
    h = 0;
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
            Util.error('Visual.@rgbToHsl()');
            return 0;
        }
      })();
    }
    return {
      h: Math.round(h * 60),
      s: Visual.dec(s),
      l: Visual.dec(l)
    };
  };

  return Visual;

})();