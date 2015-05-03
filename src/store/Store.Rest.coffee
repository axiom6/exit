
Store = Util.Import( 'store/Store' )

class Rest extends Store

  Util.Export( Rest,   'store/Store.Rest' )
  Store.Rest = Rest

  constructor:( uri, key, @isCouchDB=false ) ->
    super( uri, key )
    @tables = []

  # Rest
  add:( table, id, object )  -> @ajaxRest( 'add',  table, id, object )
  get:( table, id         )  -> @ajaxRest( 'get',  table, id         )
  put:( table, id, object )  -> @ajaxRest( 'put',  table, id, object )
  del:( table, id         )  -> @ajaxRest( 'del',  table, id         )

  # Sql
  insert:( table, objects           )  -> @ajaxSql( 'insert', table, Store.where, objects )
  select:( table, where=Store.where )  -> @ajaxSql( 'select', table, where                )
  update:( table, objects           )  -> @ajaxSql( 'update', table, Store.where, objects )
  remove:( table, where=Store.where )  -> @ajaxSql( 'remove', table, where                ) # Will not work since where is not processed

  # Table - only partially implemented
  create:( table, schema=Store.schema  )  -> @ajaxTable( 'create', table, { schema:schema } )
  show:(   table=''                    )  -> @ajaxTable( 'show',   table                    )
  alter:(  table, alters=Store.alters  )  -> @ajaxTable( 'alter',  table, { alters:alters } )
  drop:(   table                       )  -> @ajaxTable( 'drop',   table                    )

  # Subscribe to  a table or object with id
  subscribe:( t,  id='' ) ->
    subject = @createSubject()
    @onerror( { op:'subscribe', table:t, id:id, text:"Subscribe Not implemeted by Store.Rest"}, subject  )
    subject

  ajaxRest:( op, table, id, object=null ) ->
    subject  = @createSubject()
    settings = { url:@url(op,table,id), type:@restOp(op), dataType:'json', processData:false, contentType:'application/json', accepts:'application/json' }
    settings.data = @toJSON(object) if object?
    settings.success = ( data,  status, jqXHR ) =>
      results = { op:op, table:table, id:id, status:status, jqXHR:jqXHR }
      results.object = @toObject(data)   if op is 'get'
      results.object = object if op is 'add' or op is 'put'
      @success(  results, subject )
    settings.error   = ( jqXHR, status, error ) =>
      errors = { op:op, table:table, id:id, jqXHR:jqXHR, status:status, error:error }
      errors.object = object if op is 'add' or op is 'put'
      @onerror( errors, subject )
    $.ajax( settings )
    subject

  ajaxSql:( op, table, where, objects=null ) ->
    subject  = @createSubject()
    settings = { url:@url(op,table), type:@restOp(op), dataType:'json', processData:false, contentType:'application/json', accepts:'application/json' }
    settings.data = objects if objects?
    settings.success = ( data,  status, jqXHR ) =>
      results = { op:op, table:table, status:status, jqXHR:jqXHR }
      results.objects = @toObjects(data,where,false) if data?    and op is 'select' # Need to get toArray through
      results.objects = objects if objects?
      results.where   = where.toString() if op is 'select' or op is 'delete'
      @success(  results, subject )
    settings.error = ( jqXHR, status, error ) =>
      errors = { op:op, table:table, jqXHR:jqXHR, status:status, error:error }
      errors.objects = objects if objects?
      results.where  = where.toString() if op is 'select' or op is 'delete'
      @onerror( errors, subject )
    $.ajax( settings )
    subject

  ajaxTable:( op, table, options ) ->
    subject  = @createSubject()
    settings = { url:@url(op,table), type:@restOp(op), dataType:'json', processData:false, contentType:'application/json', accepts:'application/json' }
    settings.success = ( data,  status, jqXHR ) =>
      results = { op:op, table:table, options:options, status:status, jqXHR:jqXHR }
      @success(  results, subject )
    settings.error = ( jqXHR, status, error ) =>
      errors = { op:op, table:table, options:options, jqXHR:jqXHR, status:status, error:error }
      @onerror( errors, subject )
    $.ajax( settings )
    subject

  url:( op, table, id='' ) ->
    if @isCouchDB
      @urlCouchDB( op, table, id )
    else
      @urlRest(    op, table, id )

  urlRest:( op, table, id='' ) ->
    switch op
      when 'add',   'get',    'put',    'del'    then @uri + '/' + table + '/' + id
      when 'insert','select', 'update', 'remove' then @uri + '/' + table
      when 'create', 'show',  'alter',  'drop'   then @uri + '/' + table
      when 'subscribe'
        if id is '' then @uri + '/' + table else @uri + '/' + table + '/' + id
      else
          Util.error( 'Store.Rest.urlRest() Unknown op', op )
          @uri + '/' + table

  urlCouchDB:( op, table, id='' ) ->
    switch op
      when 'add',   'get',    'put',    'del'    then @uri + '/' + table + '/' + id
      when 'insert','select', 'update', 'remove' then @uri + '/' + table
      when 'create', 'show',  'alter',  'drop'   then @uri + '/' + table
      when 'subscribe'
        if id is '' then @uri + '/' + table else @uri + '/' + table + '/' + id
      else
        Util.error( 'Store.Rest.urlCouchDB() Unknown op', op )
        @uri + '/' + table

  restOp:( op ) ->
    switch op
      when 'add', 'insert', 'create' then 'post'
      when 'get', 'select', 'show'   then 'get'
      when 'put', 'update', 'alter'  then 'put'
      when 'del', 'remove', 'drop'   then 'delete'
      when 'subscribe'               then 'get'
      else
        Util.error( 'Store.Rest.restOp() Unknown op', op )
        'get'

  toJSON:( obj ) ->
    if obj? then JSON.stringify(obj) else null

  toObject:( json ) ->
    if json then JSON.parse(json) else null

  toObjects:( json, where, toArray ) ->
    records = if json then JSON.parse(json)
    objects = if toArray then [] else {}
    for key, object of records when where(object)
      if toArray then objects.push(object) else objects[key] = object
    objects



