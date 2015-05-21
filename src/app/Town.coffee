
class Town

  Util.Export( Town, 'app/Town' )

  @roles = ['Source','AlongTheWay','Destination']

  constructor:( @trip, @name, @role ) ->
    @Data = Util.Import( 'app/Data')
    @mile = @Data.DestinationsMile[@name]
    #Util.dbg( 'Town mile', @mile )

