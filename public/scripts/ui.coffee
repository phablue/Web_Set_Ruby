class UI
  constructor: ->

  config: ->
    @gamePlay()

  gamePlay: ->
    $.when(@displayBoardCards()).done =>
      $.when(@checkBoardCardsHasSet()).done =>
        @chooseCard()

  checkGameOver: ->
    $.getJSON("/game/end").done(@finishGame)

  finishGame: (data) =>
    if data["gameOver"]
      @notice("Game Over", "Thanks Enjoy The Game")
      $("[data-id='board-cards'").off("click", "[data-id='face-up']")
    else
      @checkBoardCardsHasSet()

  displayBoardCards: ->
    $.getJSON("/game/start").done(@displayInitialCards)

  displayInitialCards: (data) =>
    i = data["index"]

    _.each( data["faceUpCards"], (card) =>
      selector = "[data-num=#{ i += 1 }]"
      @setInitialCard(selector, @nameOf(card)) )

  setInitialCard: (selector, cardName) ->
    $(selector).attr("data-name", cardName)
               .css("background-image", "url(/images/#{cardName}.png)")

  nameOf: (card) ->
    _.values(card).join("")

  checkBoardCardsHasSet: ->
    $.getJSON("/game/rules").done(@resetBoardCardsBySet)

  resetBoardCardsBySet: (data) =>
    unless data["set"]
      $.when( @notice("No Set", "Add New Cards") ).done =>
        @addNewCard(data)
        @changeBoardCardSize()

  chooseCard: ->
    chosenCards = []

    $("[data-id='board-cards'").on("click", "[data-id='face-up']", (e) =>
      @changeBorderColor(e.currentTarget)

      card = $(e.currentTarget).data("name")
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
      $.when(@notice("Set","Switch Set Cards")).done =>
        chosenCards = data["chosenCards"]

        @remove(chosenCards)
        @recordInDisCards(chosenCards)
        $.when(@addNewCard(data)).done =>
          @checkGameOver()
    else
      $.when(@notice("No Set","Please, Keep Look")).done =>
        @resetBorderColor()

  addNewCard: (data) ->
    if _.isNull(data["newCards"])
      @notice("No Cards In Deck", "")
    else
      _.each( data["newCards"], (card) =>
        @setNewCard(@nameOf(card)) )

  setNewCard: (cardName) ->
    $("[data-id='board-cards']").append(
      "<div class='card' data-id='face-up' data-name=#{cardName}
      style='background-image: url(/images/#{cardName}.png);
             width: 190px; height: 250px'></div>")

  remove: (chosenCards) ->
    _.each(chosenCards, (card) =>
      $("[data-name=#{card}]").remove())

  recordInDisCards: (chosenCards) ->
    $("[data-id='dis-card'").append("<p> #{chosenCards} </p>")

  changeBorderColor: (chosenCard) ->
    $(chosenCard).css("border", "5px solid #990100")

  resetBorderColor: ->
    $("[data-id='face-up']").css("border", "0px")

  changeBoardCardSize: ->
    $("[data-id='face-up']").width("-=25").height("-=25")

  notice: (title, message) ->
    $("[data-id='title']").text(title)
    $("[data-id='message']").text(message)
    if title == "Game Over"
      $("[data-id='notice']").show()
      $("[data-id='message']").css("font-size", "3.0em")
    else
      $("[data-id='notice']").show().fadeOut(3000)

window.UI = UI
