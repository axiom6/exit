(function() {
  var DestinationUI;

  DestinationUI = (function() {
    class DestinationUI {
      constructor(stream) {
        var ThresholdUC;
        this.stream = stream;
        ThresholdUC = Util.Import('uc/ThresholdUC');
        this.thresholdUC = new ThresholdUC(this.stream, 'Destin', [0, 60, 100, 40], [50, 20, 50, 80]);
        this.Data = Util.Import('app/Data');
        this.sources = this.Data.Destinations; // For now we access sources     from static data
        this.destins = this.Data.Destinations; // For now we access destins from static data
        Util.noop(this.showBody, this.hideBody);
      }

      ready() {
        this.thresholdUC.ready();
        this.$ = $(this.html());
        this.$.append(this.thresholdUC.$);
        this.$sourceBody = this.$.find('#SourceBody');
        this.$sourceSelect = this.$.find('#SourceSelect');
        this.$destinBody = this.$.find('#DestinBody');
        return this.$destinSelect = this.$.find('#DestinSelect');
      }

      position(screen) {
        this.onScreen(screen);
        this.thresholdUC.position(screen);
        this.events();
        return this.subscribe();
      }

      // publish is called by
      events() {
        this.stream.event('Source', {}, this.$sourceSelect, 'change');
        return this.stream.event('Destination', {}, this.$destinSelect, 'change');
      }

      subscribe() {
        this.stream.subscribe('Source', 'DestinationUI', (source) => {
          return this.onSource(source);
        });
        this.stream.subscribe('Destin', 'DestinationUI', (destin) => {
          return this.onDestin(destin);
        });
        return this.stream.subscribe('Screen', 'DestinationUI', (screen) => {
          return this.onScreen(screen);
        });
      }

      onSource(source) {
        return Util.noop('Destin.onSource()', source);
      }

      onDestin(destin) {
        return Util.noop('Destin.onDestin()', destin);
      }

      id(name, type) {
        return Util.id(name, type);
      }

      css(name, type) {
        return Util.css(name, type);
      }

      icon(name, type, fa) {
        return Util.icon(name, type, fa);
      }

      html() {
        var destin, htm, i, j, len, len1, ref, ref1, source;
        htm = `<div      id="${this.id('DestinUI')}"         class="${this.css('DestinUI')}">\n<!--div  id="${this.id('DestinLabelInput')}" class="${this.css('DestinLabelInput')}">\n  <span  id="${this.id('DestinUserLabel')}" class="${this.css('DestinUserLabel')}">User:</span>\n  <input id="${this.id('DestinUserInput')}" class="${this.css('DestinUserInput')}"type="text" name="theinput" />\n</div-->\n<div      id="${this.id('SourceBody')}"    class="${this.css('SourceBody')}">\n  <div    id="${this.id('SourceWhat')}"    class="${this.css('SourceWhat')}">Where are You Now?</div>\n  <select id="${this.id('SourceSelect')}"  class="${this.css('SourceSelect')}" name="Sources">`;
        ref = this.sources;
        for (i = 0, len = ref.length; i < len; i++) {
          source = ref[i];
          htm += `<option>${source}</option>`;
        }
        htm += `</select></div>\n<div     id="${this.id('DestinBody')}"     class="${this.css('DestinBody')}">\n<div     id="${this.id('DestinWhat')}"     class="${this.css('DestinWhat')}">What is your</div>\n<div     id="${this.id('DestinDest')}"     class="${this.css('DestinDest')}">Destination?</div>\n<select  id="${this.id('DestinSelect')}"   class="${this.css('DestinSelect')}" name="Destins">`;
        ref1 = this.destins;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          destin = ref1[j];
          htm += `<option>${destin}</option>`;
        }
        htm += "</select></div></div>";
        return htm;
      }

      onScreen(screen) {
        Util.cssPosition(this.$sourceBody, screen, [0, 0, 100, 25], [0, 0, 50, 40]);
        return Util.cssPosition(this.$destinBody, screen, [0, 25, 100, 25], [0, 40, 50, 40]);
      }

      show() {
        return this.$.show();
      }

      hide() {
        return this.$.hide();
      }

      showBody() {
        return this.$destinBody.show();
      }

      hideBody() {
        return this.$destinBody.hide();
      }

    };

    Util.Export(DestinationUI, 'ui/DestinationUI');

    return DestinationUI;

  }).call(this);

}).call(this);
