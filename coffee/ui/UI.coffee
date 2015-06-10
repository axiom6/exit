
class UI

  Util.Export( UI, 'ui/UI' )

  constructor:( @stream, @destinationUI, @goUI, @tripUI, @dealsUI, @navigateUI ) ->
    IconsUC         = Util.Import( 'uc/IconsUC' )
    @iconsUC        = new IconsUC( @stream, [0,0,100,10], [0,0,100,18] )
    @orientation    = 'Portrait'
    @recommendation = '?'

  ready:() ->
    @$ = $( @html() )
    $('#App').append(@$)
    @iconsUC.ready()
    @destinationUI.ready()
    @goUI.ready()
    @tripUI.ready()
    @dealsUI.ready()
    @navigateUI.ready()
    @$.append( @iconsUC.$ )
    @$view = @$.find('#View')
    @$view.append(@destinationUI.$)
    @$view.append(@goUI.$)
    @$view.append(@tripUI.$)
    @$view.append(@dealsUI.$)
    @$view.append(@navigateUI.$)
    @subscribe()
    @stream.publish( 'Icons', 'Destination' ) # We publish the first screen selection to be Destionaion

  position:(   screen ) ->
    @onScreen( screen )
    @iconsUC.position(       screen )
    @destinationUI.position( screen )
    @goUI.position(          screen )
    @tripUI.position(        screen )
    @dealsUI.position(       screen )
    @navigateUI.position(    screen )

  subscribe:() ->
    @stream.subscribe( 'Icons',  (name)   => @onIcons(  name   ) )
    @stream.subscribe( 'Screen', (screen) => @onScreen( screen ) )
    @stream.subscribe( 'Trip',   (trip)   => @onTrip(   trip   ) )

  id:(   name, type     ) -> Util.id(   name, type     )
  css:(  name, type     ) -> Util.css(  name, type     )
  icon:( name, type, fa ) -> Util.icon( name, type, fa )

  html:() ->
    """<div   id="#{@id('UI')}"   class="#{@css('UI')}">
         <div id="#{@id('View')}" class="#{@css('View')}"></div>
        </div>"""

  onTrip:( trip ) ->
    if @recommendation isnt  trip.recommendation
      @changeRecommendation( trip.recommendation )
      @recommendation =      trip.recommendation
    return

  reverseRecommendation:() ->
    if @recommendation is 'GO' then 'NO GO' else 'GO'

  reverseOrientation:() ->
    if @orientation is 'Portrait' then 'Landscape' else 'Portrait'

  changeRecommendation:( recommendation ) ->
    @onIcons( 'Recommendation' )
    faClass = if recommendation is 'GO' then 'fa fa-thumbs-up' else 'fa fa-thumbs-down'
    $icon   =  @iconsUC.$find('Recommendation')
    $icon.find('i'  ).attr( 'class', faClass )
    $icon.find('div').text(recommendation)
    @goUI.bannerUC.changeRecommendation( recommendation )
    @recommendation = recommendation
    return

  onScreen:( screen ) ->
    if @orientation isnt screen.orientation
       @orientation    = screen.orientation
       url = "css/img/app/phone6x12#{screen.orientation}.png"
       $('body').css( { "background-image":"url(#{url})" } )
       $('#App').attr( 'class', "App#{screen.orientation}" )

  onIcons:( name ) =>
    # Util.dbg( 'UI.onIcon() Beg', name, @lastSelect.$.attr('id') )
    @lastSelect.hide() if @lastSelect?
    switch name
      when 'Destination'     then @lastSelect = @destinationUI
      when 'Recommendation'  then @lastSelect = @goUI
      when 'Trip'            then @lastSelect = @tripUI
      when 'Deals'           then @lastSelect = @dealsUI
      when 'Navigate'        then @lastSelect = @navigateUI
      when 'Fork'            then @changeRecommendation( @reverseRecommendation() )
      when 'Point'           then @stream.publish( 'Screen', @toScreen(@reverseOrientation() ) )
      else
        Util.error( "UI.select unknown name", name )
    @lastSelect.show()
    return

  width: () -> @$.width()
  height:() -> @$.height()

  toScreen:( orientation ) ->
    if orientation is @orientation
      { orientation:orientation, width:@width(), height:@height() }
    else
      { orientation:orientation, width:@height(), height:@width() }



