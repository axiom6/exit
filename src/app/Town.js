// Generated by CoffeeScript 1.9.1
(function() {
  var Town;

  Town = (function() {
    Util.Export(Town, 'app/Town');

    Town.roles = ['Source', 'AlongTheWay', 'Destination'];

    function Town(trip, name, role) {
      this.trip = trip;
      this.name = name;
      this.role = role;
      this.Data = Util.Import('app/Data');
      this.mile = this.Data.DestinationsMile[this.name];
    }

    return Town;

  })();

}).call(this);