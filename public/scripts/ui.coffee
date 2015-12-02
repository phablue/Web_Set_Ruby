class UI
  constructor: ->
    @game = new Game(this)

  config: ->
    @game.start()

  endOfGame: (data) ->
    @notice("Game Over", @gameOverMessage(data["computerPoint"], data["playerPoint"]))
    $("[data-id='board-cards']").off("click", "[data-id='face-up']")
    @restartNewGame()

  getPlayersDeadCardsList: ->
    { computer: @getDeadCardsList("computer"), player: @getDeadCardsList("player") }

  getDeadCardsList: (currentPlayer) ->
    deadCards = []
    _.each($("[data-id='dis-card-#{currentPlayer}'"), (card) =>
      deadCards << $(card).text()
    )
    deadCards

  restartNewGame: ->
    $("[data-id='restart-game']").click =>
      $("[data-id='restart-game']").unbind("click")
      @game.restart()

  resetBoard: ->
    $("[data-id='board-cards']").children().remove()
    $("[data-id='dis-card']").children("p").remove()
    $("[data-id='notice']").hide()
    $("[data-id='restart-game']").hide()

  displayBoardCards: ->
    $.getJSON("/game/board").done(@displayInitialCards)

  displayInitialCards: (data) =>
    _.each( data["faceUpCards"], (card) =>
      @setInitialCard(@nameOf(card)) )

  setInitialCard: (cardName) ->
    $("[data-id='board-cards']").append(
      "<div class='card' data-id='face-up' data-name=#{cardName}
            style='background-image: url(/images/#{cardName}.png);'></div>")

  setBoard: (data) =>
    unless data["set"]
      $.when( @notice("No Sets on the board", "Dealing again.") ).done =>
        @addNewCards(data)

  userChooseCard: ->
    chosenCards = []

    $.when( @turnNotice("Your turn") ).done =>
      $("[data-id='board-cards']").on("click", "[data-id='face-up']", (e) =>
        @changeBorderColor(e.currentTarget)

        card = $(e.currentTarget).data("name")
        unless _.contains(chosenCards, card)
          chosenCards.push(card)

        if (chosenCards.length) == 3
          $("[data-id='board-cards']").off("click", "[data-id='face-up']")
          @game.checkIsSet(chosenCards)
          chosenCards = []
      )

  computerChooseCards: ->
    $.when( @turnNotice("Comnuter turn") ).done =>
      $.get("/game/computer").done(@replaceChosenCards)

  replaceChosenCards: (data) =>
    data = $.parseJSON(data)

    if data["set"]
      $.when( @replaceCards(data) ).done =>
        $.when( @game.checkGameOver() ).done =>
          $.when( @game.checkBoardCardsHaveSet() ).done =>
            @switchTurn(data["currentPlayer"])
    else
      $.when( @resetCards(data["currentPlayer"]) ).done =>
         @switchTurn(data["currentPlayer"])

  switchTurn: (currentPlayer) ->
    if currentPlayer == "computer"
      @userChooseCard()
    else
      @computerChooseCards()

  replaceCards: (data) ->
    chosenCards = data["chosenCards"]

    $.when(@notice("Set","Dealing new cards.")).done =>
      @removeCards(chosenCards)
      @recordSetCards(chosenCards, data["currentPlayer"])
      @addNewCards(data)

  resetCards: (currentPlayer) ->
    $.when(@notice("No Set","Please, keep looking")).done =>
      @resetBorderColor()
      @recordSetCards("No Set", currentPlayer)

  addNewCards: (data) ->
    if _.isEmpty(data["newCards"])
      @notice("Deck is empty", "")
    else
      _.each( data["newCards"], (card) =>
        @setNewCards(@nameOf(card)) )

  setNewCards: (cardName) ->
    $("[data-id='board-cards']").append(
      "<div class='card' data-id='face-up' data-name=#{cardName}
            style='background-image: url(/images/#{cardName}.png)'></div>")

  removeCards: (chosenCards) ->
    _.each(chosenCards, (card) =>
      $("[data-name=#{card}]").remove())

  recordSetCards: (chosenCards, currentPlayer) ->
    $("[data-id='dis-card-#{currentPlayer}'").append("<p> #{chosenCards} </p>")

  nameOf: (card) ->
    _.values(card).join("")

  changeBorderColor: (chosenCard) ->
    $(chosenCard).css("border", "5px solid #990100")

  resetBorderColor: ->
    $("[data-id='face-up']").css("border", "0px")

  gameOverMessage: (computer, player) ->
    if computer > player
      "Computer win"
    else if computer < player
      "Player win"
    else
      "End in a draw"

  notice: (title, message) ->
    $("[data-id='title']").text(title)
    $("[data-id='message']").text(message)
    @flashMessage(title)

  turnNotice: (title) ->
    $("[data-id='turn-notice']").text(title).show().fadeOut(3500)

  flashMessage: (title)->
    if title == "Game Over"
      $("[data-id='notice']").show()
      $("[data-id='restart-game']").show()
    else
      $("[data-id='notice']").show().fadeOut(3000)

window.UI = UI
