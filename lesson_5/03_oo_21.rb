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
require 'pry'

module Promptable
  SCREEN_SIZE = 90

  def clear
    system 'clear'
  end

  def title(msg)
    puts msg.center SCREEN_SIZE, '-'
  end

  def ask(question)
    puts "Q: #{question}"
  end

  def warning(msg)
    puts msg.center SCREEN_SIZE, '!***'
  end

  def press_enter_for_next
    title 'press ENTER when ready'
    gets.chomp
    nil
  end

  def end_turn_for(player)
    clear
    title "End of #{player}'s Turn"
    status_report = player.stay? ? :stayed : player.status
    puts "#{player} #{status_report} with #{player.total} (#{player.hand})"
    press_enter_for_next
  end

  def ask_question(question, valid_arr)
    get_correct_answer(question) do |ans|
      'Invalid entry. Try again.' unless valid_arr.include?(ans.downcase! || ans)
    end
  end

  def ask_question_numeric_response(question)
    get_correct_answer(question) do |answer|
      msg = ''
      if answer.empty?
        msg += 'Cannot be empty.'
      end

      if answer != answer.to_i.to_s
        msg += warning_msg(msg, 'Must be a number.')
      elsif answer.to_i < 0
        msg += warning_msg(msg, 'Must be greater than 0.')
      end

      msg.empty? ? nil : msg
    end
  end

  def ask_question_not_empty(question)
    get_correct_answer(question) do |answer|
      'Must provide a name.' if answer.empty?
    end
  end

  private

  def get_correct_answer(question)
    answer = nil
    loop do
      ask question
      answer = gets.chomp
      error_message = yield answer
      break unless error_message
      warning error_message
    end
    answer
  end

  def warning_msg(msg, warning)
    "#{' ' unless msg.empty?}#{warning}"
  end
end

module CardPlayer
  def show
    "#{self} has #{hand} totaling #{hand.total}"
  end

  def stay?
    status == :stay
  end

  def busted?
    if hand.busted?
      @status = :busted
    end
  end

  def show_one_card
    hand.show_one_card
  end

  def busted_hand?
    hand.busted?
  end

  def total
    hand.total
  end

  def reset
    hand.clear
  end
end

class Player
  attr_reader :name, :hand, :status
  include CardPlayer

  def initialize
    @hand = Hand.new(self)
    @status = :bet
  end

  def to_s
    name
  end
end

class Human < Player
  include Promptable
  @@count = 0

  def initialize
    @@count += 1
    super
    @name = ask_for_name
  end

  def self.count
    @@count
  end

  def ask_for_name
    ask_question_not_empty("Player #{@@count}, what is your name?")
  end

  def turn
    @status = ask_question('Hit or stay?', %w(hit stay)).downcase.to_sym
  end

  def show_final(dealer)
    final_score = total
    dealer_score = dealer.total

    if busted?
      puts "#{self} busted. And lost."
    elsif dealer.busted?
      puts "Dealer busted. #{self} won."
    elsif final_score > dealer_score
      puts "#{compare_scores(dealer)}. #{self} won!"
    elsif final_score == dealer_score
      puts "#{compare_scores(dealer)}. Tie."
    else
      puts "#{compare_scores dealer}. #{self} lost."
    end
  end

  def compare_scores(dealer)
    "#{self}: #{total} v. #{dealer}: #{dealer.total}"
  end
end

class Dealer < Player
  attr_reader :deck
  STAY_LIMIT = 17

  def initialize
    super
    @name = 'Dealer'
    @deck = Deck.new
  end

  def deal_to(player)
    player.hand << deck.deal_card
  end

  def turn(players)
    @status = within_limit? ? :hit : :stay
    @status = all_players_busted?(players) ? :stay : @status
    unless stay?
      sleep 1
      puts 'dealing...'
      sleep 1
    end
  end

  def within_limit?
    hand.total < STAY_LIMIT
  end

  def reset
    super
    deck.reset
  end

  private

  def all_players_busted?(players)
    statuses = players.map(&:status)
    statuses.count(:bust) == players.size
  end
end

class Hand
  attr_reader :player, :cards
  GAME_SCORE = 21

  def initialize(player)
    @player = player
    clear
  end

  def clear
    @cards = []
  end

  def <<(card)
    @cards << card
  end

  def show_one_card
    str = ''
    cards.each_with_index do |card, index|
      if index == 0
        str += card.show
      else
        str += ", #{card.show_blank}"
      end
    end
    str
  end

  def show
    str = ''
    cards.each_with_index do |card, index|
      if index == 0
        str += card.show
      elsif index == cards.size - 1
        str += " and #{card.show}"
      else
        str += ", #{card.show}"
      end
    end
    str
  end

  def to_s
    show
  end

  def total
    faces = cards.map(&:face)
    aces = faces.count 'A'
    total = 0
    faces.each { |face| total += standard_value face }
    aces.times do
      total -= 10 if total > GAME_SCORE
    end
    total
  end

  def busted?
    total > GAME_SCORE
  end

  private

  def standard_value(face)
    if %w(K Q J).include? face
      10
    elsif face == 'A'
      11
    else
      face.to_i
    end
  end
end

class Card
  attr_reader :face, :suit

  def initialize(face, suit)
    @face = face
    @suit = suit
  end

  def show
    "#{face} of #{suit}"
  end

  def show_blank
    "? of ?"
  end
end

class Deck
  FACES = %w(A K Q J 10 9 8 7 6 5 4 3 2)
  SUITS = %w(H D S C)
  DECK_COUNT = 1

  attr_reader :cards

  def initialize
    reset
  end

  def shuffle
    cards.shuffle!
  end

  def reset
    @cards = []
    DECK_COUNT.times do
      FACES.each do |face|
        SUITS.each do |suit|
          @cards << Card.new(face, suit)
        end
      end
    end
    shuffle
  end

  def deal_card
    @cards.pop
  end
end

class Game
  include Promptable
  attr_reader :dealer, :players

  GAME_NAME = 'Object Oriented 21'

  def initialize
    @players = []
    @dealer = Dealer.new
  end

  def start
    welcome
    number_of_players = ask_number_of_players.to_i
    create_players(number_of_players)
    loop do
      gameplay
      break unless %w(y yes).include? ask_to_play_again
      clear_table_and_reset
    end
    gameover
  end

  private

  def gameplay
    deal_cards
    players_take_turns
    dealer_takes_turn
    game_summary
  end

  def welcome
    clear
    title "Welcome to #{GAME_NAME}"
  end

  def ask_number_of_players
    ask_question_numeric_response('How many players?')
  end

  def create_players(number)
    number.times do
      clear
      title "Player #{Human.count + 1}"
      @players << Human.new
    end
  end

  def deal_cards
    2.times do
      players.each { |player| dealer.deal_to player }
      dealer.deal_to dealer
    end
  end

  def players_take_turns
    players.each do |player|
      turn player
    end
  end

  def turn(player)
    loop do
      clear
      title "#{player}'s Turn"
      puts dealer.show_one_card
      show_hand player
      player.turn
      case player.status
      when :stay
        end_turn_for player
        break
      when :hit
        dealer.deal_to player
        if player.busted?
          end_turn_for player
          break
        end
      end
    end
  end

  def dealer_takes_turn
    loop do
      show_hand dealer
      dealer.turn(players)
      case dealer.status
      when :stay
        press_enter_for_next
        break
      when :hit
        dealer.deal_to dealer
        break if dealer.busted?
      end
    end
  end

  def show_hand(player)
    puts player.show
  end

  def game_summary
    clear
    title 'SUMMARY'
    players.each { |player| puts player.show_final(dealer) }
    puts dealer.show
    press_enter_for_next
  end

  def gameover
    # clear
    title "Thank you for playing #{GAME_NAME}"
    title 'GAMEOVER'
  end

  def ask_to_play_again
    ask_question 'Would you like to play again?', %w(y yes n no)
  end

  def clear_table_and_reset
    dealer.reset
    players.each(&:reset)
  end
end

Game.new.start








































