
class Destination

  Util.Export( Destination, 'ui/Destination' )

  constructor:( @app, @stream, @go, @nogo, @threshold ) ->
    @Data = Util.Import( 'app/Data' )
    @destinations = @Data.Destinations # For now we access destinations from static data

  ready:() ->
    @go.ready()
    @nogo.ready()
    @threshold.ready()
    @$ = $( @html() )
    @$.append( @go.$   )
    @$.append( @nogo.$      )
    @$.append( @threshold.$  )
    @$destinationBody   = @$.find('#DestinationBody'  )
    @$destinationSelect = @$.find('#DestinationSelect')

  postReady:() ->
    @go.postReady()
    @nogo.postReady()
    @publish()
    @subscribe()

  # publish is called by
  publish:() ->
    @stream.publish( 'Destination', @$destinationSelect, 'change', 'Destination', 'Destination' )

  subscribe:() ->
    @stream.subscribe( 'Destination', (object) => @onDestination(object.content) )
    @stream.subscribe( 'Orient',      (object) => @layout(object.content) )

  onDestination:( dest ) ->
    @hideBody()
    Util.log( 'Destination.@onDestination()', dest )

  # Superceded by @stream.publish( 'Destination', @$destinationSelect, 'change', 'Destination', 'Destination' )
  selectDestination:() ->
    dest = $('#DestinationSelect').find('option:selected').text()
    Util.log( 'Destination.selectDestination()', dest )
    @hideBody()
    @app.doDestination( dest2 )

  id:(   name, type     ) -> @app.id(   name, type     )
  css:(  name, type     ) -> @app.css(  name, type     )
  icon:( name, type, fa ) -> @app.icon( name, type, fa )

  html:() ->
    htm = """<div      id="#{@id('Destination')}"             class="#{@css('Destination')}">
             <div      id="#{@id('DestinationBody')}"       class="#{@css('DestinationBody')}">
              <!--div  id="#{@id('DestinationLabelInput')}" class="#{@css('DestinationLabelInput')}">
                <span  id="#{@id('DestinationUserLabel' )}" class="#{@css('DestinationUserLabel' )}">User:</span>
                <input id="#{@id('DestinationUserInput' )}" class="#{@css('DestinationUserInput' )}"type="text" name="theinput" />
              </div-->
              <div     id="#{@id('DestinationWhat')}"       class="#{@css('DestinationWhat')}">What is your</div>
              <div     id="#{@id('DestinationDest')}"       class="#{@css('DestinationDest')}">Destination?</div>
              <select  id="#{@id('DestinationSelect')}"     class="#{@css('DestinationSelect')}"name="Desinations">"""
    htm += """<option>#{destination}</option>""" for destination in @destinations
    htm += """</select></div></div>"""
    htm

  layout:( orientation ) ->
    Util.log( 'Destination.layout()', orientation )
    # Not needed
    #@go       .layout( orientation )
    #@nogo     .layout( orientation )
    #@threshold.layout( orientation )

  show:() -> @$.show()
  hide:() -> @$.hide()

  showBody:() -> @$destinationBody.show()
  hideBody:() -> @$destinationBody.hide()





