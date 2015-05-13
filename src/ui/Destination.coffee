
class Destination

  Util.Export( Destination, 'ui/Destination' )

  constructor:( @app, @stream, @go, @nogo, @threshold ) ->

  ready:() ->
    @go.ready()
    @nogo.ready()
    @threshold.ready()
    @$ = $( @html() )
    @$.append( @go.$   )
    @$.append( @nogo.$      )
    @$.append( @threshold.$  )

  postReady:() ->
    @go.postReady()
    @nogo.postReady()
    @publish()
    @subscribe()

  # publish is called by
  publish:() ->
    @$destinationBody   = @$.find('#DestinationBody'  )
    @$destinationSelect = @$.find('#DestinationSelect')
    @stream.publish( 'Destination', @$destinationSelect, 'change', 'Destination', 'Destination' )

  subscribe:() ->
    @stream.subscribe( 'Destination', (object) => @selectDestination(object.content) )
    @stream.subscribe( 'Orient',      (object) => @layout(object.content) )

  selectDestination:( dest1 ) ->
    dest2 = $('#DestinationSelect').find('option:selected').text()
    Util.log( 'Destination.selectDestination()', dest1, dest2 )
    @hideBody()
    @app.doDestination( dest2 )

  id:(   name, type     ) -> @app.id(   name, type     )
  css:(  name, type     ) -> @app.css(  name, type     )
  icon:( name, type, fa ) -> @app.icon( name, type, fa )

  html:() ->
    """<div      id="#{@id('Destination')}"             class="#{@css('Destination')}">
         <div      id="#{@id('DestinationBody')}"       class="#{@css('DestinationBody')}">
          <!--div  id="#{@id('DestinationLabelInput')}" class="#{@css('DestinationLabelInput')}">
            <span  id="#{@id('DestinationUserLabel' )}" class="#{@css('DestinationUserLabel' )}">User:</span>
            <input id="#{@id('DestinationUserInput' )}" class="#{@css('DestinationUserInput' )}"type="text" name="theinput" />
          </div-->
          <div     id="#{@id('DestinationWhat')}"       class="#{@css('DestinationWhat')}">What is your</div>
          <div     id="#{@id('DestinationDest')}"       class="#{@css('DestinationDest')}">Destination?</div>
          <select  id="#{@id('DestinationSelect')}"     class="#{@css('DestinationSelect')}"name="Desinations">
            <option>Denver</option>
            <option>DIA</option>
            <option>Idaho Springs</option>
            <option>Georgetown</option>
            <option>Silverthorn</option>
            <option>Dillon</option>
            <option>Frisco</option>
            <option>Keystone</option>
            <option>Breckinridge</option>
            <option>Winter Park</option>
            <option>Copper Mtn</option>
            <option>Vail</option>
          </select>
        </div>
       </div>"""

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





