
Store = Util.Import( 'store/Store' )

class IndexedDB extends Store

  Util.Export( IndexedDB, 'store/Store.IndexedDB' )
  Store.IndexedDB = IndexedDB

  constructor:( uri, key  ) ->
    super( uri, key )
    @indexedDB = window.indexedDB # or window.mozIndexedDB or window.webkitIndexedDB or window.msIndexedDB
    Util.error( 'Store.IndexedDB.constructor indexedDB not found' ) if not @indexedDB
    @dbVersion   = 1
    @openDatabase( @database, @dbVersion )

  openDatabase:( database, dbVersion ) ->
    request = @indexedDB.open( database, dbVersion ) # request = @indexedDB.IDBFactory.open( database, @dbVersion )
    request.onsuccess = () =>
      @db = request.result
    request.onerror   = () =>
      Util.error( 'Store.IndexedDB.openDatabase() unable to open', { database:database, error:req.error } )

  close:() ->
    @db.close() if @db?

  txnTable:( t, mode, key=@key ) ->
    @db.transaction( t, mode ).objectStore( t, { keyPath:key } )

  add:( t, id, object ) ->
    subject = @createSubject()
    txo = @txnTable( t, "readwrite" )
    req = txo.add( obj, id )
    req.onsuccess = () => @success( { op:'add', table:t, id:id, object:object                  }, subject )
    req.onerror   = () => @onerror( { op:'add', table:t, id:id, object:object, error:req.error }, subject )
    subject

  get:( t, id ) ->
    subject = @createSubject()
    txo = @txnTable( t, "readonly" )
    req = txo.get(id) # Check to be sre that indexDB understands id
    req.onsuccess = () => @success( { op:'get', table:t, id:id, object:req.result }, subject )
    req.onerror   = () => @onerror( { op:'get', table:t, id:id,  error:req.error  }, subject )
    subject

  put:( t, id, object ) ->
    subject = @createSubject()
    txo = @txnTable( t, "readwrite" )
    req = txo.put(object) # Check to be sre that indexDB understands id
    req.onsuccess = () => @success( { op:'put', table:t, id:id, object:object                  }, subject )
    req.onerror   = () => @onerror( { op:'put', table:t, id:id, object:object, error:req.error }, subject )
    subject

  del:( t, id ) ->
    subject = @createSubject()
    txo = @txnTable( t, "readwrite" )
    req = txo['delete'](id) # Check to be sre that indexDB understands id
    req.onsuccess = () => @success( { op:'del', table:t, id:id, object:req.result }, subject )
    req.onerror   = () => @onerror( { op:'del', table:t, id:id,  error:req.error  }, subject )
    subject

  insert:( t, objects ) ->
    subject = @createSubject()
    txo = @txnTable( t, "readwrite" )
    if Util.isArray(objects)
      for object in objects
        req = txo.put(object)
    else
      for own key, object of objects
        req = txo.put(object)
    @success( { op:'insert', table:t, objects:objects }, subject )
    subject

  select:( t, where=Store.where, toArray=false ) ->
    subject = @createSubject()
    objects = if toArray then [] else {}
    @traverse( 'select', subject, t, objects, where, toArray )
    subject

  update:( t, objects ) ->
    subject = @createSubject()
    txo = @txnTable( t, "readwrite" )
    if Util.isArray(objects)
      for object in objects
        req = txo.put(object)
    else
      for own key, object of objects
        req = txo.put(object)
    subject

  remove:( t, where=Store.where ) ->
    subject = @createSubject()
    @traverse( 'remove', subject, t, {}, where, false )
    subject

  create:( t, schema ) ->
    subject = @createSubject()
    @createTable(t)
    @success( { op:'create', table:t, schema:schema  }, subject  )
    subject

  show:( t ) ->
    subject = @createSubject()
    @success( { op:'show',   table:t, tables:@tables }, subject  )
    subject

  alter:( t, alters ) ->
    subject = @createSubject()
    @success( { op:'alter',  table:t, alters:alters  }, subject  )
    subject

  drop:( t ) ->
    subject = @createSubject()
    db.deleteObjectStore(t)
    @success( { op:'drop', table:t }, subject  )
    subject

  # Subscribe to  a table or object with id
  subscribe:( t,  id=''   ) ->
    subject = @createSubject()
    @onerror( { op:'subscribe', table:t, id:id, text:"Subscribe Not implemeted by Store.IndexedDB"}, subject  )
    subject

  traverse:( op, subject, t, objects, where, toArray ) ->
    mode = if op is 'select' then 'readonly' else 'readwrite'
    txo  = @txnTable( t, mode )
    req  = txo.openCursor()
    req.onsuccess = () =>
      cursor = req.result
      if cursor
        @row( op, txo, cursor.key, cursor.object, objects, where, toArray )
        cursor.continue()
      @success( { op:op, table:t, objects:objects, where:where } )
    req.onerror   = () =>
      @onerror( { op:op, table:t, objects:objects, where:where, error:req.error } )

  row:( op, txo, key, object, objects, where, toArray ) ->
    if      op is 'select' and where(object)
      if toArray then objects.push(object) else objects[key] = object
    else if op is 'remove' and where(object)
      txo['delete']( key )



