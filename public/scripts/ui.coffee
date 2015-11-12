class UI
  constructor: ->

  config: ->
    @setBoard()

  setBoard: ->
    $.getJSON("/game/start").done(@getInitialCards)

  getInitialCards: (data) =>
    i = data["index"]

    _.each( data["faceUpCards"], (card) =>
      selector = "[data-num=#{ i += 1 }]"
      @setCard(selector, @nameOf(card))
    )

  setCard: (selector, cardName) ->
    $(selector).attr("data-name", cardName)
               .css("background-image", "url(/images/#{cardName}.png)")

  nameOf: (card) ->
    _.values(card).join("")

window.UI = UI
