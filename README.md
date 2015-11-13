Web Solo Set Game
==================


Please visit [the live application](http://setcardga.me/)
----------------------------------------------------------


### About
Set is a card game where players try to find cards that match in a particular way. This application allows players to play a solitaire version of set. Only screens larger than 1024px are currently supported.

### How To Play

1. The total number of cards in the deck is 81.

2. Each card has an image on it with 4 attributes:

  * Color (red, green, or purple)
  * Shape (diamond, squiggle, or oval)
  * Shading (solid, empty, or striped)
  * Number (one, two, or three)

3. Three cards are a part of a set if, for each property, the values are all the same or all different.

  Example:
  * The cards "two red solid squiggles", "one green solid diamond", "three purple solid ovals" would make up a set. (number, shape, and color are different, shading is the same)
  * The cards "two red solid squiggles", "one green solid squiggles", "three purple solid ovals" would not make up a set, because shape is the same on two cards, but different on the third.

4. A game of Set starts by dealing 12 cards, face-up.

5. No sets on the board, three more cards are dealt.

6. A player sees three cards that make up a set, they click the cards and write on 'Sets Found' list.
   New cards are dealt from the deck to replace them.

7. The game is over when there are no cards in the deck, and no sets on the board.

### Dependencies
Please see the `package.json` and the `Gemfile` for this projects dependencies.

### Development
This application was developed in an OSX environment. The setup process should be similar for any unix-based system.

Ensure that you have ruby and the bundler gem installed. This application was developed using Ruby 2.2.3. It also requires that you have the node command line tools installed.

From the directory root:

  * `bundle install`
  * `npm install`
  * `grunt` or `grunt watch` for live reload
  * `ruby web_set.rb`
  * Navigate to `http://localhost:4567`

### Tests
The ruby components are tested using rspec. To run the tests, use the command `rspec` from the directory root. You may need to `bundle install` if you do not have `rspec` already installed.
