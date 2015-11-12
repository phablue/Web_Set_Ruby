(function() {
  var UI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  UI = (function() {
    function UI() {
      this.getInitialCards = bind(this.getInitialCards, this);
    }

    UI.prototype.config = function() {
      return this.setBoard();
    };

    UI.prototype.setBoard = function() {
      return $.getJSON("/game/start").done(this.getInitialCards);
    };

    UI.prototype.getInitialCards = function(data) {
      var i;
      i = data["index"];
      return _.each(data["faceUpCards"], (function(_this) {
        return function(card) {
          var selector;
          selector = "[data-num=" + (i += 1) + "]";
          return _this.setCard(selector, _this.nameOf(card));
        };
      })(this));
    };

    UI.prototype.setCard = function(selector, cardName) {
      return $(selector).attr("data-name", cardName).css("background-image", "url(/images/" + cardName + ".png)");
    };

    UI.prototype.nameOf = function(card) {
      return _.values(card).join("");
    };

    return UI;

  })();

  window.UI = UI;

}).call(this);
