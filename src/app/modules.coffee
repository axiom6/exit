
root   =   "../../"                       # Rootdirectory
paths  =
  bower:  "lib/"+"bower_components/" # Core      libraries from bower_components
  node:   "lib/"+"node_modules/"     # Core      libraries from node_modules
  src:    "src/"                     # This app's src module directory
  css:    "css/"
  img:    "img/"
  htm:    "htm/"

# "es6-promise/promise",

libs =
  "paths"      : { "bower":paths.bower, "node":paths.node, "src":paths.src }
  "bower"      : [ "jquery/dist/jquery", "jquery.gritter/js/jquery.gritter",
                   "director/build/director.min", "d3/d3", "underscore/underscore" ],
  "node"       : [],
  "src"        : [ "mod/Type", "app/App", "build/Build", "visual/Visual", "ui/UI", "prac/Prac", "doc/Doc", "store/Store" ],
  "testOn"     :   false

init = () ->

  $(document).ready ->

    Util.init()
    name        = $('body').attr('data-app')
    App         = Util.Import( 'app/App'     )
    App.Build   = Util.Import( 'build/Build' )
    App.UI      = Util.Import( 'ui/UI'       )
    App.UI.Prac = Util.Import( 'prac/Prac'   )
    App.Doc     = Util.Import( 'doc/Doc'     )
    App.Store   = Util.Import( 'store/Store' )

    build = new App.Build( name )  # Build App by processing the specs in the Build module based on 'name'
    app   = new App( build )
    ui    = new App.UI(   app )
    doc   = new App.Doc(  app )
    store = new App.Store( 'Memory', 'www.axiom6.com/database', 'table' )

    app.ready()
    ui.ready()
    doc.ready()
    app.selectPlane('Information')

    return

  return

Util.dependsOn('yepnope')  # yepnope 1.
Util.loadInitLibs( root, paths, libs, init )
