  // Static method utilities       - Util is a global without a functional wrapper
  // coffee -c -bare Util.coffee   - prevents function wrap to put Util in global namespace
var Util,
  indexOf = [].indexOf,
  hasProp = {}.hasOwnProperty;

Util = (function() {
  class Util {
    static element($elem) {
      // console.log( 'Dom.element()', $elem, Dom.isJQueryElem( $elem ) )
      if (Util.isJQueryElem($elem)) {
        return $elem.get(0);
      } else if (Util.isStr($elem)) {
        return $($elem).get(0);
      } else {
        console.error('Dom.domElement( $elem )', typeof $elem, $elem, '$elem is neither jQuery object nor selector');
        return null;
      }
    }

    static isJQueryElem($elem) {
      return (typeof $ !== "undefined" && $ !== null) && ($elem != null) && ($elem instanceof $ || indexOf.call(Object($elem), 'jquery') >= 0);
    }

    // ------ Modules ------
    static init() {}

    static hasMethod(obj, method, issue = false) {
      var has;
      has = typeof obj[method] === 'function';
      if (!has && issue) {
        console.log('Util.hasMethod()', method, has);
      }
      return has;
    }

    static hasGlobal(global, issue = true) {
      var has;
      if (global == null) {
        Util.trace(global);
        return false;
      }
      has = window[global] != null;
      if (!has && issue) {
        console.error(`Util.hasGlobal() ${global} not present`);
      }
      return has;
    }

    static getGlobal(global, issue = true) {
      if (Util.hasGlobal(global, issue)) {
        return window[global];
      } else {
        return null;
      }
    }

    static hasPlugin(plugin, issue = true) {
      var glob, has, plug;
      glob = Util.firstTok(plugin, '.');
      plug = Util.lastTok(plugin, '.');
      has = (window[glob] != null) && (window[glob][plug] != null);
      if (!has && issue) {
        console.error(`Util.hasPlugin()  $${glob + '.' + plug} not present`);
      }
      return has;
    }

    static hasModule(path, issue = true) {
      var has;
      has = Util.modules[path] != null;
      if (!has && issue) {
        console.error(`Util.hasModule() ${path} not present`);
      }
      return has;
    }

    static dependsOn() {
      var arg, has, j, len, ok;
      ok = true;
      for (j = 0, len = arguments.length; j < len; j++) {
        arg = arguments[j];
        has = Util.hasGlobal(arg, false) || Util.hasModule(arg, false) || Util.hasPlugin(arg, false);
        if (!has) {
          console.error('Missing Dependency', arg);
        }
        if (has === false) {
          ok = has;
        }
      }
      return ok;
    }

    static verifyLoadModules(lib, modules, global = void 0) {
      var has, j, len, module, ok;
      ok = true;
      for (j = 0, len = modules.length; j < len; j++) {
        module = modules[j];
        has = global != null ? Util.hasGlobal(global, false) || Util.hasPlugin(global) : Util.hasModule(lib + module, false) != null;
        if (!has) {
          console.error('Util.verifyLoadModules() Missing Module', lib + module + '.js', {
            global: global
          });
        }
        ok &= has;
      }
      return ok;
    }

    static setInstance(instance, path) {
      console.log('Util.setInstance()', path);
      if ((instance == null) && (path != null)) {
        console.error('Util.setInstance() instance not defined for path', path);
      } else if ((instance != null) && (path == null)) {
        console.error('Util.setInstance() path not defined for instance', instance.toString());
      } else {
        Util.instances[path] = instance;
      }
    }

    static getInstance(path, dbg = false) {
      var instance;
      if (dbg) {
        console.log('getInstance', path);
      }
      instance = Util.instances[path];
      if (instance == null) {
        console.error('Util.getInstance() instance not defined for path', path);
      }
      return instance;
    }

    // ---- Logging -------

    // args should be the arguments passed by the original calling function
    // This method should not be called directly
    static toStrArgs(prefix, args) {
      var arg, j, len, str;
      console.logStackNum = 0;
      str = Util.isStr(prefix) ? prefix + " " : "";
      for (j = 0, len = args.length; j < len; j++) {
        arg = args[j];
        str += Util.toStr(arg) + " ";
      }
      return str;
    }

    static toStr(arg) {
      console.logStackNum++;
      if (console.logStackNum > console.logStackMax) {
        return '';
      }
      switch (typeof arg) {
        case 'null':
          return 'null';
        case 'string':
          return Util.toStrStr(arg);
        case 'number':
          return arg;
        case 'object':
          return Util.toStrObj(arg);
        default:
          return arg;
      }
    }

    // Recusively stringify arrays and objects
    static toStrObj(arg) {
      var a, j, len, prop, str;
      str = "";
      if (arg == null) {
        str += "null";
      } else if (Util.isArray(arg)) {
        str += "[ ";
        for (j = 0, len = arg.length; j < len; j++) {
          a = arg[j];
          str += Util.toStr(a) + ",";
        }
        str = str.substr(0, str.length - 1) + " ]";
      } else if (Util.isObjEmpty(arg)) {
        str += "{}";
      } else {
        str += "{ ";
        for (prop in arg) {
          if (typeof arg[prop] === 'object') {
            str += '\n';
          }
          if (arg.hasOwnProperty(prop)) {
            str += prop + ":" + Util.toStr(arg[prop]) + ", ";
          }
        }
        str = str.substr(0, str.length - 2) + " }"; // Removes last comma
      }
      return str;
    }

    static toStrStr(arg) {
      if (arg.length > 0) {
        return arg;
      } else {
        return '""';
      }
    }

    // Consume unused but mandated variable to pass code inspections
    static noop() {
      if (false) {
        console.log(arguments);
      }
    }

    // Conditional log arguments through console
    static dbg() {
      var str;
      if (!Util.debug) {
        return;
      }
      str = Util.toStrArgs('', arguments);
      Util.consoleLog(str);
    }

    // Log Error and arguments through console and Gritter
    //@gritter( { title:'Log', time:2000 }, str )
    static error() {
      var str;
      str = Util.toStrArgs('Error:', arguments);
      Util.consoleLog(str);
    }

    // Log Warning and arguments through console and Gritter
    // @gritter( { title:'Error', sticky:true }, str ) if window['$']? and $['gritter']?
    // Util.trace( 'Trace:' )
    static warn() {
      var str;
      str = Util.toStrArgs('Warning:', arguments);
      Util.consoleLog(str);
    }

    // @gritter( { title:'Warning', sticky:true }, str ) if window['$']? and $['gritter']?
    static toError() {
      var str;
      str = Util.toStrArgs('Error:', arguments);
      return new Error(str);
    }

    // Log arguments through console if it exists
    static log() {
      var str;
      str = Util.toStrArgs('', arguments);
      Util.consoleLog(str);
    }

    // Log arguments through gritter if it exists
    //@gritter( { title:'Log', time:2000 }, str )
    static called() {
      var str;
      str = Util.toStrArgs('', arguments);
      Util.consoleLog(str);
      this.gritter({
        title: 'Called',
        time: 2000
      }, str);
    }

    static gritter(opts, ...args) {
      var str;
      if (!(Util.hasGlobal('$', false) && ($['gritter'] != null))) {
        return;
      }
      str = Util.toStrArgs('', args);
      opts.title = opts.title != null ? opts.title : 'Gritter';
      opts.text = str;
      $.gritter.add(opts);
    }

    static consoleLog(str) {
      if (typeof console !== "undefined" && console !== null) {
        console.log(str);
      }
    }

    static trace() {
      var error, str;
      str = Util.toStrArgs('Trace:', arguments);
      try {
        throw new Error(str);
      } catch (error1) {
        error = error1;
        console.log(error.stack);
      }
    }

    static alert() {
      var str;
      str = Util.toStrArgs('', arguments);
      Util.consoleLog(str);
      alert(str);
    }

    // Does not work
    static logJSON(json) {
      return Util.consoleLog(json);
    }

    // ------ Validators ------
    static isDef(d) {
      return d != null;
    }

    static isStr(s) {
      return (s != null) && typeof s === "string" && s.length > 0;
    }

    static isNum(n) {
      return (n != null) && typeof n === "number" && !isNaN(n);
    }

    static isObj(o) {
      return (o != null) && typeof o === "object";
    }

    static isObjEmpty(o) {
      return Util.isObj(o) && Object.getOwnPropertyNames(o).length === 0;
    }

    static isFunc(f) {
      return (f != null) && typeof f === "function";
    }

    static isArray(a) {
      return (a != null) && typeof a !== "string" && (a.length != null) && a.length > 0;
    }

    static isEvent(e) {
      return (e != null) && (e.target != null);
    }

    static inIndex(a, i) {
      return Util.isArray(a) && 0 <= i && i < a.length;
    }

    static inArray(a, e) {
      return Util.isArray(a) && a.indexOf(e) > -1;
    }

    static atLength(a, n) {
      return Util.isArray(a) && a.length === n;
    }

    static head(a) {
      if (Util.isArray(a)) {
        return a[0];
      } else {
        return null;
      }
    }

    static tail(a) {
      if (Util.isArray(a)) {
        return a[a.length - 1];
      } else {
        return null;
      }
    }

    static time() {
      return new Date().getTime();
    }

    static isStrInteger(s) {
      return /^\s*(\+|-)?\d+\s*$/.test(s);
    }

    static isStrFloat(s) {
      return /^\s*(\+|-)?((\d+(\.\d+)?)|(\.\d+))\s*$/.test(s);
    }

    static isStrCurrency(s) {
      return /^\s*(\+|-)?((\d+(\.\d\d)?)|(\.\d\d))\s*$/.test(s);
    }

    //@isStrEmail:(s)   -> /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/.test(s)
    static isDefs() {
      var arg, j, len;
      for (j = 0, len = arguments.length; j < len; j++) {
        arg = arguments[j];
        if (arg == null) {
          return false;
        }
      }
      return true;
    }

    // Screen absolute (left top width height) percent positioning and scaling

    // Percent array to position mapping
    static toPosition(array) {
      return {
        left: array[0],
        top: array[1],
        width: array[2],
        height: array[3]
      };
    }

    // Adds Percent from array for CSS position mapping
    static toPositionPc(array) {
      return {
        position: 'absolute',
        left: array[0] + '%',
        top: array[1] + '%',
        width: array[2] + '%',
        height: array[3] + '%'
      };
    }

    static cssPosition($, screen, port, land) {
      var array;
      array = screen.orientation === 'Portrait' ? port : land;
      $.css(Util.toPositionPc(array));
    }

    static xyScale(prev, next, port, land) {
      var xn, xp, xs, yn, yp, ys;
      [xp, yp] = prev.orientation === 'Portrait' ? [port[2], port[3]] : [land[2], land[3]];
      [xn, yn] = next.orientation === 'Portrait' ? [port[2], port[3]] : [land[2], land[3]];
      xs = next.width * xn / (prev.width * xp);
      ys = next.height * yn / (prev.height * yp);
      return [xs, ys];
    }

    // ----------------- Guarded jQuery dependent calls -----------------
    static resize(callback) {
      window.onresize = function() {
        return setTimeout(callback, 100);
      };
    }

    static resizeTimeout(callback, timeout = null) {
      window.onresize = function() {
        if (timeout != null) {
          clearTimeout(timeout);
        }
        return timeout = setTimeout(callback, 100);
      };
    }

    static isEmpty($elem) {
      if (Util.hasGlobal('$')) {
        return $elem.length === 0 || $elem.children().length === 0;
      } else {
        return false;
      }
    }

    static isJQuery($e) {
      return Util.hasGlobal('$') && ($e != null) && ($e instanceof $ || indexOf.call(Object($e), 'jquery') >= 0) && $e.length > 0;
    }

    // ------ Converters ------
    static extend(obj, mixin) {
      var method, name;
      for (name in mixin) {
        if (!hasProp.call(mixin, name)) continue;
        method = mixin[name];
        obj[name] = method;
      }
      return obj;
    }

    static include(klass, mixin) {
      return Util.extend(klass.prototype, mixin);
    }

    static eventErrorCode(e) {
      var errorCode;
      errorCode = (e.target != null) && e.target.errorCode ? e.target.errorCode : 'unknown';
      return {
        errorCode: errorCode
      };
    }

    static indent(n) {
      var i, j, ref, str;
      str = '';
      for (i = j = 0, ref = n; (0 <= ref ? j < ref : j > ref); i = 0 <= ref ? ++j : --j) {
        str += ' ';
      }
      return str;
    }

    static hashCode(str) {
      var hash, i, j, ref;
      hash = 0;
      for (i = j = 0, ref = str.length; (0 <= ref ? j < ref : j > ref); i = 0 <= ref ? ++j : --j) {
        hash = (hash << 5) - hash + str.charCodeAt(i);
      }
      return hash;
    }

    static lastTok(str, delim) {
      return str.split(delim).pop();
    }

    static firstTok(str, delim) {
      if (Util.isStr(str) && (str.split != null)) {
        return str.split(delim)[0];
      } else {
        console.error("Util.firstTok() str is not at string", str);
        return '';
      }
    }

    /*
      parse = document.createElement('a')
      parse.href =  "http://example.com:3000/dir1/dir2/file.ext?search=test#hash"
      parse.protocol  "http:"
      parse.hostname  "example.com"
      parse.port      "3000"
      parse.pathname  "/dir1/dir2/file.ext"
      parse.segments  ['dir1','dir2','file.ext']
      parse.filex     ['file','ext']
      parse.file       'file'
      parse.ext        'ext'
      parse.search    "?search=test"
      parse.hash      "#hash"
      parse.host      "example.com:3000"
    */
    static parseURI(url) {
      var parse;
      parse = document.createElement('a');
      parse.href = url;
      parse.segments = parse.pathname.split('/');
      parse.filex = parse.segments.pop().split('.');
      parse.file = parse.filex[0];
      parse.ext = parse.filex.length === 2 ? parse.filex[1] : '';
      return parse;
    }

    static quicksort(array) {
      var a, head, large, small;
      if (array.length === 0) {
        return [];
      }
      head = array.pop();
      small = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = array.length; j < len; j++) {
          a = array[j];
          if (a <= head) {
            results.push(a);
          }
        }
        return results;
      })();
      large = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = array.length; j < len; j++) {
          a = array[j];
          if (a > head) {
            results.push(a);
          }
        }
        return results;
      })();
      return (Util.quicksort(small)).concat([head]).concat(Util.quicksort(large));
    }

    // Return and ISO formated data string
    static isoDateTime(date) {
      var pad;
      console.log('Util.isoDatetime()', date);
      console.log('Util.isoDatetime()', date.getUTCMonth().date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes, date.getUTCSeconds);
      pad = function(n) {
        if (n < 10) {
          return '0' + n;
        } else {
          return n;
        }
      };
      return date.getFullYear()(+'-' + pad(date.getUTCMonth() + 1) + '-' + pad(date.getUTCDate()) + 'T' + pad(date.getUTCHours()) + ':' + pad(date.getUTCMinutes()) + ':' + pad(date.getUTCSeconds()) + 'Z');
    }

    static toHMS() { // unixTime 
      var ampm, date, hour, min, sec, time;
      date = new Date(); // if Util.isNum(unixTime) then new Date( unixTime * 1000 ) else new Date()
      hour = date.getHours();
      ampm = 'AM';
      if (hour > 12) {
        hour = hour - 12;
        ampm = 'PM';
      }
      min = ('0' + date.getMinutes()).slice(-2);
      sec = ('0' + date.getSeconds()).slice(-2);
      time = `${hour}:${min}:${sec} ${ampm}`;
      return time;
    }

    // Generate four random hex digits
    static hex4() {
      return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }

    // Generate a 32 bits hex
    static hex32() {
      var hex, i, j;
      hex = this.hex4();
      for (i = j = 1; j <= 4; i = ++j) {
        Util.noop(i);
        hex += this.hex4();
      }
      return hex;
    }

    // Return a number with fixed decimal places
    static toFixed(arg, dec = 2) {
      var num;
      num = (function() {
        switch (typeof arg) {
          case 'number':
            return arg;
          case 'string':
            return parseFloat(arg);
          default:
            return 0;
        }
      })();
      return num.toFixed(dec);
    }

    static toInt(arg) {
      switch (typeof arg) {
        case 'number':
          return Math.floor(arg);
        case 'string':
          return parseInt(arg);
        default:
          return 0;
      }
    }

    static toFloat(arg) {
      switch (typeof arg) {
        case 'number':
          return arg;
        case 'string':
          return parseFloat(arg);
        default:
          return 0;
      }
    }

    static toCap(str) {
      return str.charAt(0).toUpperCase() + str.substring(1);
    }

    static unCap(str) {
      return str.charAt(0).toLowerCase() + str.substring(1);
    }

    // Beautiful Code, Chapter 1.
    // Implements a regular expression matcher that supports character matches,
    // '.', '^', '$', and '*'.

    // Search for the regexp anywhere in the text.
    static match(regexp, text) {
      if (regexp[0] === '^') {
        return Util.match_here(regexp.slice(1), text);
      }
      while (text) {
        if (Util.match_here(regexp, text)) {
          return true;
        }
        text = text.slice(1);
      }
      return false;
    }

    // Search for the regexp at the beginning of the text.
    static match_here(regexp, text) {
      var cur, next;
      [cur, next] = [regexp[0], regexp[1]];
      if (regexp.length === 0) {
        return true;
      }
      if (next === '*') {
        return Util.match_star(cur, regexp.slice(2), text);
      }
      if (cur === '$' && !next) {
        return text.length === 0;
      }
      if (text && (cur === '.' || cur === text[0])) {
        return Util.match_here(regexp.slice(1), text.slice(1));
      }
      return false;
    }

    // Search for a kleene star match at the beginning of the text.
    static match_star(c, regexp, text) {
      while (true) {
        if (Util.match_here(regexp, text)) {
          return true;
        }
        if (!(text && (text[0] === c || c === '.'))) {
          return false;
        }
        text = text.slice(1);
      }
    }

    static match_test() {
      console.log(Util.match_args("ex", "some text"));
      console.log(Util.match_args("s..t", "spit"));
      console.log(Util.match_args("^..t", "buttercup"));
      console.log(Util.match_args("i..$", "cherries"));
      console.log(Util.match_args("o*m", "vrooooommm!"));
      return console.log(Util.match_args("^hel*o$", "hellllllo"));
    }

    static match_args(regexp, text) {
      return console.log(regexp, text, Util.match(regexp, text));
    }

    static id(name, type = '', ext = '') {
      var htmlId;
      htmlId = name + type + ext;
      if (Util.htmlIds[htmlId] != null) {
        console.error('Util.id() duplicate html id', htmlId);
      }
      Util.htmlIds[htmlId] = htmlId;
      return htmlId;
    }

    static svgId(name, type, svgType, check = false) {
      if (check) {
        return this.id(name, type, svgType);
      } else {
        return name + type + svgType;
      }
    }

    static css(name, type = '') {
      return name + type;
    }

    static icon(name, type, fa) {
      return name + type + ' fa fa-' + fa;
    }

  };

  Util.testTrue = true;

  Util.debug = false;

  Util.count = 0;

  Util.modules = [];

  Util.instances = [];

  Util.htmlIds = {};

  Util.root = '';

  Util.paths = {}; // Set by loadInitLibs for future reference in calls to loadModule(s)

  Util.libs = {}; // Set by loadInitLibs for future reference in calls to loadModule(s)

  console.logStackNum = 0;

  console.logStackMax = 100;

  return Util;

}).call(this);

// Export Util as a convenience, since it is not really needed since Util is a global
// Need to export at the end of the file.
export default Util;
