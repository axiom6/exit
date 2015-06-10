
class IconsUC

  Util.Export( IconsUC, 'uc/IconsUC' )

  constructor:( @stream, @subject, @port, @land, @specs, @hover=true, @stayHorz=true ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    htm  = """<div id="#{Util.id('IconsUC',   @subject)}" class="#{Util.css('IconsUC')}">"""
    htm += """<div id="#{Util.id('IconsHover',@subject)}" class="#{Util.css('IconsHover')}"></div>""" if @hover
    htm += """<div id="#{Util.id('Icons',     @subject)}" class="#{Util.css('Icons')}"><div>"""
    for spec in @specs
      htm += """<div id="#{Util.id(spec.name,'Icon',@subject)}" class="#{Util.css(spec.css)}"><i class="fa fa-#{spec.icon}"></i><div>#{spec.name}</div></div>"""
    htm += """</div></div></div>"""
    htm

  position:(   screen ) ->
    @onScreen( screen )
    @events()
    @subscribe()
    @$Icons      = @$.find('#Icons'+@subject)
    if @hover
      @$IconsHover = @$.find('#IconsHover'+@subject)
      @$IconsHover.mouseenter( () => @$Icons.show() )
      @$Icons     .mouseleave( () => @$Icons.hide() )
    else
      @$Icons.show()

  $find:( name ) =>
    @$.find('#'+name+'Icon'+@subject)

  events:() ->
    for spec in @specs
      @stream.event( @subject, @$find(spec.name), 'click', spec.name )

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)  => @onScreen(screen)     )

  onScreen:( screen ) ->
    isHorz = if @stayHorz then true else if screen.orientation is 'Portrait' then true else false
    Util.cssPosition( @$, screen, @port, @land )
    n = @specs.length
    x = 0
    y = 0
    w = if isHorz then 100/n else 100
    h = if isHorz then 100   else 100/n
    for spec in @specs
      @$find(spec.name).css( { left:x+'%', top:y+'%', width:w+'%', height:h+'%'} )
      if isHorz then x += w else y += h
    return
