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
      this.publish();
      return this.subscribe();
    };

    Destination.prototype.publish = function() {
      this.$destinationBody = this.$.find('#DestinationBody');
      this.$destinationSelect = this.$.find('#DestinationSelect');
      return this.stream.publish('Destination', this.$destinationSelect, 'change', 'Destination', 'Destination');
    };

    Destination.prototype.subscribe = function() {
      this.stream.subscribe('Destination', (function(_this) {
        return function(object) {
          return _this.selectDestination(object.content);
        };
      })(this));
      return this.stream.subscribe('Orient', (function(_this) {
        return function(object) {
          return _this.layout(object.content);
        };
      })(this));
    };

    Destination.prototype.selectDestination = function(dest1) {
      var dest2;
      dest2 = $('#DestinationSelect').find('option:selected').text();
      Util.log('Destination.selectDestination()', dest1, dest2);
      this.hideBody();
      return this.app.doDestination(dest2);
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

    Destination.prototype.layout = function(orientation) {
      return Util.log('Destination.layout()', orientation);
    };

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
