(function() {
  var Game,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Game = (function() {
    function Game(ui) {
      this.finish = bind(this.finish, this);
      this.ui = ui;
    }

    Game.prototype.start = function() {
      return $.when($.get("/game/start")).done((function(_this) {
        return function() {
          return _this.play();
        };
      })(this));
    };

    Game.prototype.play = function() {
      return $.when(this.ui.displayBoardCards()).done((function(_this) {
        return function() {
          return $.when(_this.checkBoardCardsHaveSet()).done(function() {
            return _this.ui.userChooseCard();
          });
        };
      })(this));
    };

    Game.prototype.checkGameOver = function() {
      return $.getJSON("/game/end", this.ui.getPlayersDeadCardsList()).done(this.finish);
    };

    Game.prototype.finish = function(data) {
      if (data["gameOver"]) {
        return this.ui.endOfGame(data);
      } else {
        return this.switchTurn(data["currentPlayer"]);
      }
    };

    Game.prototype.switchTurn = function(currentPlayer) {
      if (currentPlayer === "computer") {
        return $.when(this.ui.userChooseCard()).done((function(_this) {
          return function() {
            return _this.checkBoardCardsHaveSet();
          };
        })(this));
      } else {
        return $.when((this.ui.computerChooseCards()).done((function(_this) {
          return function() {
            return _this.checkBoardCardsHaveSet();
          };
        })(this)));
      }
    };

    Game.prototype.restart = function() {
      return $.get("/game/restart").done((function(_this) {
        return function() {
          return $.when(_this.ui.resetBoard()).done(function() {
            return _this.start();
          });
        };
      })(this));
    };

    Game.prototype.checkBoardCardsHaveSet = function() {
      return $.getJSON("/game/rules").done(this.ui.setBoard);
    };

    Game.prototype.checkIsSet = function(chosenCards) {
      return $.post("/game/rules", {
        choice: chosenCards
      }).done(this.ui.replaceChosenCards);
    };

    return Game;

  })();

  window.Game = Game;

}).call(this);
