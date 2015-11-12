(function() {
  var UI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  UI = (function() {
    function UI() {
      this.resetBoardCardsBySet = bind(this.resetBoardCardsBySet, this);
      this.displayInitialCards = bind(this.displayInitialCards, this);
    }

    UI.prototype.config = function() {
      return this.displayBoardCards();
    };

    UI.prototype.displayBoardCards = function() {
      return $.when($.getJSON("/game/start").done(this.displayInitialCards)).done((function(_this) {
        return function() {
          return _this.checkBoardCardsHasSet();
        };
      })(this));
    };

    UI.prototype.displayInitialCards = function(data) {
      var i;
      i = data["index"];
      return _.each(data["faceUpCards"], (function(_this) {
        return function(card) {
          var selector;
          selector = "[data-num=" + (i += 1) + "]";
          return _this.setInitialCard(selector, _this.nameOf(card));
        };
      })(this));
    };

    UI.prototype.setInitialCard = function(selector, cardName) {
      return $(selector).attr("data-name", cardName).css("background-image", "url(/images/" + cardName + ".png)");
    };

    UI.prototype.nameOf = function(card) {
      return _.values(card).join("");
    };

    UI.prototype.checkBoardCardsHasSet = function() {
      return $.getJSON("/game/rules").done(this.resetBoardCardsBySet);
    };

    UI.prototype.resetBoardCardsBySet = function(data) {
      if (!data["set"]) {
        return $.when(this.notice("No Set", "Add New Cards")).done((function(_this) {
          return function() {
            _this.addNewCard(data);
            return _this.changeBoardCardSize();
          };
        })(this));
      }
    };

    UI.prototype.addNewCard = function(data) {
      console.log("hi");
      return _.each(data["newCards"], (function(_this) {
        return function(card) {
          return _this.setNewCard(_this.nameOf(card));
        };
      })(this));
    };

    UI.prototype.setNewCard = function(cardName) {
      return $("[data-id='board-cards']").append("<div class='card' data-id='face-up' data-name=" + cardName + " style='background-image: url(/images/" + cardName + ".png); width: 190px; height: 250px'></div>");
    };

    UI.prototype.changeBoardCardSize = function() {
      return $("[data-id='face-up']").width("-=25").height("-=25");
    };

    UI.prototype.notice = function(title, message) {
      $("[data-id='title']").text(title);
      $("[data-id='message']").text(message);
      return $("[data-id='notice']").show().fadeOut(4000);
    };

    return UI;

  })();

  window.UI = UI;

}).call(this);
