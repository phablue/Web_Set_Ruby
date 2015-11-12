class UI
  constructor: ->

  config: ->
    @displayBoardCards()

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

  addNewCard: (data) ->
    _.each( data["newCards"], (card) =>
      @setNewCard(@nameOf(card)) )

  setNewCard: (cardName) ->
    $("[data-id='board-cards']").append(
      "<div class='card' data-id='face-up' data-name=#{cardName}
      style='background-image: url(/images/#{cardName}.png);
             width: 190px; height: 250px'></div>")

  changeBoardCardSize: ->
    $("[data-id='face-up']").width("-=25").height("-=25")

  notice: (title, message) ->
    $("[data-id='title']").text(title)
    $("[data-id='message']").text(message)
    $("[data-id='notice']").show().fadeOut(4000)

window.UI = UI
