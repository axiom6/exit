

class Test

  Util.Test = Test
  Util.Export( Util.Test,  'util/Util.Test' )

  @toStrArgs:() -> Util.toStrArgs('Test:',arguments)

  obj = {}
  obj.method = () -> 'Hi'

  describe("Util.Test", () ->
    it("hasMethod",              () -> expect( Util.hasMethod(  obj, 'method'    ) ).toBe(true)  )
    it("hasGlobal",              () -> expect( Util.hasGlobal( 'Util'            ) ).toBe(true)  )
    it("hasGlobal",              () -> expect( Util.getGlobal( 'fullScreen'      ) ).toBe(false) )
    it("hasPlugin",              () -> expect( Util.hasPlugin( 'Util.hasPlugin'  ) ).toBe(true)  )
    it("hasModule",              () -> expect( Util.hasModule( 'util/Util'       ) ).toBe(true)  )
    it("dependsOn(global)",      () -> expect( Util.dependsOn( 'jasmine'         ) ).toBe(true)  )
    it("dependsOn(module)",      () -> expect( Util.dependsOn( 'util/Util'       ) ).toBe(true)  )
    it("dependsOn(plugin)",      () -> expect( Util.dependsOn( 'Util.hasPlugin'  ) ).toBe(true)  )

    it("Export Import",          () -> Util.Export(   Util,'zzz/Util'); expect(true).toBe( Util.Import(    'zzz/Util').testTrue ) )
    it("setModule   getModule",  () -> Util.setModule(Util,'yyy/Util'); expect(true).toBe( Util.getModule('yyy/Util').testTrue ) )
    it("setInstance getInstance",() -> Util.setInstance('xx','xx');      expect('xx').toEqual( Util.getInstance('xx') ) )
    
    it("toStr",     () -> expect( Util.toStr(null)      ).toEqual( 'null'         ) )
    it("toStr",     () -> expect( Util.toStr('1')       ).toEqual( '1'            ) )
    it("toStr",     () -> expect( Util.toStr(1)         ).toEqual( 1              ) )
    it("toStr",     () -> expect( Util.toStr(1.0)       ).toEqual( 1.0              ) )
    it("toStr",     () -> expect( Util.toStr({a:1,b:2}) ).toEqual( '{ a:1, b:2 }' ) )
    it("toStrStr",  () -> expect( Util.toStrStr('str')   ).toEqual( 'str'          ) )
    it("toStrStr",  () -> expect( Util.toStrStr('')      ).toEqual( '""'           ) )
    it("toStrArgs", () -> expect( Test.toStrArgs('a',1,{a:1,b:2}) ).toEqual( 'Test: a 1 { a:1, b:2 } ' ) )
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
    it('indent',          () -> expect( Util.indent(2)                  ).toEqual('  ') )
    it("hashCode  stub", () -> expect( true                            ).toBe(true)  )
    it('lastTok',         () -> expect( Util.lastTok('1,2',',')         ).toEqual('2') )
    it('firstTok',        () -> expect( Util.firstTok('1,2',',')        ).toEqual('1') )

    it('quicksort',               () -> expect( Util.quicksort([2,3,1])).toEqual([1,2,3]) )
    it("isoDateTime:(date) stub", () -> expect( true ).toBe(true)  )
    it("toHMS:( unixTime ) stub", () -> expect( true ).toBe(true)  )
    it("@hex4:() stub",           () -> expect( true ).toBe(true)  )
    it("hex32:() stub",           () -> expect( true ).toBe(true)  )
    it("toFixed stub",            () -> expect( true ).toBe(true)  )
    it("toInt stub",              () -> expect( true ).toBe(true)  )
    it("toFloat stub",            () -> expect( true ).toBe(true)  )
    it("match stub",              () -> expect( true ).toBe(true)  )
    it("match_here",              () -> expect( true ).toBe(true)  )
    it("@match_star stub",        () -> expect( true ).toBe(true)  )
    it("match_test:(date) stub",  () -> expect( true ).toBe(true)  )
    it("match_args:(date) stub",  () -> expect( true ).toBe(true)  )

    it('parseURI',        () ->
      o = Util.parseURI( "http://example.com:3000/dir1/dir2/file.ext?search=test#hash" )
      expect( o.filex        ).toEqual(['file','ext'])
      expect( o.file         ).toEqual( 'file')
      expect( o.ext          ).toEqual( 'ext') )
  )

  describe("Util.Test Load Modules Sttubbed", () ->
    it("verifyLoadModules stub", () -> expect( true                                ).toBe(true)  )
    it("loadInitLibs      stub", () -> expect( true                                ).toBe(true)  )
    it("loadModules       stub", () -> expect( true                                ).toBe(true)  )
    it("loadModule        stub", () -> expect( true                                ).toBe(true)  )
    it("IdExt             stub", () -> expect( true                                ).toBe(true)  )
  )

  describe("Util.Test UI Modules Sttubbed", () ->
    it("resize         stub", () -> expect( true                       ).toBe(true)  )
    it("resizeTimeout  stub", () -> expect( true                       ).toBe(true)  )
    it("isEmpty        stub", () -> expect( true                       ).toBe(true)  )
    it("isJquery       stub", () -> expect( true                       ).toBe(true)  )
    it("extend         stub", () -> expect( true                       ).toBe(true)  )
    it("include        stub", () -> expect( true                       ).toBe(true)  )
    it("eventErrorCode stub", () -> expect( true                       ).toBe(true)  )
  )
