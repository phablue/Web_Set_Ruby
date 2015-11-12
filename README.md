Web Solo Set Game
==================

### About
Set is a card game where players try to find cards that match in a particular way. This application allows players to play a solitaire version of set. Only screens larger than 1024px are currently supported.

### How To Play

1. The total number of cards in the deck is 81. 1

2. Each card has an image on it with 4 attributes: 2

  * Color (red, green, or purple) 2.a
  * Shape (diamond, squiggle, or oval) 2.b
  * Shading (solid, empty, or striped) 2.c
  * Number (one, two, or three) 2.d

3. Three cards are a part of a set if, for each property, the values are all the same or all different. 3

  Example:
  * The cards "two red solid squiggles", "one green solid diamond", "three purple solid ovals" would make up a set. (number, shape, and color are different, shading is the same) 3.a
  * The cards "two red solid squiggles", "one green solid squiggles", "three purple solid ovals" would not make up a set, because shape is the same on two cards, but different on the third. 3.c

4. A game of Set starts by dealing 12 cards, face-up. 4

5. No sets on the board, three more cards are dealt. 5

6. A player sees three cards that make up a set, they click the cards and write on 'Sets Found' list.
   New cards are dealt from the deck to replace them. 6

7. The game is over when there are no cards in the deck, and no sets on the board. 7

### Dependencies
Please see the `package.json` and the `Gemfile` for this projects dependencies.

### Development
This application was developed in an OSX environment. The setup process should be similar for any unix-based system.

Ensure that you have ruby and the bundler gem installed. This application was developed using Ruby 2.2.3.

From the directory root, you will need to perform a `bundle install`. This will install the required packages to run the tests and the local development server.

You will also need to install the javascript packages by using `npm install`. This requires that you have the node package manger tools on your system.

After installing the dependencies, you will need to compile the coffeescript and sass files. To do this, use the `grunt` command from the root directory. If you would like to use the `watch` command, which enables live reload for your assets, use the `grunt watch` command.

To start the server, navigate to the directory root, and enter `ruby web_set.rb`. This will start a development server on your local machine. You should now be able to navigate to `localhost:4567` and see the application.

### Tests
The ruby components are tested using rspec. To run the tests, use the command `rspec` from the directory root. You may need to `bundle install` if you do not have `rspec` already installed.
