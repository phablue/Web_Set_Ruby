(function() {
  var UI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  UI = (function() {
    function UI() {
      this.replaceChosenCardsBySet = bind(this.replaceChosenCardsBySet, this);
      this.resetBoardCardsBySet = bind(this.resetBoardCardsBySet, this);
      this.displayInitialCards = bind(this.displayInitialCards, this);
      this.finishGame = bind(this.finishGame, this);
    }

    UI.prototype.config = function() {
      return this.gamePlay();
    };

    UI.prototype.gamePlay = function() {
      return $.when(this.displayBoardCards()).done((function(_this) {
        return function() {
          return $.when(_this.checkBoardCardsHasSet()).done(function() {
            return _this.chooseCard();
          });
        };
      })(this));
    };

    UI.prototype.checkGameOver = function() {
      return $.getJSON("/game/end").done(this.finishGame);
    };

    UI.prototype.finishGame = function(data) {
      if (data["gameOver"]) {
        this.notice("Game Over", "Thanks Enjoy The Game");
        return $("[data-id='board-cards'").off("click", "[data-id='face-up']");
      } else {
        return this.checkBoardCardsHasSet();
      }
    };

    UI.prototype.displayBoardCards = function() {
      return $.getJSON("/game/start").done(this.displayInitialCards);
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

    UI.prototype.chooseCard = function() {
      var chosenCards;
      chosenCards = [];
      return $("[data-id='board-cards'").on("click", "[data-id='face-up']", (function(_this) {
        return function(e) {
          var card;
          _this.changeBorderColor(e.currentTarget);
          card = $(e.currentTarget).data("name");
          chosenCards.push(card);
          if (chosenCards.length === 3) {
            _this.checkIsSet(chosenCards);
            return chosenCards = [];
          }
        };
      })(this));
    };

    UI.prototype.checkIsSet = function(chosenCards) {
      return $.post("/game/rules", {
        choice: chosenCards
      }).done(this.replaceChosenCardsBySet);
    };

    UI.prototype.replaceChosenCardsBySet = function(data) {
      data = $.parseJSON(data);
      if (data["set"]) {
        return $.when(this.notice("Set", "Switch Set Cards")).done((function(_this) {
          return function() {
            var chosenCards;
            chosenCards = data["chosenCards"];
            _this.remove(chosenCards);
            _this.recordInDisCards(chosenCards);
            return $.when(_this.addNewCard(chosenCards)).done(function() {
              return _this.checkGameOver();
            });
          };
        })(this));
      } else {
        return $.when(this.notice("No Set", "Please, Keep Look")).done((function(_this) {
          return function() {
            return _this.resetBorderColor();
          };
        })(this));
      }
    };

    UI.prototype.addNewCard = function(data) {
      if (_.isNull(data["newCards"])) {
        return _.each(data["newCards"], (function(_this) {
          return function(card) {
            return _this.setNewCard(_this.nameOf(card));
          };
        })(this));
      } else {
        return this.notice("No Cards In Deck", "");
      }
    };

    UI.prototype.setNewCard = function(cardName) {
      return $("[data-id='board-cards']").append("<div class='card' data-id='face-up' data-name=" + cardName + " style='background-image: url(/images/" + cardName + ".png); width: 190px; height: 250px'></div>");
    };

    UI.prototype.remove = function(chosenCards) {
      return _.each(chosenCards, (function(_this) {
        return function(card) {
          return $("[data-name=" + card + "]").remove();
        };
      })(this));
    };

    UI.prototype.recordInDisCards = function(chosenCards) {
      return $("[data-id='dis-card'").append("<p> " + chosenCards + " </p>");
    };

    UI.prototype.changeBorderColor = function(chosenCard) {
      return $(chosenCard).css("border", "5px solid #990100");
    };

    UI.prototype.resetBorderColor = function() {
      return $("[data-id='face-up']").css("border", "0px");
    };

    UI.prototype.changeBoardCardSize = function() {
      return $("[data-id='face-up']").width("-=25").height("-=25");
    };

    UI.prototype.notice = function(title, message) {
      $("[data-id='title']").text(title);
      $("[data-id='message']").text(message);
      if (title === "Game Over") {
        $("[data-id='notice']").show();
        return $("[data-id='message']").css("font-size", "3.0em");
      } else {
        return $("[data-id='notice']").show().fadeOut(3000);
      }
    };

    return UI;

  })();

  window.UI = UI;

}).call(this);
