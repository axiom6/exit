(function() {
  var Test;

  Test = (function() {
    var obj;

    class Test {
      static toStrArgs() {
        return Util.toStrArgs('Test:', arguments);
      }

    };

    Util.Test = Test;

    Util.Export(Util.Test, 'util/Util.Test');

    obj = {};

    obj.method = function() {
      return 'Hi';
    };

    describe("Util.Test", function() {
      it("hasMethod", function() {
        return expect(Util.hasMethod(obj, 'method')).toBe(true);
      });
      it("hasGlobal", function() {
        return expect(Util.hasGlobal('Util')).toBe(true);
      });
      it("hasGlobal", function() {
        return expect(Util.getGlobal('fullScreen')).toBe(false);
      });
      it("hasPlugin", function() {
        return expect(Util.hasPlugin('Util.hasPlugin')).toBe(true);
      });
      it("hasModule", function() {
        return expect(Util.hasModule('util/Util')).toBe(true);
      });
      it("dependsOn(global)", function() {
        return expect(Util.dependsOn('jasmine')).toBe(true);
      });
      it("dependsOn(module)", function() {
        return expect(Util.dependsOn('util/Util')).toBe(true);
      });
      it("dependsOn(plugin)", function() {
        return expect(Util.dependsOn('Util.hasPlugin')).toBe(true);
      });
      it("Export Import", function() {
        Util.Export(Util, 'zzz/Util');
        return expect(true).toBe(Util.Import('zzz/Util').testTrue);
      });
      it("setModule   getModule", function() {
        Util.setModule(Util, 'yyy/Util');
        return expect(true).toBe(Util.getModule('yyy/Util').testTrue);
      });
      it("setInstance getInstance", function() {
        Util.setInstance('xx', 'xx');
        return expect('xx').toEqual(Util.getInstance('xx'));
      });
      it("toStr", function() {
        return expect(Util.toStr(null)).toEqual('null');
      });
      it("toStr", function() {
        return expect(Util.toStr('1')).toEqual('1');
      });
      it("toStr", function() {
        return expect(Util.toStr(1)).toEqual(1);
      });
      it("toStr", function() {
        return expect(Util.toStr(1.0)).toEqual(1.0);
      });
      it("toStr", function() {
        return expect(Util.toStr({
          a: 1,
          b: 2
        })).toEqual('{ a:1, b:2 }');
      });
      it("toStrStr", function() {
        return expect(Util.toStrStr('str')).toEqual('str');
      });
      it("toStrStr", function() {
        return expect(Util.toStrStr('')).toEqual('""');
      });
      it("toStrArgs", function() {
        return expect(Test.toStrArgs('a', 1, {
          a: 1,
          b: 2
        })).toEqual('Test: a 1 { a:1, b:2 } ');
      });
      it("toStrObj", function() {
        return expect(Util.toStrObj({
          a: 1,
          b: 2
        })).toEqual('{ a:1, b:2 }');
      });
      it('isDef:(d)', function() {
        return expect(Util.isDef(Util.testTrue)).toBe(true);
      });
      it('isStr:(s)', function() {
        return expect(Util.isStr('1')).toBe(true);
      });
      it('isNum:(n)', function() {
        return expect(Util.isNum(1)).toBe(true);
      });
      it('isObj:(o)', function() {
        return expect(Util.isObj({
          a: 1,
          b: 2
        })).toBe(true);
      });
      it('isObjEmpty:(o)', function() {
        return expect(Util.isObjEmpty({})).toBe(true);
      });
      it('isFunc:(f)', function() {
        return expect(Util.isFunc(Util.isFunc)).toBe(true);
      });
      it('isArray:(a)', function() {
        return expect(Util.isArray([1, 2])).toBe(true);
      });
      it('isEvent:(e)', function() {
        return expect(Util.isEvent({
          target: 1
        })).toBe(true);
      });
      it('inIndex:(a,i)', function() {
        return expect(Util.inIndex([1, 2], 1)).toBe(true);
      });
      it('inArray:(a,e)', function() {
        return expect(Util.inArray([1, 2], 1)).toBe(true);
      });
      it('atLength:(a,n)', function() {
        return expect(Util.atLength([1, 2], 2)).toBe(true);
      });
      it('head:(a)', function() {
        return expect(Util.head([1, 2])).toEqual(1);
      });
      it('tail:(a)', function() {
        return expect(Util.tail([1, 2])).toEqual(2);
      });
      it('isStrInteger:(s)', function() {
        return expect(Util.isStrInteger('1')).toBe(true);
      });
      it('isStrFloat:(s)', function() {
        return expect(Util.isStrFloat('1.0')).toBe(true);
      });
      it('isStrCurrency:(s)', function() {
        return expect(Util.isStrCurrency('1.00')).toBe(true);
      });
      it('isDefs:(d)', function() {
        return expect(Util.isDefs(1, 2)).toBe(true);
      });
      it('indent', function() {
        return expect(Util.indent(2)).toEqual('  ');
      });
      it("hashCode  stub", function() {
        return expect(true).toBe(true);
      });
      it('lastTok', function() {
        return expect(Util.lastTok('1,2', ',')).toEqual('2');
      });
      it('firstTok', function() {
        return expect(Util.firstTok('1,2', ',')).toEqual('1');
      });
      it('quicksort', function() {
        return expect(Util.quicksort([2, 3, 1])).toEqual([1, 2, 3]);
      });
      it("isoDateTime:(date) stub", function() {
        return expect(true).toBe(true);
      });
      it("toHMS:( unixTime ) stub", function() {
        return expect(true).toBe(true);
      });
      it("@hex4:() stub", function() {
        return expect(true).toBe(true);
      });
      it("hex32:() stub", function() {
        return expect(true).toBe(true);
      });
      it("toFixed stub", function() {
        return expect(true).toBe(true);
      });
      it("toInt stub", function() {
        return expect(true).toBe(true);
      });
      it("toFloat stub", function() {
        return expect(true).toBe(true);
      });
      it("match stub", function() {
        return expect(true).toBe(true);
      });
      it("match_here", function() {
        return expect(true).toBe(true);
      });
      it("@match_star stub", function() {
        return expect(true).toBe(true);
      });
      it("match_test:(date) stub", function() {
        return expect(true).toBe(true);
      });
      it("match_args:(date) stub", function() {
        return expect(true).toBe(true);
      });
      return it('parseURI', function() {
        var o;
        o = Util.parseURI("http://example.com:3000/dir1/dir2/file.ext?search=test#hash");
        expect(o.filex).toEqual(['file', 'ext']);
        expect(o.file).toEqual('file');
        return expect(o.ext).toEqual('ext');
      });
    });

    describe("Util.Test Load Modules Sttubbed", function() {
      it("verifyLoadModules stub", function() {
        return expect(true).toBe(true);
      });
      it("loadInitLibs      stub", function() {
        return expect(true).toBe(true);
      });
      it("loadModules       stub", function() {
        return expect(true).toBe(true);
      });
      it("loadModule        stub", function() {
        return expect(true).toBe(true);
      });
      return it("IdExt             stub", function() {
        return expect(true).toBe(true);
      });
    });

    describe("Util.Test UI Modules Sttubbed", function() {
      it("resize         stub", function() {
        return expect(true).toBe(true);
      });
      it("resizeTimeout  stub", function() {
        return expect(true).toBe(true);
      });
      it("isEmpty        stub", function() {
        return expect(true).toBe(true);
      });
      it("isJquery       stub", function() {
        return expect(true).toBe(true);
      });
      it("extend         stub", function() {
        return expect(true).toBe(true);
      });
      it("include        stub", function() {
        return expect(true).toBe(true);
      });
      return it("eventErrorCode stub", function() {
        return expect(true).toBe(true);
      });
    });

    return Test;

  }).call(this);

}).call(this);
