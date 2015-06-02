
class UI

  Util.Export( UI, 'ui/UI' )

  constructor:( @app, @stream, @destination, @go, @nogo, @trip, @deals, @navigate ) ->
    @orientation    = 'Portrait'
    @lastSelect     = @destination

  ready:() ->
    @$ = $( @html() )
    $('#App').append(@$)
    @$view = @$.find('#View')
    @$view.append(@destination.$)
    @$view.append(@go.$)
    @$view.append(@nogo.$)
    @$view.append(@trip.$)
    @$view.append(@deals.$)
    @$view.append(@navigate.$)
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
    @publish()
    @subscribe()
    @stream.push( 'Select', 'Destination', 'UI' ) # We push the first screen selection to be Destionaion

  publish:() ->
    @stream.publish( 'Select', @$destinationIcon,    'click', 'Destination',    'UI' )
    @stream.publish( 'Select', @$recommendationIcon, 'click', 'Recommendation', 'UI' )
    @stream.publish( 'Select', @$tripIcon,           'click', 'Trip',           'UI' )
    @stream.publish( 'Select', @$dealsIcon,          'click', 'Deals',          'UI' )

  subscribe:() ->
    @stream.subscribe( 'Select', (object) => @select(object.content) )
    @stream.subscribe( 'Orient', (object) => @layout(object.content) )

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

  changeRecommendation:( recommendation ) ->
    Util.noop( 'UI.changeRecommendation', recommendation)
    @select( recommendation )
    faClass = if recommendation is 'Go' then 'fa fa-thumbs-up' else 'fa fa-thumbs-down'
    @$recommendationFA.attr( 'class', faClass )
    return

  orient:( orientation ) ->
    if orientation?
      @orientation = orientation
    else
      @orientation = if @orientation is 'Portrait' then 'Landscape' else 'Portrait'
    Util.dbg( 'UI.orient() new', @orientation )
    #@stream.push('Orient', @orientation, 'UI' )   # This push will call UI.layout() here along with all 'Oriant' subscribers
    return

  layout:( orientation ) =>
    Util.dbg( 'UI.layout', orientation )
    url = "css/img/app/phone6x12#{orientation}.png"
    $('body').css( { "background-image":"url(#{url})" } )
    $('#App').attr( 'class', "App#{orientation}" )

  show:() ->

  hide:() ->

  select:( name ) =>
    # Util.dbg( 'UI.Select() Beg', name, @lastSelect.$.attr('id') )
    @lastSelect.hide() if @lastSelect?
    switch name
      when 'Destination'
        @lastSelect = @destination
      when 'Recommendation', 'Go', 'NoGo'
        @lastSelect = if name is 'Go' then @go else @nogo
      when 'Trip'
        @lastSelect = @trip
        @orient(      'Landscape' )
        @layout(      'Landscape' )
        @trip.layout( 'Landscape' )
        @app.simulate.generateLocationsFromMilePosts( 1000 ) if @app.simulate?
      when 'Deals'
        @lastSelect = @deals
      else
        Util.error( "UI.select unknown name", name )

    # Util.dbg( 'UI.Select() End', name, @lastSelect.$.attr('id') )
    @layout( 'Portrait' ) if @orientation is 'Landscape' and name isnt 'Trip'
    @lastSelect.show()
    return

  width:()  ->
    w1 = if @$? then @$.width() else 0
    w  = 0
    if w1 is 0
      w = if @orientation is 'Portrait' then 300 else 500
    else
      w = w1
    # Util.dbg( 'UI.width()', w, w1 )
    w

  height:() ->
    h1 = if @$? then @$.height() else 0
    h  = 0
    if h1 is 0
      h = if @orientation is 'Portrait' then 500 else 300
    else
      h = h1
    # Util.dbg( 'UI.height()', h, h1 )
    h


