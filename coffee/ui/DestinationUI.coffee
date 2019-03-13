
class DestinationUI

  Util.Export( DestinationUI, 'ui/DestinationUI' )

  constructor:( @stream ) ->
    ThresholdUC  = Util.Import( 'uc/ThresholdUC' )
    @thresholdUC = new ThresholdUC( @stream, 'Destin', [0,60,100,40], [ 50, 20, 50, 80]  )
    @Data = Util.Import( 'app/Data' )
    @sources = @Data.Destinations # For now we access sources     from static data
    @destins = @Data.Destinations # For now we access destins from static data
    Util.noop( @showBody, @hideBody )

  ready:() ->
    @thresholdUC.ready()
    @$ = $( @html() )
    @$.append( @thresholdUC.$  )
    @$sourceBody   = @$.find('#SourceBody'   )
    @$sourceSelect = @$.find('#SourceSelect' )
    @$destinBody   = @$.find('#DestinBody'   )
    @$destinSelect = @$.find('#DestinSelect' )

  position:(   screen ) ->
    @onScreen( screen )
    @thresholdUC.position( screen )
    @events()
    @subscribe()

  # publish is called by
  events:() ->
    @stream.event( 'Source',      {}, @$sourceSelect, 'change' )
    @stream.event( 'Destination', {}, @$destinSelect, 'change' )

  subscribe:() ->
    @stream.subscribe( 'Source', 'DestinationUI', (source) => @onSource(source) )
    @stream.subscribe( 'Destin', 'DestinationUI', (destin) => @onDestin(destin) )
    @stream.subscribe( 'Screen', 'DestinationUI', (screen) => @onScreen(screen) )

  onSource:( source ) ->
    Util.noop( 'Destin.onSource()', source )

  onDestin:( destin ) ->
    Util.noop( 'Destin.onDestin()', destin )

  id:(   name, type     ) -> Util.id(   name, type     )
  css:(  name, type     ) -> Util.css(  name, type     )
  icon:( name, type, fa ) -> Util.icon( name, type, fa )

  html:() ->
    htm = """<div      id="#{@id('DestinUI')}"         class="#{@css('DestinUI')}">
              <!--div  id="#{@id('DestinLabelInput')}" class="#{@css('DestinLabelInput')}">
                <span  id="#{@id('DestinUserLabel' )}" class="#{@css('DestinUserLabel' )}">User:</span>
                <input id="#{@id('DestinUserInput' )}" class="#{@css('DestinUserInput' )}"type="text" name="theinput" />
              </div-->
              <div      id="#{@id('SourceBody')}"    class="#{@css('SourceBody')}">
                <div    id="#{@id('SourceWhat')}"    class="#{@css('SourceWhat')}">Where are You Now?</div>
                <select id="#{@id('SourceSelect')}"  class="#{@css('SourceSelect')}" name="Sources">"""
    htm += """<option>#{source}</option>""" for source in @sources
    htm += """</select></div>
              <div     id="#{@id('DestinBody')}"     class="#{@css('DestinBody')}">
              <div     id="#{@id('DestinWhat')}"     class="#{@css('DestinWhat')}">What is your</div>
              <div     id="#{@id('DestinDest')}"     class="#{@css('DestinDest')}">Destination?</div>
              <select  id="#{@id('DestinSelect')}"   class="#{@css('DestinSelect')}" name="Destins">"""
    htm += """<option>#{destin}</option>""" for destin in @destins
    htm += """</select></div></div>"""
    htm

  onScreen:( screen ) ->
    Util.cssPosition( @$sourceBody, screen, [0, 0,100,25], [0, 0,50,40] )
    Util.cssPosition( @$destinBody, screen, [0,25,100,25], [0,40,50,40] )


  show:() -> @$.show()
  hide:() -> @$.hide()

  showBody:() -> @$destinBody.show()
  hideBody:() -> @$destinBody.hide()
