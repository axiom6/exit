
class UI

  Util.Export( UI, 'ui/UI' )

  constructor:( @stream, @destinationUI, @goUI, @tripUI, @dealsUI, @navigateUI ) ->
    @orientation    = 'Portrait'
    @recommendation = 'GO'
    @firstTrip = true

  ready:() ->
    @$ = $( @html() )
    $('#App').append(@$)
    @$view = @$.find('#View')
    @$view.append(@destinationUI.$)
    @$view.append(@goUI.$)
    @$view.append(@tripUI.$)
    @$view.append(@dealsUI.$)
    @$view.append(@navigateUI.$)
    @$IconsHover         =  @$.find('#IconsHover')
    @$Icons              =  @$.find('#Icons')
    @$destinationIcon    =  @$.find('#DestinationIcon')
    @$recommendationIcon =  @$.find('#RecommendationIcon')
    @$recommendationFA   =  @$.find('#RecommendationFA')
    @$tripIcon           =  @$.find('#TripIcon')
    @$dealsIcon          =  @$.find('#DealsIcon')
    @$namigateIcon       =  @$.find('#NavigateIcon')
    @$IconsHover.mouseenter( () => @$Icons.show() )
    @$Icons     .mouseleave( () => @$Icons.hide() )
    @events()
    @subscribe()
    @stream.publish( 'Select', 'Destination' ) # We publish the first screen selection to be Destionaion

  position:(   screen ) ->
    @onScreen( screen )

  events:() ->
    @stream.event( 'Select', @$destinationIcon,    'click', 'Destination'   )
    @stream.event( 'Select', @$recommendationIcon, 'click', @recommendation )
    @stream.event( 'Select', @$tripIcon,           'click', 'Trip',         )
    @stream.event( 'Select', @$dealsIcon,          'click', 'Deals',        )

  subscribe:() ->
    @stream.subscribe( 'Select', (page)   => @select(   page   ) )
    @stream.subscribe( 'Screen', (screen) => @onScreen( screen ) )
    @stream.subscribe( 'Trip',   (trip)   => @onTrip(   trip   ) )

  id:(   name, type     ) -> Util.id(   name, type     )
  css:(  name, type     ) -> Util.css(  name, type     )
  icon:( name, type, fa ) -> Util.icon( name, type, fa )

  html:() ->
    """<div      id="#{@id('UI')}"                     class="#{@css('UI')}">
         <div    id="#{@id('IconsHover')}"             class="#{@css('IconsHover')}"></div>
         <div    id="#{@id('Icons')}"                  class="#{@css('Icons')}">
            <div>
              <div id="#{@id('Destination',   'Icon')}"  class="#{@css('Destination',   'Icon')}"><i class="fa fa-picture-o"></i><div>Destination</div></div>
              <div id="#{@id('Recommendation','Icon')}"  class="#{@css('Recommendation','Icon')}"><i class="fa fa-thumbs-up" id="RecommendationFA"></i><div>Recommendation</div></div>
              <div id="#{@id('Trip',          'Icon')}"  class="#{@css('Trip',          'Icon')}"><i class="fa fa-road"></i><div>Trip</div></div>
              <div id="#{@id('Deals',         'Icon')}"  class="#{@css('Deals',         'Icon')}"><i class="fa fa-trophy"></i><div>Deals</div></div>
            </div>
         </div>
         <div id="#{@id('View')}" class="#{@css('View')}"></div>
        </div>"""

  onTrip:( trip ) ->
    if @recommendation isnt  trip.recommendation
      @changeRecommendation( trip.recommendation )
      @recommendation =      trip.recommendation
    else if @firstTrip
      @select( @recommendation )
      @firstTrip = false
    return

  changeRecommendation:( recommendation ) ->
    Util.noop( 'UI.changeRecommendation', recommendation)
    @select( recommendation )
    faClass = if recommendation is 'GO' then 'fa fa-thumbs-up' else 'fa fa-thumbs-down'
    @$recommendationFA.attr( 'class', faClass )
    return

  onScreen:( screen ) ->
    # Util.dbg( 'UI.onScreen()', screen )
    if @orientation isnt screen.orientation
       @orientation    = screen.orientation
       url = "css/img/app/phone6x12#{screen.orientation}.png"
       $('body').css( { "background-image":"url(#{url})" } )
       $('#App').attr( 'class', "App#{screen.orientation}" )

  show:() ->

  hide:() ->

  select:( page ) =>
    # Util.dbg( 'UI.Select() Beg', page, @lastSelect.$.attr('id') )
    @lastSelect.hide() if @lastSelect?
    switch page
      when 'Destination'
        @lastSelect = @destinationUI
      when 'GO', 'NO GO'
        @lastSelect = @goUI
      when 'Trip'
        @lastSelect = @tripUI
        @onScreen(        @toScreen('Landscape') )
        @tripUI.onScreen( @toScreen('Landscape') )
      when 'Deals'
        @lastSelect = @dealsUI
      else
        Util.error( "UI.select unknown page", page )

    # For now all screeb are Portrait except for Trip
    @onScreen( @toScreen('Portrait') ) if page isnt 'Trip'
    @lastSelect.show()
    return


  width: () -> @$.width()
  height:() -> @$.height()

  toScreen:( orientation ) ->
    if orientation is @orientation
      { orientation:orientation, width:@width(), height:@height() }
    else
      { orientation:orientation, width:@height(), height:@width() }



