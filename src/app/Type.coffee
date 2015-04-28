

class Type

  Util.Export( Type, 'mod/Type' )

  Type.typesJS = ['number','string','boolean','object','function','undefined', 'null']
  Type.typesJA = ['n',     's',     'b',      'o',    'f',        'u',         'q'   ]
  Type.typesAx = ['Array','Load','Id','Int','Float','Currency','Date','Time','Enum','Rgb','Href','Unicode','_ext']
  Type.typesAA = ['A',    'L',   'I', 'N',  'F',    'C',       'D',   'T',   'E',   'R',  'H',   'U',      '_'  ]
  Type.types   = Type.typesJS.concat( Type.typesAx )
  Type.typesa  = Type.typesJA.concat( Type.typesAA )

  @isType:( type )   -> Type.types.indexOf(type) != -1 or Type.typesa.indexOf(type) != -1
  @toType:( decl )   -> index = Schema.typesa .indexOf(decl); if index >= 0 then Type.types[index] else 'undefined'

  @typeJS:( type ) ->
    switch  type
      when 'number','Int','Float','Currency','Unicode'             then 'number'
      when 'string', 'Date','Time','Id','Enum','Rgb','Href','_ext' then 'string'
      when 'boolean'                                               then 'boolean'
      when 'object', 'Array', 'Load'                               then 'object'
      when 'function'                                              then 'function'
      else                                                              'undefined'

  @convert:( value, type ) ->
    switch type
      when 'number','Int'     then parseInt(   value )
      when 'Unicode'          then parseInt(   value, 16 )
      when 'Float','Currency' then parseFloat( value )
      when 'Date', 'Time'     then value.getTime()
      when 'Array'            then value[0]
      when 'Load'             then value
      else                         value

  @align:(  type ) ->
    switch  type
      when 'number','Int','Float','Currency','Unicode'  then 'right'
      when 'string','Date','Time','Id','Enum','_ext'    then 'left'
      when 'boolean'                                    then 'center'
      when 'object', 'Array', 'Load','Rgb'              then 'left'
      when 'function','Href'                            then 'left'
      when 'undefined','null'                           then 'left'
      else                                                   'center'

  @cell:( value, type ) ->
    switch  type
      when 'number','Int','Unicode'           then value
      when 'Float','Currency'                 then Util.toFixed(value,2)
      when 'string','Date','Time','Id','Enum' then value
      when 'boolean'                          then value
      when 'object'                           then value
      when 'Array'                            then """[#{value.join(',')}]"""
      when 'Load','_ext'                      then ""
      when 'function'                         then "function"
      when 'undefined','null','Rgb','Href'    then value
      else                                         value

  @toObjType:( obj ) ->
    ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()

  @toClass:( obj ) ->
    if obj.constructor? then obj.constructor.name else 'undefined'

  # Return and ISO formated data string
  @isoDateString:( date ) ->
    pad = (n) -> if n < 10 then '0'+n else n
    date.getUTCFullYear()  +'-'+pad(date.getUTCMonth()+1)+'-'+pad(date.getUTCDate())+'T'+
      pad(date.getUTCHours())+':'+pad(date.getUTCMinutes())+':'+pad(date.getUTCSeconds())+'Z'

  # Return a number with fixed decimal places
  @toFixed:( arg, dec ) ->
    num = switch typeof(arg)
      when 'number' then arg
      when 'string' then parseFloat(arg)
      else 0
    num.toFixed(dec)
