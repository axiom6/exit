

class Test

  Util.Test = Test
  Util.Export( Util.Test,  'util/Util.Test' )

  app = Util.app

  describe("Util.Test", () ->
    it("hasMethod",              () -> expect( Util.hasMethod(  app, 'ready'     ) ).toBe(true)  )
    it("hasGlobal",              () -> expect( Util.hasGlobal(  Util             ) ).toBe(true)  )
    it("hasGlobal",              () -> expect( Util.getGlobal( 'fullScreen'      ) ).toBe(false) )
    it("hasPlugin",              () -> expect( Util.hasPlugin( 'Util.hasPlugin'  ) ).tobe(true)  )
    it("hasModule",              () -> expect( Util.hasModule( 'app/Util'        ) ).toBe(true)  )
    it("dependsOn(global)",      () -> expect( Util.dependsOn( 'fullScreen'      ) ).toBe(true)  )
    it("dependsOn(module)",      () -> expect( Util.dependsOn( 'app/Util'        ) ).toBe(true)  )
    it("dependsOn(plugin)",      () -> expect( Util.dependsOn( 'Util.hasPlugin'  ) ).toBe(true)  )
    it("verifyLoadModules stub", () -> expect( true                                ).toBe(true)  )
    it("loadInitLibs      stub", () -> expect( true                                ).toBe(true)  )
    it("loadModules       stub", () -> expect( true                                ).toBe(true)  )
    it("loadModule        stub", () -> expect( true                                ).toBe(true)  )
    it("IdExt             stub", () -> expect( true                                ).toBe(true)  )
    it("Export Import",          () -> Util.Export(  'Util','zzz/Util'); expect(true).toBe(    Util.Import(    'zzz/Util').testTrue ) )
    it("setModule   getModule",  () -> Util.setModule(Util, 'yyy/Util'); expect(true).toBe(    Util.getModule('yyyy/Util').testTrue ) )
    it("setInstance getInstance",() -> Util.setInstance('xx','xx');      expect('xx').toEqual( Util.getInstance('xx') ) )
    
    it("toStr",     () -> expect( Util.toStr(null)      ).toEqual( 'null'         ) )
    it("toStr",     () -> expect( Util.toStr('1')       ).toEqual( '1'            ) )
    it("toStr",     () -> expect( Util.toStr(1)         ).toEqual( '1'            ) )
    it("toStr",     () -> expect( Util.toStr(1.0)       ).toEqual( '1'            ) )
    it("toStr",     () -> expect( Util.toStr({a:1,b:2}) ).toEqual( '{ a:1, b:2 }' ) )
    it("toStrStr",  () -> expect( Util.toStrStr('str')   ).toEqual( 'str'          ) )
    it("toStrStr",  () -> expect( Util.toStrStr('')      ).toEqual( '""'           ) )
    it("toStrArgs", () -> expect( Util.toStrArgs('a',1,{a:1,b:2}) ).toEqual( 'a, 1, { a:1, b:2 }' ) )
    it("toStrObj",  () -> expect( Util.toStrObj({a:1,b:2}) )       .toEqual( '{ a:1, b:2 }' ) )
    
    it('isDef:(d)',         () -> expect( Util.isDef(Util.testTrue)    ).toBe(true) )
    it('isStr:(s)',         () -> expect( Util.isStr('1')              ).toBe(true) )
    it('isNum:(n)',         () -> expect( Util.isNum( 1)               ).toBe(true) )
    it('isObj:(o)',         () -> expect( Util.isObj({a:1,b:2})        ).toBe(true) )
    it('isObjEmpty:(o)',    () -> expect( Util.isObjEmpty({})          ).toBe(true) )
    it('isFunc:(f)',        () -> expect( Util.isFunc(Util.isFunc)     ).toBe(true) )
    it('isArray:(a)',       () -> expect( Util.isArray([1,2])          ).toBe(true) )
    it('isEvent:(e)',       () -> expect( Util.isEvent({target:1})     ).toBe(true) )
    it('inIndex:(a,i)',     () -> expect( Util.inIndex( [1,2],1)       ).toBe(true) )
    it('inArray:(a,e)',     () -> expect( Util.inArray( [1,2],1)       ).toBe(true) )
    it('atLength:(a,n)',    () -> expect( Util.atLength([1,2],2)       ).toBe(true) )
    it('head:(a)',          () -> expect( Util.head(    [1,2])         ).toEqual(1) )
    it('tail:(a)',          () -> expect( Util.tail(    [1,2])         ).toEqual(2) )
    it('isStrInteger:(s)',  () -> expect( Util.isStrInteger('1')       ).toBe(true) )
    it('isStrFloat:(s)',    () -> expect( Util.isStrFloat('1.0')       ).toBe(true) )
    it('isStrCurrency:(s)', () -> expect( Util.isStrCurrency('1.00')   ).toBe(true) )
    it('isDefs:(d)',         () -> expect( Util.isDefs( 1, 2 )         ).toBe(true) )

    it("resize         stub", () -> expect( true                       ).toBe(true)  )
    it("resizeTimeout  stub", () -> expect( true                       ).toBe(true)  )
    it("isEmpty        stub", () -> expect( true                       ).toBe(true)  )
    it("isJquery       stub", () -> expect( true                       ).toBe(true)  )
    it("extend         stub", () -> expect( true                       ).toBe(true)  )
    it("include        stub", () -> expect( true                       ).toBe(true)  )
    it("eventErrorCode stub", () -> expect( true                       ).toBe(true)  )

    it('indent',          () -> expect( Util.indent(2)                  ).toEqual('  ') )
    it("hashCode  stub", () -> expect( true                            ).toBe(true)  )
    it('lastTok',         () -> expect( Util.lastTok('1,2',',')         ).toEqual('2') )
    it('firstTok',        () -> expect( Util.firstTok('1,2',',')        ).toEqual('2') )

    it('parseURI',        () ->
      o = Util.parseURI( "http://example.com:3000/dir1/dir2/file.ext?search=test#hash" )
      expect( o.filex        ).toEqual(['file','ext'])
      expect( o.file         ).toEqual( 'file')
      expect( o.ext          ).toEqual( 'ext') )

    it('quicksork',        () -> expect( Util.quicksork([2,3,1])        ).toEqual([1,2,3]) )
  )



# Return and ISO formated data string
  @isoDateTime:( date ) ->
    Util.log( 'Util.isoDatetime()', date )
    Util.log( 'Util.isoDatetime()', date.getUTCMonth(). date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes, date.getUTCSeconds )
    pad = (n) -> if n < 10 then '0'+n else n
    date.getFullYear()     +'-'+pad(date.getUTCMonth()+1)+'-'+pad(date.getUTCDate())+'T'+
        pad(date.getUTCHours())+':'+pad(date.getUTCMinutes())+':'+pad(date.getUTCSeconds())+'Z'

  @toHMS:( unixTime ) ->
    date = if Util.isNum(unixTime) then new Date( unixTime * 1000 ) else new Date()
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

  @toCap:( str ) -> str.charAt(0).toUpperCase() + str.substring(1)
  @unCap:( str ) -> str.charAt(0).toLowerCase() + str.substring(1)

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
    Util.log( Util.match_args("ex", "some text") )
    Util.log( Util.match_args("s..t", "spit") )
    Util.log( Util.match_args("^..t", "buttercup") )
    Util.log( Util.match_args("i..$", "cherries") )
    Util.log( Util.match_args("o*m", "vrooooommm!") )
    Util.log( Util.match_args("^hel*o$", "hellllllo") )

  @match_args:( regexp, text ) ->
    Util.log( regexp, text, Util.match(regexp,text) )
