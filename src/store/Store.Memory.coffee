
Store = Util.Import( 'store/Store' )

class Memory extends Store

  Store.Memory = Memory
  Util.Export( Store.Memory, 'store/Store.Memory' )

  constructor:( uri, key='id', prevSession=undefined ) ->
    super( uri, key )
    @session   = @createSession( prevSession )
    @databases = @createDatabases( @session,   @database )
    @tables    = @createTables(    @databases, @database )
    @key       = 'id'

  createSession:( prevSession ) ->
    if prevSession? then prevSession  else {}

  createDatabases:( session, database ) ->
    databases = {}
    if session.databases?
      databases = session.databases
    else
      session.databases = databases
    databases[database]  = if databases.database? then databases.database else {}
    databases

  createTables:( databases, database ) ->
    tables = {}
    if databases[database].tables?
      tables = databases[database].tables
    else
      databases[database].tables = tables
    tables

  createTable:( t  ) ->
    @tables[t] = {}
    @tables[t]

  table:( t ) ->
    if @tables[t]? then @tables[t] else @createTable( t )

  add:( t, id, object  )    ->
    subject = @createSubject()
    @table(t)[id] = object
    @success( { op:'add', table:t, id:id, object:object }, subject )

  get:( t, id ) ->
    subject = @createSubject()
    object  = @table(t)[id]
    if object?
      @success( { op:'get', table:t, id:id, object:object }, subject )
    else
      @onerror( { op:'get', table:t, id:id, msg:"Id #{id} not found" }, subject )
    subject

  put:( t, id,  object ) ->
    subject = @createSubject()
    @table(t)[id] = object
    @success( { op:'put', table:t , id:id, object:object }, subject )
    subject

  del:( t, id ) ->
    subject = @createSubject()
    object  = @table(t)[id]
    if object?
      delete @table(t)[id]
      @success( { op:'del', table:t, id:id, object:object }, subject )
    else
      @onerror( { op:'del', table:t, id:id, msg:"Id #{id} not found" }, subject )
    subject

  insert:( t, objects ) ->
    subject = @createSubject()
    table   = @table(t)
    missing = []
    if Util.isArray(objects)
      for object in objects
        key = [object[@key]]
        if key? then table[key] = object else missing.push( object )
    else
      for own key, object of objects
        table[key] = object
    if missing.length eq 0
      @success( { op:'insert', table:t, objects:objects }, subject )
    else
      @onerror( { op:'insert', table:t, objects:objects, missing:missing, msg:"These objects are missing the id key:#{@key}" }, subject )
    subject

  select:( t, where, toArray=false ) ->
    subject = @createSubject()
    objects = if toArray then [] else {}
    table   = @table(t)
    for own key, object of table when where(object)
      if toArray then objects.push(object) else objects[key] = object
    @success( { op:'select', table:t, where:where.toString(), objects:objects }, subject )
    subject

  update:( t, objects ) ->
    subject = @createSubject()
    table   = @table(t)
    missObjs = []
    missRows = []
    if Util.isArray(objects)
      for object in objects
        keyObj = object[@key]
        keyRow =  table[@key]
        missObjs.push( object ) if not keyObj?
        missRows.push( object ) if not keyRow?
        table[@key] = object    if     keyObj? and keyRow?
    else
      for own key, object of objects
        keyRow =  table[@key]
        if keyRow then table[@key] = object else missRows.push( object )
    if missObjs.length eq 0 and missRows.length eq 0
      @success( { op:'update', table:t, objects:objects }, subject )
    else
      @onerror( { op:'update', table:t, objects:objects, missingObjects:missObjs, missingRows:missObjs,msg:"These objects and/or rows are missing the id key:#{@key}" }, subject )
    subject

  remove:( t, where=Store.isTrue ) ->
    subject = @createSubject()
    table   = @table(t)
    for own key, object of table when where(object)
      delete object[key]
    @success( { op:'remove', table:t, where:where.toString() }, subject )
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
    delete  @tables[t]
    @success( { op:'drop', table:t }, subject  )
    subject

  # Subscribe to  a table or object with id
  subscribe:( t,  id=''   ) ->
    subject = @createSubject()
    @onerror( { op:'subscribe', table:t, id:id, text:"Subscribe Not implemeted by Store.Memory"}, subject  )
    subject





