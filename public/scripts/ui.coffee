class UI
  constructor: ->

  config: ->
    @gameStart()

  gameStart: ->
    $.when($.get("/game/start")).done =>
      @gamePlay()

  gamePlay: ->
    $.when(@displayBoardCards()).done =>
      $.when(@checkBoardCardsHasSet()).done =>
        @chooseCard()

  checkGameOver: ->
    $.getJSON("/game/end").done(@finishGame)

  restartNewGame: ->
    $("[data-id='restart-game']").click =>
      $("[data-id='restart-game']").unbind("click")
      $.get("/game/restart").done =>
        $.when(@resetGame()).done =>
          @gameStart()

  resetGame: ->
    $("[data-id='board-cards']").children().remove()
    $("[data-id='dis-card']").children("p").remove()
    $("[data-id='notice']").hide()
    $("[data-id='restart-game']").hide()

  finishGame: (data) =>
    if data["gameOver"]
      @notice("Game Over", "Thanks for playing.")
      $("[data-id='board-cards']").off("click", "[data-id='face-up']")
      @restartNewGame()
    else
      @checkBoardCardsHasSet()

  displayBoardCards: ->
    $.getJSON("/game/board").done(@displayInitialCards)

  displayInitialCards: (data) =>
    _.each( data["faceUpCards"], (card) =>
      @setInitialCard(@nameOf(card)) )

  setInitialCard: (cardName) ->
    $("[data-id='board-cards']").append(
      "<div class='card' data-id='face-up' data-name=#{cardName}
            style='background-image: url(/images/#{cardName}.png);'></div>")

  nameOf: (card) ->
    _.values(card).join("")

  checkBoardCardsHasSet: ->
    $.getJSON("/game/rules").done(@resetBoardCardsBySet)

  resetBoardCardsBySet: (data) =>
    unless data["set"]
      $.when( @notice("No Sets on the board", "Dealing again.") ).done =>
        @addNewCard(data)

  chooseCard: ->
    chosenCards = []

    $("[data-id='board-cards']").on("click", "[data-id='face-up']", (e) =>
      @changeBorderColor(e.currentTarget)

      card = $(e.currentTarget).data("name")
      unless _.contains(chosenCards, card)
        chosenCards.push(card)

      if (chosenCards.length) == 3
        @checkIsSet(chosenCards)
        chosenCards = []
    )

  checkIsSet: (chosenCards) ->
    $.post("/game/rules", { choice: chosenCards }).done(@replaceChosenCardsBySet)

  replaceChosenCardsBySet: (data) =>
    data = $.parseJSON(data)

    if data["set"]
      $.when(@notice("Set","Dealing new cards.")).done =>
        chosenCards = data["chosenCards"]

        @remove(chosenCards)
        @recordInDisCards(chosenCards)
        $.when(@addNewCard(data)).done =>
          @checkGameOver()
    else
      $.when(@notice("No Set","Please, keep looking")).done =>
        @resetBorderColor()

  addNewCard: (data) ->
    if _.isNull(data["newCards"])
      @notice("Deck is empty", "")
    else
      _.each( data["newCards"], (card) =>
        @setNewCard(@nameOf(card)) )

  setNewCard: (cardName) ->
    $("[data-id='board-cards']").append(
      "<div class='card' data-id='face-up' data-name=#{cardName}
            style='background-image: url(/images/#{cardName}.png);
                   width: 140px; height: 200px'></div>")

  remove: (chosenCards) ->
    _.each(chosenCards, (card) =>
      $("[data-name=#{card}]").remove())

  recordInDisCards: (chosenCards) ->
    $("[data-id='dis-card'").append("<p> #{chosenCards} </p>")

  changeBorderColor: (chosenCard) ->
    $(chosenCard).css("border", "5px solid #990100")

  resetBorderColor: ->
    $("[data-id='face-up']").css("border", "0px")

  notice: (title, message) ->
    $("[data-id='title']").text(title)
    $("[data-id='message']").text(message)
    @flashMessage(title)

  flashMessage: (title)->
    if title == "Game Over"
      $("[data-id='notice']").show()
      $("[data-id='restart-game']").show()
    else
      $("[data-id='notice']").show().fadeOut(3000)

window.UI = UI
