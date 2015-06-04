
class DestinationUI

  Util.Export( DestinationUI, 'ui/DestinationUI' )

  constructor:( @stream, @thresholdUI ) ->
    @Data = Util.Import( 'app/Data' )
    @sources      = @Data.Destinations # For now we access sources     from static data
    @destinations = @Data.Destinations # For now we access destinations from static data

  ready:() ->
    @thresholdUI.ready()
    @$ = $( @html() )
    @$.append( @thresholdUI.$  )
    @$destinationBody   = @$.find('#DestinationBody'  )
    @$sourceSelect      = @$.find('#SourceSelect'     )
    @$destinationSelect = @$.find('#DestinationSelect')

  position:(   screen ) ->
    @thresholdUI.position( screen )
    @events()
    @subscribe()

  # publish is called by
  events:() ->
    @stream.event( 'Source',      @$sourceSelect,      'change', 'Source'      )
    @stream.event( 'Destination', @$destinationSelect, 'change', 'Destination' )

  subscribe:() ->
    @stream.subscribe( 'Source',      (source)      => @onSource(source)           )
    @stream.subscribe( 'Destination', (destination) => @onDestination(destination) )
    @stream.subscribe( 'Screen',      (screen)      => @onScreen(screen)           )

  onSource:( source ) ->
    Util.noop( 'Destination.onSource()', source )

  onDestination:( destination ) ->
    Util.noop( 'Destination.onDestination()', destination )

  id:(   name, type     ) -> Util.id(   name, type     )
  css:(  name, type     ) -> Util.css(  name, type     )
  icon:( name, type, fa ) -> Util.icon( name, type, fa )

  html:() ->
    htm = """<div      id="#{@id('Destination')}"             class="#{@css('Destination')}">
             <div      id="#{@id('DestinationBody')}"         class="#{@css('DestinationBody')}">
              <!--div  id="#{@id('DestinationLabelInput')}" class="#{@css('DestinationLabelInput')}">
                <span  id="#{@id('DestinationUserLabel' )}" class="#{@css('DestinationUserLabel' )}">User:</span>
                <input id="#{@id('DestinationUserInput' )}" class="#{@css('DestinationUserInput' )}"type="text" name="theinput" />
              </div-->
              <div     id="#{@id('SourceWhat')}"            class="#{@css('SourceWhat')}">Where are You Now?</div>
              <select  id="#{@id('SourceSelect')}"          class="#{@css('SourceSelect')}"name="Sources">"""
    htm += """<option>#{source}</option>""" for source in @sources
    htm += """</select></div>
              <div     id="#{@id('DestinationWhat')}"       class="#{@css('DestinationWhat')}">What is your</div>
              <div     id="#{@id('DestinationDest')}"       class="#{@css('DestinationDest')}">Destination?</div>
              <select  id="#{@id('DestinationSelect')}"     class="#{@css('DestinationSelect')}"name="Desinations">"""
    htm += """<option>#{destination}</option>""" for destination in @destinations
    htm += """</select></div></div>"""
    htm

  onScreen:( screen ) ->
    Util.noop( 'DestinationUI.onScreen()', screen )

  show:() -> @$.show()
  hide:() -> @$.hide()

  showBody:() -> @$destinationBody.show()
  hideBody:() -> @$destinationBody.hide()





