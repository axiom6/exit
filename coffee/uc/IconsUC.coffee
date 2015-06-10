
class IconsUC

  Util.Export( IconsUC, 'uc/IconsUC' )

  @Specs = [
    { name:'Destination',    css:'Icon', icon:'picture-o' }
    { name:'Recommendation', css:'Icon', icon:'thumbs-up' }
    { name:'Trip',           css:'Icon', icon:'road'      }
    { name:'Deals',          css:'Icon', icon:'trophy'    }
    { name:'Navigate',       css:'Icon', icon:'car'       }
    { name:'Point',          css:'Icon', icon:'compass'   }
    { name:'Fork',           css:'Icon', icon:'code-fork' } ]

  constructor:( @stream, @port, @land, @specs=IconsUC.Specs, @isHorz=true ) ->

  ready:() ->
    @$ = $( @html() )

  html:() ->
    htm = """<div   id="#{Util.id('IconsUC')}"    class="#{Util.css('IconsUC')}">
             <div   id="#{Util.id('IconsHover')}" class="#{Util.css('IconsHover')}"></div>
               <div id="#{Util.id('Icons')}"      class="#{Util.css('Icons')}">
                 <div>"""
    for spec in @specs
      htm += """<div id="#{Util.id(spec.name,'Icon')}"  class="#{Util.css(spec.css)}"><i class="fa fa-#{spec.icon}"></i><div>#{spec.name}</div></div>"""
    htm += """</div></div></div>"""
    htm

  position:(   screen ) ->
    @onScreen( screen )
    @events()
    @subscribe()
    @$Icons      = @$.find('#Icons')
    @$IconsHover = @$.find('#IconsHover')
    @$IconsHover.mouseenter( () => @$Icons.show() )
    @$Icons     .mouseleave( () => @$Icons.hide() )

  $find:( name ) ->
    @$.find('#'+name+'Icon')

  events:() ->
    for spec in @specs
      @stream.event( 'Icons', @$find(spec.name), 'click', spec.name )

  subscribe:() ->
    @stream.subscribe( 'Screen', (screen)  => @onScreen(screen)     )

  onScreen:( screen ) ->
    Util.cssPosition( @$, screen, @port, @land )
    n = @specs.length
    x = 0
    y = 0
    w = if @isHorz then 100/n else 100
    h = if @isHorz then 100   else 100/n
    for spec in @specs
      @$find(spec.name).css( { left:x+'%', top:y+'%', width:w+'%', height:h+'%'} )
      if @isHorz then x += w else y += h
    return


