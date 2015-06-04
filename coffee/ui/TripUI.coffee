
class TripUI

  Util.Export( TripUI,   'ui/TripUI' )

  constructor:( @stream, @roadUI, @weatherUI, @advisoryUI ) ->
    @Data = Util.Import( 'app/Data' )
    @driveBarsCreated = false

  ready:() ->
    @advisoryUI.ready()
    @roadUI.ready()
    @weatherUI.ready()
    @$ = $( @html() )
    @$.append( @advisoryUI.$  )
    @$.append( @weatherUI.$   )
    @$.append( @roadUI.$      )

  position:( screen ) ->
    # Util.dbg( 'TripUI.position()', screen )
    @roadUI.position(     screen )
    @weatherUI.position(  screen )
    @advisoryUI.position( screen )
    @subscribe()

  # Trip subscribe to the full Monty of change
  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)   => @onScreen( screen ) )

  onScreen:( screen ) ->
    Util.noop( 'TripUI.onScreen()', screen )

  html:() ->
    """<div id="#{Util.id('Trip')}" class="#{Util.css('Trip')}"></div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()


