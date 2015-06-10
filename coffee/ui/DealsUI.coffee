
class DealsUI

  Util.Export( DealsUI, 'ui/DealsUI' )

  @IconSpecs = [
    { name:'Food',     css:'Icon', icon:'cutlery'    }
    { name:'Drink',    css:'Icon', icon:'glass'      }
    { name:'Lodging',  css:'Icon', icon:'bed'        }
    { name:'Shop',     css:'Icon', icon:'cart-plus'  }
    { name:'Museam',   css:'Icon', icon:'building'   }
    { name:'Hospital', css:'Icon', icon:'hospital-o' } ]

  constructor:( @stream ) ->
    SearchUC    = Util.Import( 'uc/SearchUC'  )
    IconsUC     = Util.Import( 'uc/IconsUC'   )
    DealsUC     = Util.Import( 'uc/DealsUC'   )
    @searchUC   = new SearchUC(   @stream, 'Deals',  [4, 4,92,12], [4, 4,12,92] )
    @iconsUC    = new IconsUC(    @stream, 'Search', [4,16,92,10], [16,4,10,92], DealsUI.IconSpecs, false, false )
    @dealsUC    = new DealsUC(    @stream, 'Deals',  [4,26,92,66], [26,4,66,92] )

  ready:() ->
    @searchUC.ready()
    @iconsUC.ready()
    @dealsUC.ready()
    @$ = $( @html() )
    @$.append( @searchUC.$, @iconsUC.$, @dealsUC.$ )

  position:(   screen ) ->
    @searchUC.position( screen )
    @iconsUC .position( screen )
    @dealsUC .position( screen )
    @subscribe()

  html:() ->
    """<div id="#{Util.id('DealsUI')}" class="#{Util.css('DealsUI')}"></div>"""

  show:() -> @$.show()

  hide:() -> @$.hide()

  subscribe:() ->
    @stream.subscribe( 'Trip',        (trip)        => @onTrip(trip)              )
    @stream.subscribe( 'Location',    (location)    => @onLocation(location)      )
    @stream.subscribe( 'Screen',      (screen)      => @onScreen(screen)          )
    @stream.subscribe( 'Deals',       (deals)       => @onDeals(deals)            )
    @stream.subscribe( 'Search',      (search)      => @onSearch(search)          )
    #@stream.subscribe( 'Conditions', (conditions)  => @onConditions( conditions) )

  onTrip:( trip ) ->
    Util.noop( 'Deals.onTrip()', trip )

  onLocation:( location ) ->
    Util.noop( 'DealsUI.onLocation()', @ext, location )

  onScreen:( screen ) ->
    Util.noop( 'TripUI.onScreen()', screen )

  onDeals:( deals ) ->
    Util.dbg( 'DealsUI.onDeals()', deals[0].exit )

  onSearch:( search  ) ->
    Util.dbg( 'DealsUI.onSearch()', search )

  onConditions:( conditions ) ->
    Util.noop( 'Deals.onConditions()' )


