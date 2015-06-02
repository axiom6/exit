
class Town

  Util.Export( Town, 'test/app/Town' )

  @roles = ['Source','AlongTheWay','Destination']

  constructor:( @trip, @name, @role ) ->
    @Data = Util.Import( 'test/app/Data')
    @mile = @Data.DestinationsMile[@name]
    #Util.dbg( 'Town mile', @mile )

