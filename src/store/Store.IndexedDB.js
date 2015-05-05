// Generated by CoffeeScript 1.9.1
(function() {
  var IndexedDB, Store,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Store = Util.Import('store/Store');

  IndexedDB = (function(superClass) {
    extend(IndexedDB, superClass);

    Util.Export(IndexedDB, 'store/Store.IndexedDB');

    Store.IndexedDB = IndexedDB;

    function IndexedDB(uri, key) {
      IndexedDB.__super__.constructor.call(this, uri, key);
      this.indexedDB = window.indexedDB;
      if (!this.indexedDB) {
        Util.error('Store.IndexedDB.constructor indexedDB not found');
      }
      this.dbVersion = 1;
      this.openDatabase(this.database, this.dbVersion);
    }

    IndexedDB.prototype.openDatabase = function(database, dbVersion) {
      var request;
      request = this.indexedDB.open(database, dbVersion);
      request.onsuccess = (function(_this) {
        return function() {
          return _this.db = request.result;
        };
      })(this);
      return request.onerror = (function(_this) {
        return function() {
          return Util.error('Store.IndexedDB.openDatabase() unable to open', {
            database: database,
            error: req.error
          });
        };
      })(this);
    };

    IndexedDB.prototype.close = function() {
      if (this.db != null) {
        return this.db.close();
      }
    };

    IndexedDB.prototype.txnTable = function(t, mode, key) {
      if (key == null) {
        key = this.key;
      }
      return this.db.transaction(t, mode).objectStore(t, {
        keyPath: key
      });
    };

    IndexedDB.prototype.add = function(t, id, object) {
      var req, subject, txo;
      subject = this.createSubject();
      txo = this.txnTable(t, "readwrite");
      req = txo.add(obj, id);
      req.onsuccess = (function(_this) {
        return function() {
          return _this.success({
            op: 'add',
            table: t,
            id: id,
            object: object
          }, subject);
        };
      })(this);
      req.onerror = (function(_this) {
        return function() {
          return _this.onerror({
            op: 'add',
            table: t,
            id: id,
            object: object,
            error: req.error
          }, subject);
        };
      })(this);
      return subject;
    };

    IndexedDB.prototype.get = function(t, id) {
      var req, subject, txo;
      subject = this.createSubject();
      txo = this.txnTable(t, "readonly");
      req = txo.get(id);
      req.onsuccess = (function(_this) {
        return function() {
          return _this.success({
            op: 'get',
            table: t,
            id: id,
            object: req.result
          }, subject);
        };
      })(this);
      req.onerror = (function(_this) {
        return function() {
          return _this.onerror({
            op: 'get',
            table: t,
            id: id,
            error: req.error
          }, subject);
        };
      })(this);
      return subject;
    };

    IndexedDB.prototype.put = function(t, id, object) {
      var req, subject, txo;
      subject = this.createSubject();
      txo = this.txnTable(t, "readwrite");
      req = txo.put(object);
      req.onsuccess = (function(_this) {
        return function() {
          return _this.success({
            op: 'put',
            table: t,
            id: id,
            object: object
          }, subject);
        };
      })(this);
      req.onerror = (function(_this) {
        return function() {
          return _this.onerror({
            op: 'put',
            table: t,
            id: id,
            object: object,
            error: req.error
          }, subject);
        };
      })(this);
      return subject;
    };

    IndexedDB.prototype.del = function(t, id) {
      var req, subject, txo;
      subject = this.createSubject();
      txo = this.txnTable(t, "readwrite");
      req = txo['delete'](id);
      req.onsuccess = (function(_this) {
        return function() {
          return _this.success({
            op: 'del',
            table: t,
            id: id,
            object: req.result
          }, subject);
        };
      })(this);
      req.onerror = (function(_this) {
        return function() {
          return _this.onerror({
            op: 'del',
            table: t,
            id: id,
            error: req.error
          }, subject);
        };
      })(this);
      return subject;
    };

    IndexedDB.prototype.insert = function(t, objects) {
      var i, key, len, object, req, subject, txo;
      subject = this.createSubject();
      txo = this.txnTable(t, "readwrite");
      if (Util.isArray(objects)) {
        for (i = 0, len = objects.length; i < len; i++) {
          object = objects[i];
          req = txo.put(object);
        }
      } else {
        for (key in objects) {
          if (!hasProp.call(objects, key)) continue;
          object = objects[key];
          req = txo.put(object);
        }
      }
      this.success({
        op: 'insert',
        table: t,
        objects: objects
      }, subject);
      return subject;
    };

    IndexedDB.prototype.select = function(t, where, toArray) {
      var objects, subject;
      if (where == null) {
        where = Store.where;
      }
      if (toArray == null) {
        toArray = false;
      }
      subject = this.createSubject();
      objects = toArray ? [] : {};
      this.traverse('select', subject, t, objects, where, toArray);
      return subject;
    };

    IndexedDB.prototype.update = function(t, objects) {
      var i, key, len, object, req, subject, txo;
      subject = this.createSubject();
      txo = this.txnTable(t, "readwrite");
      if (Util.isArray(objects)) {
        for (i = 0, len = objects.length; i < len; i++) {
          object = objects[i];
          req = txo.put(object);
        }
      } else {
        for (key in objects) {
          if (!hasProp.call(objects, key)) continue;
          object = objects[key];
          req = txo.put(object);
        }
      }
      return subject;
    };

    IndexedDB.prototype.remove = function(t, where) {
      var subject;
      if (where == null) {
        where = Store.where;
      }
      subject = this.createSubject();
      this.traverse('remove', subject, t, {}, where, false);
      return subject;
    };

    IndexedDB.prototype.create = function(t, schema) {
      var subject;
      subject = this.createSubject();
      this.createTable(t);
      this.success({
        op: 'create',
        table: t,
        schema: schema
      }, subject);
      return subject;
    };

    IndexedDB.prototype.show = function(t) {
      var subject;
      subject = this.createSubject();
      this.success({
        op: 'show',
        table: t,
        tables: this.tables
      }, subject);
      return subject;
    };

    IndexedDB.prototype.alter = function(t, alters) {
      var subject;
      subject = this.createSubject();
      this.success({
        op: 'alter',
        table: t,
        alters: alters
      }, subject);
      return subject;
    };

    IndexedDB.prototype.drop = function(t) {
      var subject;
      subject = this.createSubject();
      db.deleteObjectStore(t);
      this.success({
        op: 'drop',
        table: t
      }, subject);
      return subject;
    };

    IndexedDB.prototype.subscribe = function(t, id) {
      var subject;
      if (id == null) {
        id = '';
      }
      subject = this.createSubject();
      this.onerror({
        op: 'subscribe',
        table: t,
        id: id,
        text: "Subscribe Not implemeted by Store.IndexedDB"
      }, subject);
      return subject;
    };

    IndexedDB.prototype.traverse = function(op, subject, t, objects, where, toArray) {
      var mode, req, txo;
      mode = op === 'select' ? 'readonly' : 'readwrite';
      txo = this.txnTable(t, mode);
      req = txo.openCursor();
      req.onsuccess = (function(_this) {
        return function() {
          var cursor;
          cursor = req.result;
          if (cursor) {
            _this.row(op, txo, cursor.key, cursor.object, objects, where, toArray);
            cursor["continue"]();
          }
          return _this.success({
            op: op,
            table: t,
            objects: objects,
            where: where
          });
        };
      })(this);
      return req.onerror = (function(_this) {
        return function() {
          return _this.onerror({
            op: op,
            table: t,
            objects: objects,
            where: where,
            error: req.error
          });
        };
      })(this);
    };

    IndexedDB.prototype.row = function(op, txo, key, object, objects, where, toArray) {
      if (op === 'select' && where(object)) {
        if (toArray) {
          return objects.push(object);
        } else {
          return objects[key] = object;
        }
      } else if (op === 'remove' && where(object)) {
        return txo['delete'](key);
      }
    };

    return IndexedDB;

  })(Store);

}).call(this);