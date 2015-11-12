class UI
  constructor: ->

  config: ->
    @gamePlay()

  gamePlay: ->
    $.when( @displayBoardCards() ).done =>
      $.when(@checkBoardCardsHasSet()).done =>
        @chooseCard()

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
    limit = 0
    chosenCards = []

    $("[data-id='board-cards'").on("click", "[data-id='face-up']", (e) =>
      limit += 1

      @changeBorderColor(e.currentTarget)

      card = $(e.currentTarget).data("name")
      chosenCards.push(card)

      if (limit) == 3
        @checkIsSet(chosenCards)
        limit = 0
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
          @checkBoardCardsHasSet()
    else
      $.when(@notice("No Set","Please, Keep Look")).done =>
        @resetBorderColor()

  addNewCard: (data) ->
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
    $("[data-id='notice']").show().fadeOut(4000)

window.UI = UI
