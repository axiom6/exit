// Generated by CoffeeScript 1.9.1
var Util,
  slice = [].slice,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  hasProp = {}.hasOwnProperty;

Util = (function() {
  function Util() {}

  Util.hasMethod = function(obj, method) {
    var has;
    has = typeof obj[method] === 'function';
    Util.log('Util.hasMethod()', method, has);
    return has;
  };

  Util.saveUndefExports = function() {
    var exports;
    Util.log('Util.saveUndefExports()', typeof exports, typeof window.exports, typeof root.exports);
    Util.exports = window.exports;
    exports = void 0;
    window.exports = void 0;
    return root.exports = void 0;
  };

  Util.restoreExports = function() {
    window.exports = Util.exports;
    return Util.exports = void 0;
  };

  Util.promise = function(resolve, reject) {
    if (typeof ES6Promise !== "undefined" && ES6Promise !== null) {
      return new ES6Promise.Promise(resolve, reject);
    } else {
      Util.error('Util.promise() ES6Promise missing so returning null');
      return null;
    }
  };

  Util.hasGlobal = function(global, issue) {
    var has;
    if (issue == null) {
      issue = true;
    }
    if (global == null) {
      Util.trace(global);
      return false;
    }
    has = window[global] != null;
    if (!has && issue) {
      Util.error("Util.hasGlobal() " + global + " not present");
    }
    return has;
  };

  Util.getGlobal = function(global, issue) {
    if (issue == null) {
      issue = true;
    }
    if (Util.hasGlobal(global, issue)) {
      return window[global];
    } else {
      return null;
    }
  };

  Util.hasPlugin = function(plugin, issue) {
    var glob, has, plug;
    if (issue == null) {
      issue = true;
    }
    glob = Util.firstTok(plugin, '.');
    plug = Util.lastTok(plugin, '.');
    has = (window[glob] != null) && (window[glob][plug] != null);
    if (!has && issue) {
      Util.error("Util.hasPlugin()  $" + (glob + '.' + plug) + " not present");
    }
    return has;
  };

  Util.hasModule = function(path, issue) {
    var has;
    if (issue == null) {
      issue = true;
    }
    has = Util.modules[path] != null;
    if (!has && issue) {
      Util.error("Util.hasModule() " + path + " not present");
    }
    return has;
  };

  Util.dependsOn = function() {
    var arg, has, j, len, ok;
    ok = true;
    for (j = 0, len = arguments.length; j < len; j++) {
      arg = arguments[j];
      has = Util.hasGlobal(arg, false) || Util.hasModule(arg, false) || Util.hasPlugin(arg, false);
      if (!has) {
        Util.error('Missing Dependency', arg);
      }
      ok &= has;
    }
    return ok;
  };

  Util.verifyLoadModules = function(lib, modules, global) {
    var has, j, len, module, ok;
    if (global == null) {
      global = void 0;
    }
    ok = true;
    for (j = 0, len = modules.length; j < len; j++) {
      module = modules[j];
      has = global != null ? Util.hasGlobal(global, false) || Util.hasPlugin(global) : Util.hasModule(lib + module, false) != null;
      if (!has) {
        Util.error('Util.verifyLoadModules() Missing Module', lib + module + '.js', {
          global: global
        });
      }
      ok &= has;
    }
    return ok;
  };

  Util.loadInitLibs = function(root, paths, libs, callback, dbg) {
    var deps, dir, j, len, mod, path, ref, ref1;
    if (dbg == null) {
      dbg = false;
    }
    Util.root = root;
    Util.paths = paths;
    Util.libs = libs;
    if (!Util.hasGlobal('yepnope')) {
      return;
    }
    deps = [];
    ref = libs.paths;
    for (path in ref) {
      dir = ref[path];
      ref1 = libs[path];
      for (j = 0, len = ref1.length; j < len; j++) {
        mod = ref1[j];
        deps.push(root + dir + mod + '.js');
        if (dbg) {
          Util.log(root + dir + mod + '.js');
        }
      }
    }
    yepnope([
      {
        load: deps,
        complete: callback
      }
    ]);
  };

  Util.loadModules = function(path, dir, modules, callback) {
    var deps, j, len, module, modulesCallback;
    if (callback == null) {
      callback = null;
    }
    if (!Util.hasGlobal('yepnope')) {
      return;
    }
    modulesCallback = callback != null ? callback : (function(_this) {
      return function() {
        return Util.verifyLoadModules(dir, modules);
      };
    })(this);
    deps = [];
    for (j = 0, len = modules.length; j < len; j++) {
      module = modules[j];
      if (!Util.hasModule(dir + module, false)) {
        deps.push(Util.root + path + dir + module + '.js');
      } else {
        Util.warn('Util.loadModules() already loaded module', Util.root + dir + module);
      }
    }
    yepnope([
      {
        load: deps,
        complete: modulesCallback
      }
    ]);
  };

  Util.loadModule = function(path, dir, module, global) {
    var modulesCallback;
    if (global == null) {
      global = void 0;
    }
    if (!Util.hasGlobal('yepnope')) {
      return;
    }
    modulesCallback = typeof callback !== "undefined" && callback !== null ? callback : (function(_this) {
      return function() {
        return Util.verifyLoadModules(dir, [module], global);
      };
    })(this);
    if (((global != null) && !Util.hasGlobal(global, false)) || !Util.hasModule(dir + module, false)) {
      yepnope([
        {
          load: Util.root + path + dir + module + '.js',
          complete: modulesCallback
        }
      ]);
    } else {
      Util.warn('Util.loadModule() already loaded module', dir + module);
    }
  };

  Util.Export = function(module, path, dbg) {
    if (dbg == null) {
      dbg = false;
    }
    Util.setModule(module, path);
    if (typeof define !== "undefined" && define !== null) {
      define(path, function() {
        return module;
      });
    }
    if (dbg) {
      Util.log('Util.Export', path);
    }
    return module;
  };

  Util.Import = function(path) {
    var module;
    module = Util.getModule(path);
    if ((module == null) && Util.hasRequireJS()) {
      module = requirejs(path);
      Util.Export(module, path);
    }
    return module;
  };

  Util.IdExt = function(path) {
    var ext, module;
    module = Util.Import(path);
    ext = '';
    if ((module != null ? module.ext : void 0) == null) {
      Util.error('Util.IdExt() id extension ext not defined for module with path', path);
      ext = module.ext;
    } else {
      ext = path.split('/').pop();
    }
    return ext;
  };

  Util.hasRequireJS = function() {
    return (typeof require !== "undefined" && require !== null) && (typeof requirejs !== "undefined" && requirejs !== null);
  };

  Util.define = function(path, module) {
    return Util.Export(module, path);
  };

  Util.setModule = function(module, path) {
    if ((module == null) && (path != null)) {
      Util.error('Util.setModule() module not defined for path', path);
    } else if ((module != null) && (path == null)) {
      Util.error('Util.setModule() path not  defined for module', module.toString());
    } else {
      Util.modules[path] = module;
    }
  };

  Util.getModule = function(path, dbg) {
    var module;
    if (dbg == null) {
      dbg = false;
    }
    if (dbg) {
      Util.log('getNodule', path);
    }
    module = Util.modules[path];
    if (module == null) {
      Util.error('Util.getModule() module not defined for path', path);
    }
    return module;
  };

  Util.setInstance = function(instance, path) {
    Util.log('Util.setInstance()', path);
    if ((instance == null) && (path != null)) {
      Util.error('Util.setInstance() instance not defined for path', path);
    } else if ((instance != null) && (path == null)) {
      Util.error('Util.setInstance() path not defined for instance', instance.toString());
    } else {
      Util.instances[path] = instance;
    }
  };

  Util.getInstance = function(path, dbg) {
    var instance;
    if (dbg == null) {
      dbg = false;
    }
    if (dbg) {
      Util.log('getInstance', path);
    }
    instance = Util.instances[path];
    if (instance == null) {
      Util.error('Util.getInstance() instance not defined for path', path);
    }
    return instance;
  };

  Util.toStrArgs = function(prefix, args) {
    var arg, j, len, str;
    Util.logStackNum = 0;
    str = Util.isStr(prefix) ? prefix + " " : "";
    for (j = 0, len = args.length; j < len; j++) {
      arg = args[j];
      str += Util.toStr(arg) + " ";
    }
    return str;
  };

  Util.toStr = function(arg) {
    Util.logStackNum++;
    if (Util.logStackNum > Util.logStackMax) {
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
  };

  Util.toStrObj = function(arg) {
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
      str = str.substr(0, str.length - 2) + " }";
    }
    return str;
  };

  Util.toStrStr = function(arg) {
    if (arg.length > 0) {
      return arg;
    } else {
      return '""';
    }
  };

  Util.dbgFiltersObj = function(obj) {
    var prop, str;
    if (!Util.debug) {
      return;
    }
    str = "";
    if (obj['dbgFilters'] != null) {
      if (Util.isArray(obj['dbgFilters']) && obj['dbgFilters'][0] !== '*') {
        for (prop in obj) {
          if (prop !== 'dbgFilters' && obj['dbgFilters'].indexOf(prop) === -1 && obj.hasOwnProperty(prop)) {
            if (typeof arg[prop] === 'object') {
              str += '\n';
            }
            str += prop + ":" + Util.toStr(obj[prop]) + ", ";
          }
        }
        str = str.substr(0, str.length - 2);
        Util.log(str);
      }
    } else {
      Util.log(obj);
    }
  };

  Util.noop = function() {
    if (false) {
      Util.log(arguments);
    }
  };

  Util.dbg = function() {
    var str;
    if (!Util.debug) {
      return;
    }
    str = Util.toStrArgs('', arguments);
    Util.consoleLog(str);
  };

  Util.error = function() {
    var str;
    str = Util.toStrArgs('Error:', arguments);
    Util.consoleLog(str);
  };

  Util.warn = function() {
    var str;
    str = Util.toStrArgs('Warning:', arguments);
    Util.consoleLog(str);
  };

  Util.toError = function() {
    var str;
    str = Util.toStrArgs('Error:', arguments);
    return new Error(str);
  };

  Util.log = function() {
    var str;
    str = Util.toStrArgs('', arguments);
    Util.consoleLog(str);
  };

  Util.called = function() {
    var str;
    str = Util.toStrArgs('', arguments);
    Util.consoleLog(str);
    this.gritter({
      title: 'Called',
      time: 2000
    }, str);
  };

  Util.gritter = function() {
    var args, opts, str;
    opts = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (!(Util.hasGlobal('$', false) && ($['gritter'] != null))) {
      return;
    }
    str = Util.toStrArgs('', args);
    opts.title = opts.title != null ? opts.title : 'Gritter';
    opts.text = str;
    $.gritter.add(opts);
  };

  Util.consoleLog = function(str) {
    if (typeof console !== "undefined" && console !== null) {
      console.log(str);
    }
  };

  Util.trace = function() {
    var error, str;
    str = Util.toStrArgs('Trace:', arguments);
    try {
      throw new Error(str);
    } catch (_error) {
      error = _error;
      Util.log(error.stack);
    }
  };

  Util.alert = function() {
    var str;
    str = Util.toStrArgs('', arguments);
    Util.consoleLog(str);
    alert(str);
  };

  Util.logJSON = function(json) {
    return Util.consoleLog(json);
  };

  Util.isDef = function(d) {
    return d != null;
  };

  Util.isStr = function(s) {
    return (s != null) && typeof s === "string" && s.length > 0;
  };

  Util.isNum = function(n) {
    return (n != null) && typeof n === "number" && !isNaN(n);
  };

  Util.isObj = function(o) {
    return (o != null) && typeof o === "object";
  };

  Util.isObjEmpty = function(o) {
    return Util.isObj(o) && Object.getOwnPropertyNames(o).length === 0;
  };

  Util.isFunc = function(f) {
    return (f != null) && typeof f === "function";
  };

  Util.isArray = function(a) {
    return (a != null) && typeof a !== "string" && (a.length != null) && a.length > 0;
  };

  Util.isEvent = function(e) {
    return (e != null) && (e.target != null);
  };

  Util.inIndex = function(a, i) {
    return Util.isArray(a) && 0 <= i && i < a.length;
  };

  Util.inArray = function(a, e) {
    return Util.isArray(a) && a.indexOf(e) > -1;
  };

  Util.atLength = function(a, n) {
    return Util.isArray(a) && a.length === n;
  };

  Util.head = function(a) {
    if (Util.isArray(a)) {
      return a[0];
    } else {
      return null;
    }
  };

  Util.tail = function(a) {
    if (Util.isArray(a)) {
      return a[a.length - 1];
    } else {
      return null;
    }
  };

  Util.time = function() {
    return new Date().getTime();
  };

  Util.isStrInteger = function(s) {
    return /^\s*(\+|-)?\d+\s*$/.test(s);
  };

  Util.isStrFloat = function(s) {
    return /^\s*(\+|-)?((\d+(\.\d+)?)|(\.\d+))\s*$/.test(s);
  };

  Util.isStrCurrency = function(s) {
    return /^\s*(\+|-)?((\d+(\.\d\d)?)|(\.\d\d))\s*$/.test(s);
  };

  Util.resize = function(callback) {
    window.onresize = function() {
      return setTimeout(callback, 100);
    };
  };

  Util.resizeTimeout = function(callback, timeout) {
    if (timeout == null) {
      timeout = null;
    }
    window.onresize = function() {
      if (timeout != null) {
        clearTimeout(timeout);
      }
      return timeout = setTimeout(callback, 100);
    };
  };

  Util.show = function(id, hide) {
    var $id;
    $id = $('#' + id);
    if (!Util.hasGlobal('$')) {
      return $id;
    }
    if (hide != null) {
      $(hide).hide();
    }
    $id.show();
    return $id;
  };

  Util.needsContent = function(id, hide) {
    var $id;
    if (!Util.hasGlobal('$')) {
      return false;
    }
    $id = Util.show(id, hide);
    return Util.isEmpty($id);
  };

  Util.isEmpty = function($elem) {
    if (Util.hasGlobal('$')) {
      return $elem.length === 0 || $elem.children().length === 0;
    } else {
      return false;
    }
  };

  Util.isJQuery = function($e) {
    return Util.hasGlobal('$') && ($e != null) && ($e instanceof $ || indexOf.call(Object($e), 'jquery') >= 0) && $e.length > 0;
  };

  Util.extend = function(obj, mixin) {
    var method, name;
    for (name in mixin) {
      if (!hasProp.call(mixin, name)) continue;
      method = mixin[name];
      obj[name] = method;
    }
    return obj;
  };

  Util.include = function(klass, mixin) {
    return Util.extend(klass.prototype, mixin);
  };

  Util.toEvent = function(e) {
    var errorCode;
    errorCode = (e.target != null) && e.target.errorCode ? e.target.errorCode : void 0;
    return {
      errorCode: errorCode
    };
  };

  Util.indent = function(n) {
    var i, j, ref, str;
    str = '';
    for (i = j = 0, ref = n; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      str += ' ';
    }
    return str;
  };

  Util.hashCode = function(str) {
    var hash, i, j, ref;
    hash = 0;
    for (i = j = 0, ref = str.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      hash = (hash << 5) - hash + str.charCodeAt(i);
    }
    return hash;
  };

  Util.lastTok = function(str, delim) {
    return str.split(delim).pop();
  };

  Util.firstTok = function(str, delim) {
    if (Util.isStr(str) && (str.split != null)) {
      return str.split(delim)[0];
    } else {
      Util.error("Util.firstTok() str is not at string", str);
      return '';
    }
  };

  Util.isDefs = function() {
    var arg, j, len;
    for (j = 0, len = arguments.length; j < len; j++) {
      arg = arguments[j];
      if (arg == null) {
        return false;
      }
    }
    return true;
  };


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

  Util.parseURI = function(url) {
    var parse;
    parse = document.createElement('a');
    parse.href = url;
    parse.segments = parse.pathname.split('/');
    parse.filex = parse.segments.pop().split('.');
    parse.file = parse.filex[0];
    parse.ext = parse.filex.length === 2 ? parse.filex[1] : '';
    return parse;
  };

  Util.quicksort = function(array) {
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
  };

  Util.isoDateTime = function(date) {
    var pad;
    Util.log('Util.isoDatetime()', date);
    Util.log('Util.isoDatetime()', date.getUTCMonth().date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes, date.getUTCSeconds);
    pad = function(n) {
      if (n < 10) {
        return '0' + n;
      } else {
        return n;
      }
    };
    return date.getFullYear()(+'-' + pad(date.getUTCMonth() + 1) + '-' + pad(date.getUTCDate()) + 'T' + pad(date.getUTCHours()) + ':' + pad(date.getUTCMinutes()) + ':' + pad(date.getUTCSeconds()) + 'Z');
  };

  Util.toHMS = function(unixTime) {
    var ampm, date, hour, min, sec, time;
    date = Util.isNum(unixTime) ? new Date(unixTime * 1000) : new Date();
    hour = date.getHours();
    ampm = 'AM';
    if (hour > 12) {
      hour = hour - 12;
      ampm = 'PM';
    }
    min = ('0' + date.getMinutes()).slice(-2);
    sec = ('0' + date.getSeconds()).slice(-2);
    time = hour + ":" + min + ":" + sec + " " + ampm;
    return time;
  };

  Util.hex4 = function() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  };

  Util.hex32 = function() {
    var hex, i, j;
    hex = this.hex4();
    for (i = j = 1; j <= 4; i = ++j) {
      Util.noop(i);
      hex += this.hex4();
    }
    return hex;
  };

  Util.toFixed = function(arg, dec) {
    var num;
    if (dec == null) {
      dec = 2;
    }
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
  };

  Util.toInt = function(arg) {
    switch (typeof arg) {
      case 'number':
        return Math.floor(arg);
      case 'string':
        return parseInt(arg);
      default:
        return 0;
    }
  };

  Util.toFloat = function(arg) {
    switch (typeof arg) {
      case 'number':
        return arg;
      case 'string':
        return parseFloat(arg);
      default:
        return 0;
    }
  };

  Util.toCap = function(str) {
    return str.charAt(0).toUpperCase() + str.substring(1);
  };

  Util.unCap = function(str) {
    return str.charAt(0).toLowerCase() + str.substring(1);
  };

  Util.match = function(regexp, text) {
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
  };

  Util.match_here = function(regexp, text) {
    var cur, next, ref;
    ref = [regexp[0], regexp[1]], cur = ref[0], next = ref[1];
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
  };

  Util.match_star = function(c, regexp, text) {
    while (true) {
      if (Util.match_here(regexp, text)) {
        return true;
      }
      if (!(text && (text[0] === c || c === '.'))) {
        return false;
      }
      text = text.slice(1);
    }
  };

  Util.match_test = function() {
    Util.log(Util.match_args("ex", "some text"));
    Util.log(Util.match_args("s..t", "spit"));
    Util.log(Util.match_args("^..t", "buttercup"));
    Util.log(Util.match_args("i..$", "cherries"));
    Util.log(Util.match_args("o*m", "vrooooommm!"));
    return Util.log(Util.match_args("^hel*o$", "hellllllo"));
  };

  Util.match_args = function(regexp, text) {
    return Util.log(regexp, text, Util.match(regexp, text));
  };

  return Util;

})();

Util.Export(Util, 'mod/Util');