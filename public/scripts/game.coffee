class Game
  constructor: (ui) ->
    @ui = ui

  start: ->
    $.when( $.get("/game/start") ).done =>
      @play()

  play: ->
    $.when( @ui.displayBoardCards() ).done =>
      $.when( @checkBoardCardsHaveSet() ).done =>
        @ui.userChooseCard()

  checkGameOver: ->
    $.getJSON("/game/end", @ui.getPlayersDeadCardsList()).done(@finish)

  finish: (data) =>
    @ui.endOfGame(data) if data["gameOver"]

  restart: ->
    $.get("/game/restart").done =>
      $.when(@ui.resetBoard()).done =>
        @start()

  checkBoardCardsHaveSet: ->
    $.getJSON("/game/rules").done(@ui.setBoard)

  checkIsSet: (chosenCards) ->
    $.post("/game/rules", { choice: chosenCards }).done(@ui.replaceChosenCards)

window.Game = Game
