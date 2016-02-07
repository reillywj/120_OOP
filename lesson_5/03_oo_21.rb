# Twenty-One is a card game between a player and a dealer, which utilizes the use of multiples of the standard 52 card deck. The winner is the one closest to 21 without going over.
# ---------------------
# Game Procedures
# - player places bet
# - 2 cards are dealt to each player/dealer, only one of the dealer's cards is known
# - Each player is asked to hit/stay
#   - if hit, gets another card, repeat until stay or breaks
#   - if stay move to next player
# - Dealer hits until breaks or hits at least a score of 17
# - if player beats dealer, then he receives 2x his bet, otherwise loses it
# - Next round ensues until player is out of money or walks away from the table
# ---------------------
# Nouns:
# - Player (Dealer/Human)
# - Hand (has cards)
# - Card

# Verbs:
# -hit/stay
# -bust
# -deal
# ---------------------
# Player
# -hit
# -stay
# -bust
# -bet

# Hand
# -total
# -add_card

# Card

# Deck
# -shuffle
# -reset

# Game
# -start
# ---------------------

class Player
end

class Human < Player
end

class Dealer < Player
end

class Hand
end

class Card
end

class Deck
end

class Game
end

Game.new.start
