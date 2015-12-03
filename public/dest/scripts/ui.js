(function() {
  var UI,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  UI = (function() {
    function UI() {
      this.replaceChosenCards = bind(this.replaceChosenCards, this);
      this.markComputerChoice = bind(this.markComputerChoice, this);
      this.setBoard = bind(this.setBoard, this);
      this.displayInitialCards = bind(this.displayInitialCards, this);
      this.game = new Game(this);
    }

    UI.prototype.config = function() {
      return this.game.start();
    };

    UI.prototype.endOfGame = function(data) {
      this.notice("Game Over", this.gameOverMessage(data["computerPoint"], data["playerPoint"]));
      $("[data-id='board-cards']").off("click", "[data-id='face-up']");
      return this.restartNewGame();
    };

    UI.prototype.getPlayersDeadCardsList = function() {
      return {
        computer: this.getDeadCardsList("computer"),
        player: this.getDeadCardsList("player")
      };
    };

    UI.prototype.getDeadCardsList = function(currentPlayer) {
      var deadCards;
      deadCards = [];
      _.each($("[data-id='dis-card-" + currentPlayer + "'] > p"), (function(_this) {
        return function(card) {
          return deadCards.push($(card).text());
        };
      })(this));
      return deadCards;
    };

    UI.prototype.restartNewGame = function() {
      return $("[data-id='restart-game']").click((function(_this) {
        return function() {
          $("[data-id='restart-game']").unbind("click");
          return _this.game.restart();
        };
      })(this));
    };

    UI.prototype.resetBoard = function() {
      $("[data-id='board-cards']").children().remove();
      $("[data-id='dis-card-computer']").children("p").remove();
      $("[data-id='dis-card-player']").children("p").remove();
      $("[data-id='turn-notice']").hide();
      $("[data-id='notice']").hide();
      return $("[data-id='restart-game']").hide();
    };

    UI.prototype.displayBoardCards = function() {
      return $.getJSON("/game/board").done(this.displayInitialCards);
    };

    UI.prototype.displayInitialCards = function(data) {
      return _.each(data["faceUpCards"], (function(_this) {
        return function(card) {
          return _this.setInitialCard(_this.nameOf(card));
        };
      })(this));
    };

    UI.prototype.setInitialCard = function(cardName) {
      return $("[data-id='board-cards']").append("<div class='card' data-id='face-up' data-name=" + cardName + " style='background-image: url(/images/" + cardName + ".png);'></div>");
    };

    UI.prototype.setBoard = function(data) {
      if (!data["set"]) {
        return $.when(this.notice("No Sets on the board", "Dealing again.")).done((function(_this) {
          return function() {
            return _this.addNewCards(data);
          };
        })(this));
      }
    };

    UI.prototype.userChooseCard = function() {
      var chosenCards;
      chosenCards = [];
      return $.when(this.turnNotice("Your turn")).done((function(_this) {
        return function() {
          return $("[data-id='board-cards']").on("click", "[data-id='face-up']", function(e) {
            var card;
            _this.changeBorderColor(e.currentTarget);
            card = $(e.currentTarget).data("name");
            if (!_.contains(chosenCards, card)) {
              chosenCards.push(card);
            }
            if (chosenCards.length === 3) {
              $("[data-id='board-cards']").off("click", "[data-id='face-up']");
              _this.game.checkIsSet(chosenCards);
              return chosenCards = [];
            }
          });
        };
      })(this));
    };

    UI.prototype.computerChooseCards = function() {
      return $.when(this.turnNotice("Comnuter turn")).done((function(_this) {
        return function() {
          return $.get("/game/computer").done(_this.markComputerChoice);
        };
      })(this));
    };

    UI.prototype.markComputerChoice = function(data) {
      var chosenCards;
      chosenCards = $.parseJSON(data)["chosenCards"];
      return $.when(_.each(chosenCards, (function(_this) {
        return function(card) {
          return $("[data-name=" + card + "]").css("border", "5px solid #F2A115");
        };
      })(this))).done((function(_this) {
        return function() {
          return _this.replaceChosenCards(data);
        };
      })(this));
    };

    UI.prototype.replaceChosenCards = function(data) {
      var def;
      data = $.parseJSON(data);
      if (data["set"]) {
        def = $.Deferred();
        this.replaceCards(data, def);
        return def.done((function(_this) {
          return function() {
            return $.when(_this.game.checkGameOver()).done(function() {
              return _this.switchTurn(data["currentPlayer"]);
            });
          };
        })(this));
      } else {
        return $.when(this.resetCards(data["currentPlayer"])).done((function(_this) {
          return function() {
            return _this.switchTurn(data["currentPlayer"]);
          };
        })(this));
      }
    };

    UI.prototype.switchTurn = function(currentPlayer) {
      if (currentPlayer === "computer") {
        return $.when(this.userChooseCard()).done((function(_this) {
          return function() {
            return _this.game.checkBoardCardsHaveSet();
          };
        })(this));
      } else {
        return $.when((this.computerChooseCards()).done((function(_this) {
          return function() {
            return _this.game.checkBoardCardsHaveSet();
          };
        })(this)));
      }
    };

    UI.prototype.replaceCards = function(data, def) {
      var chosenCards;
      chosenCards = data["chosenCards"];
      return $.when(this.notice("Set", "Dealing new cards.")).done((function(_this) {
        return function() {
          _this.removeCards(chosenCards);
          _this.recordSetCards(chosenCards, data["currentPlayer"]);
          return $.when(_this.addNewCards(data)).done(function() {
            return def.resolve();
          });
        };
      })(this));
    };

    UI.prototype.resetCards = function(currentPlayer) {
      return $.when(this.notice("No Set", "Please, keep looking")).done((function(_this) {
        return function() {
          _this.resetBorderColor();
          return _this.recordSetCards("No Set", currentPlayer);
        };
      })(this));
    };

    UI.prototype.addNewCards = function(data) {
      if (_.isEmpty(data["newCards"])) {
        return this.notice("Deck is empty", "");
      } else {
        return _.each(data["newCards"], (function(_this) {
          return function(card) {
            return _this.setNewCards(_this.nameOf(card));
          };
        })(this));
      }
    };

    UI.prototype.setNewCards = function(cardName) {
      return $("[data-id='board-cards']").append("<div class='card' data-id='face-up' data-name=" + cardName + " style='background-image: url(/images/" + cardName + ".png)'></div>");
    };

    UI.prototype.removeCards = function(chosenCards) {
      return _.each(chosenCards, (function(_this) {
        return function(card) {
          return $("[data-name=" + card + "]").remove();
        };
      })(this));
    };

    UI.prototype.recordSetCards = function(chosenCards, currentPlayer) {
      return $("[data-id='dis-card-" + currentPlayer + "'").append("<p>" + chosenCards + "</p>");
    };

    UI.prototype.nameOf = function(card) {
      return _.values(card).join("");
    };

    UI.prototype.changeBorderColor = function(chosenCard) {
      return $(chosenCard).css("border", "5px solid #990100");
    };

    UI.prototype.resetBorderColor = function() {
      return $("[data-id='face-up']").css("border", "0px");
    };

    UI.prototype.gameOverMessage = function(computer, player) {
      if (computer > player) {
        return "Computer win";
      } else if (computer < player) {
        return "Player win";
      } else {
        return "End in a draw";
      }
    };

    UI.prototype.notice = function(title, message) {
      $("[data-id='title']").text(title);
      $("[data-id='message']").text(message);
      return this.flashMessage(title);
    };

    UI.prototype.turnNotice = function(title) {
      return $("[data-id='turn-notice']").text(title).show().fadeOut(3000);
    };

    UI.prototype.flashMessage = function(title) {
      if (title === "Game Over") {
        $("[data-id='notice']").show();
        return $("[data-id='restart-game']").show();
      } else {
        return $("[data-id='notice']").show().fadeOut(3000);
      }
    };

    return UI;

  })();

  window.UI = UI;

}).call(this);
