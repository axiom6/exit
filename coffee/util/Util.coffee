
# Static method utilities       - Util is a global without a functional wrapper
# coffee -c -bare Util.coffee   - prevents function wrap to put Util in global namespace

class Util

  Util.testTrue  = true
  Util.debug     = false
  Util.count     = 0
  Util.modules   = []
  Util.instances = []
  Util.htmlIds   = {}
  Util.root      = ''
  Util.paths     = {} # Set by loadInitLibs for future reference in calls to loadModule(s)
  Util.libs      = {} # Set by loadInitLibs for future reference in calls to loadModule(s)
  console.logStackNum = 0
  console.logStackMax = 100

  @element:( $elem ) ->
    # console.log( 'Dom.element()', $elem, Dom.isJQueryElem( $elem ) )
    if Util.isJQueryElem( $elem )
      $elem.get(0)
    else if Util.isStr( $elem )
      $($elem).get(0)
    else
      console.error('Dom.domElement( $elem )', typeof($elem), $elem,
        '$elem is neither jQuery object nor selector' )
      null

  @isJQueryElem:( $elem ) ->
    $? and $elem? and ( $elem instanceof $ || 'jquery' in Object($elem) )

# ------ Modules ------

  @init:() ->

  @hasMethod:( obj, method, issue=false ) ->
    has = typeof obj[method] is 'function'
    console.log( 'Util.hasMethod()', method, has )  if not has and issue
    has

  @hasGlobal:( global, issue=true ) ->
    if not global?
      Util.trace(  global )
      return false
    has = window[global]?
    console.error( "Util.hasGlobal() #{global} not present" )  if not has and issue
    has

  @getGlobal:( global, issue=true ) ->
    if Util.hasGlobal( global, issue ) then window[global] else null

  @hasPlugin:( plugin, issue=true ) ->
    glob = Util.firstTok(plugin,'.')
    plug = Util.lastTok( plugin,'.')
    has  = window[glob]? and window[glob][plug]?
    console.error( "Util.hasPlugin()  $#{glob+'.'+plug} not present" )  if not has and issue
    has

  @hasModule:( path, issue=true ) ->
    has = Util.modules[path]?
    console.error( "Util.hasModule() #{path} not present" )  if not has and issue
    has

  @dependsOn:() ->
    ok = true
    for arg in arguments
      has = Util.hasGlobal(arg,false) or Util.hasModule(arg,false) or Util.hasPlugin(arg,false)
      console.error( 'Missing Dependency', arg ) if not has
      ok = has if has is false
    ok

  @verifyLoadModules:(lib,modules,global=undefined) ->
    ok  = true
    for module in modules
      has = if global? then Util.hasGlobal(global,false) or Util.hasPlugin(global) else Util.hasModule(lib+module,false)?
      console.error( 'Util.verifyLoadModules() Missing Module', lib+module+'.js', {global:global} ) if not has
      ok &= has
    ok

  @setInstance:( instance, path ) ->
    console.log( 'Util.setInstance()', path )
    if not instance? and path?
      console.error('Util.setInstance() instance not defined for path', path )
    else if instance? and not path?
      console.error('Util.setInstance() path not defined for instance', instance.toString() )
    else
      Util.instances[path] = instance
    return

  @getInstance:( path, dbg=false ) ->
    console.log( 'getInstance', path ) if dbg
    instance = Util.instances[path]
    if not instance?
      console.error('Util.getInstance() instance not defined for path', path )
    instance

  # ---- Logging -------

  # args should be the arguments passed by the original calling function
  # This method should not be called directly
  @toStrArgs:( prefix, args ) ->
    console.logStackNum = 0
    str = if Util.isStr(prefix) then prefix + " "  else ""
    for arg in args
      str += Util.toStr(arg) + " "
    str

  @toStr:( arg ) ->
    console.logStackNum++
    return '' if console.logStackNum > console.logStackMax
    switch typeof(arg)
      when 'null'   then 'null'
      when 'string' then Util.toStrStr(arg)
      when 'number' then arg
      when 'object' then Util.toStrObj(arg)
      else arg

  # Recusively stringify arrays and objects
  @toStrObj:( arg ) ->
    str = ""
    if not arg?
      str += "null"
    else if Util.isArray(arg)
      str += "[ "
      for a in arg
        str += Util.toStr(a) + ","
      str = str.substr(0, str.length - 1) + " ]"
    else if Util.isObjEmpty(arg)
      str += "{}"
    else
      str += "{ "
      for prop of arg
        str += '\n' if typeof(arg[prop]) is 'object'
        str += prop + ":"   + Util.toStr(arg[prop]) + ", "  if arg.hasOwnProperty(prop)
      str = str.substr(0, str.length - 2) + " }" # Removes last comma
    str

  @toStrStr:( arg ) ->
    if arg.length > 0 then arg
    else '""'

  # Consume unused but mandated variable to pass code inspections
  @noop:() ->
    console.log( arguments ) if false
    return

  # Conditional log arguments through console
  @dbg:() ->
    return if not Util.debug
    str = Util.toStrArgs( '', arguments )
    Util.consoleLog( str )
    #@gritter( { title:'Log', time:2000 }, str )
    return

  # Log Error and arguments through console and Gritter
  @error:() ->
    str  = Util.toStrArgs( 'Error:', arguments )
    Util.consoleLog( str )
    # @gritter( { title:'Error', sticky:true }, str ) if window['$']? and $['gritter']?
    # Util.trace( 'Trace:' )
    return

  # Log Warning and arguments through console and Gritter
  @warn:() ->
    str  = Util.toStrArgs( 'Warning:', arguments )
    Util.consoleLog( str )
    # @gritter( { title:'Warning', sticky:true }, str ) if window['$']? and $['gritter']?
    return

  @toError:() ->
    str = Util.toStrArgs( 'Error:', arguments )
    new Error( str )

  # Log arguments through console if it exists
  @log:() ->
    str = Util.toStrArgs( '', arguments )
    Util.consoleLog( str )
    #@gritter( { title:'Log', time:2000 }, str )
    return

  # Log arguments through gritter if it exists
  @called:() ->
    str = Util.toStrArgs( '', arguments )
    Util.consoleLog( str )
    @gritter( { title:'Called', time:2000 }, str )
    return

  @gritter:( opts, args... ) ->
    return if not ( Util.hasGlobal('$',false)  and $['gritter']? )
    str = Util.toStrArgs( '', args )
    opts.title = if opts.title? then opts.title else 'Gritter'
    opts.text  = str
    $.gritter.add( opts )
    return

  @consoleLog:( str ) ->
    console.log(str) if console?
    return

  @trace:(  ) ->
    str = Util.toStrArgs( 'Trace:', arguments )
    try
      throw new Error( str )
    catch error
      console.log( error.stack )
    return

  @alert:(  ) ->
    str = Util.toStrArgs( '', arguments )
    Util.consoleLog( str )
    alert( str )
    return

  # Does not work
  @logJSON:(json) ->
    Util.consoleLog(json)

  # ------ Validators ------

  @isDef:(d)         ->  d?
  @isStr:(s)         ->  s? and typeof(s)=="string" and s.length > 0
  @isNum:(n)         ->  n? and typeof(n)=="number" and not isNaN(n)
  @isObj:(o)         ->  o? and typeof(o)=="object"
  @isObjEmpty:(o)    ->  Util.isObj(o) and Object.getOwnPropertyNames(o).length is 0
  @isFunc:(f)        ->  f? and typeof(f)=="function"
  @isArray:(a)       ->  a? and typeof(a)!="string" and a.length? and a.length > 0
  @isEvent:(e)       ->  e? and e.target?
  @inIndex:(a,i)     ->  Util.isArray(a) and 0 <= i and i < a.length
  @inArray:(a,e)     ->  Util.isArray(a) and a.indexOf(e) > -1
  @atLength:(a,n)    ->  Util.isArray(a) and a.length==n
  @head:(a)          ->  if Util.isArray(a) then a[0]          else null
  @tail:(a)          ->  if Util.isArray(a) then a[a.length-1] else null
  @time:()           ->  new Date().getTime()
  @isStrInteger:(s)  -> /^\s*(\+|-)?\d+\s*$/.test(s)
  @isStrFloat:(s)    -> /^\s*(\+|-)?((\d+(\.\d+)?)|(\.\d+))\s*$/.test(s)
  @isStrCurrency:(s) -> /^\s*(\+|-)?((\d+(\.\d\d)?)|(\.\d\d))\s*$/.test(s)
  #@isStrEmail:(s)   -> /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/.test(s)

  @isDefs:() ->
    for arg in arguments
      if not arg?
        return false
    true

  # Screen absolute (left top width height) percent positioning and scaling

  # Percent array to position mapping
  @toPosition:( array ) ->
    { left:array[0], top:array[1], width:array[2], height:array[3] }

  # Adds Percent from array for CSS position mapping
  @toPositionPc:( array ) ->
    { position:'absolute', left:array[0]+'%', top:array[1]+'%', width:array[2]+'%', height:array[3]+'%' }

  @cssPosition:( $, screen, port, land ) ->
    array = if screen.orientation is 'Portrait' then port else land
    $.css( Util.toPositionPc(array) )
    return

  @xyScale:( prev, next, port, land ) ->
    [xp,yp] = if prev.orientation is 'Portrait' then [port[2],port[3]] else [land[2],land[3]]
    [xn,yn] = if next.orientation is 'Portrait' then [port[2],port[3]] else [land[2],land[3]]
    xs = next.width  * xn  / ( prev.width  * xp )
    ys = next.height * yn  / ( prev.height * yp )
    [xs,ys]

  # ----------------- Guarded jQuery dependent calls -----------------

  @resize:( callback ) ->
    window.onresize = () ->
      setTimeout( callback, 100 )
    return

  @resizeTimeout:( callback, timeout = null ) ->
    window.onresize = () ->
      clearTimeout( timeout ) if timeout?
      timeout = setTimeout( callback, 100 )
    return

  @isEmpty:( $elem ) ->
    if Util.hasGlobal('$')
      $elem.length == 0 || $elem.children().length == 0
    else
      false

  @isJQuery:( $e ) ->
    Util.hasGlobal('$') and $e? and ( $e instanceof $ || 'jquery' in Object($e) ) and $e.length > 0

  # ------ Converters ------

  @extend:( obj, mixin ) ->
    for own name, method of mixin
      obj[name] = method
    obj

  @include:( klass, mixin ) ->
    Util.extend( klass.prototype, mixin )

  @eventErrorCode:( e ) ->
    errorCode = if e.target? and e.target.errorCode then e.target.errorCode else 'unknown'
    { errorCode:errorCode }

  @indent:(n) ->
    str = ''
    for i in [0...n]
      str += ' '
    str

  @hashCode:( str ) ->
    hash = 0
    for i in [0...str.length]
      hash = (hash<<5) - hash + str.charCodeAt(i)
    hash

  @lastTok:( str, delim ) ->
    str.split(delim).pop()

  @firstTok:( str, delim ) ->
    if Util.isStr(str) and str.split?
      str.split(delim)[0]
    else
      console.error( "Util.firstTok() str is not at string", str )
      ''
  ###
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
  ###

  @parseURI:( url ) ->
    parse          = document.createElement('a')
    parse.href     = url
    parse.segments = parse.pathname.split('/')
    parse.filex    = parse.segments.pop().split('.')
    parse.file     = parse.filex[0]
    parse.ext      = if parse.filex.length==2 then parse.filex[1] else ''
    parse

  @quicksort:( array ) ->
    return [] if array.length == 0
    head = array.pop()
    small = ( a for a in array when a <= head )
    large = ( a for a in array when a >  head )
    (Util.quicksort(small)).concat([head]).concat( Util.quicksort(large) )

  # Return and ISO formated data string
  @isoDateTime:( date ) ->
    console.log( 'Util.isoDatetime()', date )
    console.log( 'Util.isoDatetime()', date.getUTCMonth(). date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes, date.getUTCSeconds )
    pad = (n) -> if n < 10 then '0'+n else n
    date.getFullYear()     +'-'+pad(date.getUTCMonth()+1)+'-'+pad(date.getUTCDate())+'T'+
    pad(date.getUTCHours())+':'+pad(date.getUTCMinutes())+':'+pad(date.getUTCSeconds())+'Z'

  @toHMS:( ) -> # unixTime 
    date = new Date() # if Util.isNum(unixTime) then new Date( unixTime * 1000 ) else new Date()
    hour   = date.getHours()
    ampm   = 'AM'
    if hour > 12
      hour = hour - 12
      ampm = 'PM'
    min  = ('0' + date.getMinutes()).slice(-2)
    sec  = ('0' + date.getSeconds()).slice(-2)
    time = "#{hour}:#{min}:#{sec} #{ampm}"
    time

  # Generate four random hex digits
  @hex4:() ->
    (((1+Math.random())*0x10000)|0).toString(16).substring(1)

  # Generate a 32 bits hex
  @hex32:() ->
    hex = @hex4()
    for i in [1..4]
      Util.noop(i)
      hex += @hex4()
    hex

  # Return a number with fixed decimal places
  @toFixed:( arg, dec=2 ) ->
    num = switch typeof(arg)
      when 'number' then arg
      when 'string' then parseFloat(arg)
      else 0
    num.toFixed(dec)

  @toInt:( arg ) ->
    switch typeof(arg)
      when 'number' then Math.floor(arg)
      when 'string' then  parseInt(arg)
      else 0

  @toFloat:( arg ) ->
    switch typeof(arg)
      when 'number' then arg
      when 'string' then parseFloat(arg)
      else 0

  @toCap:( str ) ->
    str.charAt(0).toUpperCase() + str.substring(1)

  @unCap:( str ) ->
    str.charAt(0).toLowerCase() + str.substring(1)

  # Beautiful Code, Chapter 1.
  # Implements a regular expression matcher that supports character matches,
  # '.', '^', '$', and '*'.

  # Search for the regexp anywhere in the text.
  @match:(regexp, text) ->
    return Util.match_here(regexp.slice(1), text) if regexp[0] is '^'
    while text
      return true if Util.match_here(regexp, text)
      text = text.slice(1)
    false

  # Search for the regexp at the beginning of the text.
  @match_here:(regexp, text) ->
    [cur, next] = [regexp[0], regexp[1]]
    if regexp.length is 0 then return true
    if next is '*' then return Util.match_star(cur, regexp.slice(2), text)
    if cur is '$' and not next then return text.length is 0
    if text and (cur is '.' or cur is text[0]) then return Util.match_here(regexp.slice(1), text.slice(1))
    false

  # Search for a kleene star match at the beginning of the text.
  @match_star:(c, regexp, text) ->
    loop
      return true if Util.match_here(regexp, text)
      return false unless text and (text[0] is c or c is '.')
      text = text.slice(1)

  @match_test:() ->
    console.log( Util.match_args("ex", "some text") )
    console.log( Util.match_args("s..t", "spit") )
    console.log( Util.match_args("^..t", "buttercup") )
    console.log( Util.match_args("i..$", "cherries") )
    console.log( Util.match_args("o*m", "vrooooommm!") )
    console.log( Util.match_args("^hel*o$", "hellllllo") )

  @match_args:( regexp, text ) ->
    console.log( regexp, text, Util.match(regexp,text) )

  @id:( name, type='', ext='' ) ->
    htmlId = name + type + ext
    console.error( 'Util.id() duplicate html id', htmlId ) if Util.htmlIds[htmlId]?
    Util.htmlIds[htmlId] = htmlId
    htmlId

  @svgId:( name, type, svgType, check=false ) ->
    if check then @id( name, type, svgType ) else name + type + svgType
  @css:(   name, type=''       ) -> name + type
  @icon:(  name, type, fa      ) -> name + type + ' fa fa-' + fa

# Export Util as a convenience, since it is not really needed since Util is a global
# Need to export at the end of the file.
`export default Util`
