
class Destination

  Util.Export( Destination, 'ui/Destination' )

  constructor:( @app, @stream, @go, @nogo, @threshold ) ->

  ready:() ->
    @go.ready()
    @nogo.ready()
    @threshold.ready()
    @$ = $( @html() )
    Util.log( 'Go Id', @go.$.attr('id') )
    @$.append( @go.$   )
    @$.append( @nogo.$      )
    @$.append( @threshold.$  )

  postReady:() ->
    @go.postReady()
    @nogo.postReady()
    @publish()

  # publish is called by
  publish:() ->
    @$destinationBody   = @$.find('#DestinationBody'  )
    @$destinationSelect = @$.find('#DestinationSelect')
    @stream.publish( 'Destination', @$destinationSelect, 'change', 'Destination', 'Destination' )
    @subscribe()

  subscribe:() ->
    @stream.subscribe( 'Destination', (object) => @selectDestination(object.topic) )

  selectDestination:( destArg ) ->
    dest = $('#DestinationSelect').find('option:selected').text()
    Util.log( 'Destination.selectDestination()', dest, destArg )
    @hideBody()
    if dest is 'Vail' or dest is 'Winter Park'
      @nogo.show()
    else
      @go.show()

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

  layout:() ->

  show:() -> @$.show()
  hide:() -> @$.hide()

  showBody:() -> @$destinationBody.show()
  hideBody:() -> @$destinationBody.hide()