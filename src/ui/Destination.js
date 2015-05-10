// Generated by CoffeeScript 1.9.1
(function() {
  var Destination;

  Destination = (function() {
    Util.Export(Destination, 'ui/Destination');

    function Destination(app, stream, go, nogo, threshold) {
      this.app = app;
      this.stream = stream;
      this.go = go;
      this.nogo = nogo;
      this.threshold = threshold;
    }

    Destination.prototype.ready = function() {
      this.go.ready();
      this.nogo.ready();
      this.threshold.ready();
      this.$ = $(this.html());
      this.$.append(this.go.$);
      this.$.append(this.nogo.$);
      return this.$.append(this.threshold.$);
    };

    Destination.prototype.postReady = function() {
      this.go.postReady();
      this.nogo.postReady();
      return this.publish();
    };

    Destination.prototype.publish = function() {
      this.$destinationBody = this.$.find('#DestinationBody');
      this.$destinationSelect = this.$.find('#DestinationSelect');
      this.stream.publish('Destination', this.$destinationSelect, 'change', 'Destination', 'Destination');
      return this.subscribe();
    };

    Destination.prototype.subscribe = function() {
      return this.stream.subscribe('Destination', (function(_this) {
        return function(object) {
          return _this.selectDestination(object.topic);
        };
      })(this));
    };

    Destination.prototype.selectDestination = function(destArg) {
      var dest;
      dest = $('#DestinationSelect').find('option:selected').text();
      Util.log('Destination.selectDestination()', dest, destArg);
      this.hideBody();
      if (dest === 'Vail' || dest === 'Winter Park') {
        return this.nogo.show();
      } else {
        return this.go.show();
      }
    };

    Destination.prototype.id = function(name, type) {
      return this.app.id(name, type);
    };

    Destination.prototype.css = function(name, type) {
      return this.app.css(name, type);
    };

    Destination.prototype.icon = function(name, type, fa) {
      return this.app.icon(name, type, fa);
    };

    Destination.prototype.html = function() {
      return "<div      id=\"" + (this.id('Destination')) + "\"             class=\"" + (this.css('Destination')) + "\">\n  <div      id=\"" + (this.id('DestinationBody')) + "\"       class=\"" + (this.css('DestinationBody')) + "\">\n   <!--div  id=\"" + (this.id('DestinationLabelInput')) + "\" class=\"" + (this.css('DestinationLabelInput')) + "\">\n     <span  id=\"" + (this.id('DestinationUserLabel')) + "\" class=\"" + (this.css('DestinationUserLabel')) + "\">User:</span>\n     <input id=\"" + (this.id('DestinationUserInput')) + "\" class=\"" + (this.css('DestinationUserInput')) + "\"type=\"text\" name=\"theinput\" />\n   </div-->\n   <div     id=\"" + (this.id('DestinationWhat')) + "\"       class=\"" + (this.css('DestinationWhat')) + "\">What is your</div>\n   <div     id=\"" + (this.id('DestinationDest')) + "\"       class=\"" + (this.css('DestinationDest')) + "\">Destination?</div>\n   <select  id=\"" + (this.id('DestinationSelect')) + "\"     class=\"" + (this.css('DestinationSelect')) + "\"name=\"Desinations\">\n     <option>Denver</option>\n     <option>DIA</option>\n     <option>Idaho Springs</option>\n     <option>Georgetown</option>\n     <option>Silverthorn</option>\n     <option>Dillon</option>\n     <option>Frisco</option>\n     <option>Keystone</option>\n     <option>Breckinridge</option>\n     <option>Winter Park</option>\n     <option>Copper Mtn</option>\n     <option>Vail</option>\n   </select>\n </div>\n</div>";
    };

    Destination.prototype.layout = function() {};

    Destination.prototype.show = function() {
      return this.$.show();
    };

    Destination.prototype.hide = function() {
      return this.$.hide();
    };

    Destination.prototype.showBody = function() {
      return this.$destinationBody.show();
    };

    Destination.prototype.hideBody = function() {
      return this.$destinationBody.hide();
    };

    return Destination;

  })();

}).call(this);
