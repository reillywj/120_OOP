# 1. Write description of the problem
#   -Tic Tac Toe
#     -Board consists of a grid: 3x3
#     -2 players take turns placing board piece
#     -Game is over when the board filled up or player lines up 3 in a row
# 2. Extract major nouns and verbs
#   -Gameboard (3x3) -> checks for game status
#   -Players: Human and Computer options -> place piece on board
#   -Players have game piece
#   -Players take turns
# 3. Organize and do exploratory programming

# Promptable
module Promptable
  def ask(question)
    puts question
  end

  def ask_inline(question)
    print question
  end

  def invalid(msg = 'entry')
    puts "Invalid #{msg}. Try again."
  end

  def clear_screen
    system 'clear'
  end
end

# Generic player defaults to randomly selecting board options
class Player
  attr_reader :mark, :name

  def initialize(name, mark)
    @name = name
    @mark = GameMarker.new(mark)
  end

  def to_s
    "#{name} (#{mark}s)"
  end

  def turn(board)
    board[board.options.sample.to_i] = mark
  end
end

# Human player chooses own positions.
class Human < Player
  include Promptable

  def turn(board)
    ask_inline "#{name}, place your piece: "
    board[select_position(board).to_i] = mark
  end

  private

  def select_position(board)
    answer = gets.chomp
    unless board.options.include? answer
      invalid 'placement'
      answer = select_position(board)
    end
    answer
  end
end

# Computer player, available for future features
class Computer < Player
end

# Gameboard holds squares
class Gameboard
  attr_reader :squares

  def initialize
    @squares = []
    (1..9).each do |position|
      @squares << Square.new(position)
    end
  end

  def to_s
    row((1..3).to_a) + divider + row((4..6).to_a) + divider + row((7..9).to_a)
  end

  def filled?
    options.empty?
  end

  def same?(pos_arr)
    marks = pos_arr.map { |pos| squares[pos - 1].mark }.uniq
    (marks.size == 1) && marks.first
  end

  def options
    squares.select { |square| square.mark.nil? }.map(&:position)
  end

  def []=(position, marker)
    squares[position - 1].mark = marker
  end

  def [](position)
    squares[position - 1]
  end

  private

  def empty_line
    ((' ' * 3) + '|') * 2 + (' ' * 3) + "\n"
  end

  def divider
    ('---+' * 2) + ('-' * 3) + "\n"
  end

  def row(pos_arr)
    empty_line +
      " #{squares[pos_arr[0] - 1]} |" +
      " #{squares[pos_arr[1] - 1]} |" +
      " #{squares[pos_arr[2] - 1]} \n" +
      empty_line
  end
end

# Square: object used to build board
class Square
  attr_reader :position
  attr_accessor :mark

  def initialize(position)
    @position = position.to_s
  end

  def to_s
    mark ? mark.to_s : position
  end

  def fill(mark)
    @mark = mark
  end

  def filled?
    !not_filled?
  end

  def not_filled?
    !mark
  end
end

# GameMarker may not be necessary but holds information on the type of marker
class GameMarker
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    marker
  end
end

# Game: Generic game setup
class Game
  include Promptable

  GAME_NAME = 'Generic Game'
  PLAYER1_MARKER = '>'
  PLAYER2_MARKER = '<'

  attr_accessor :player1, :player2, :board, :turn
  attr_reader :first_game

  def initialize(player1 = nil, player2 = nil)
    @first_game = (player1 && player2) ? false : true
    @player1 = player1 if player1
    @player2 = player2 if player2
  end

  private

  def title(str)
    puts str.center 100, '-'
  end

  def welcome
    clear_screen
    title "Let's play some #{self.class::GAME_NAME}"
  end

  def player_setup
    number = ask_number_of_players if first_game
    ask_name(number) if first_game
    reset_turn
  end

  def ask_number_of_players
    ask 'How many human players? 1 or 2.'
    answer = gets.chomp.to_i
    unless [1, 2].include? answer
      invalid 'entry'
      answer = ask_number_of_players
    end
    answer
  end

  def ask_name(number)
    case number
    when 1
      name? 'your'
      @player1 = Human.new(request_name, self.class::PLAYER1_MARKER)
      @player2 = Computer.new('R2D2', self.class::PLAYER2_MARKER)
    when 2
      name? "Player 1's"
      @player1 = Human.new(request_name, self.class::PLAYER1_MARKER)
      name? "Player 2's"
      @player2 = Human.new(request_name, self.class::PLAYER2_MARKER)
    end
  end

  def reset_turn
    self.turn = player1
  end

  def change_turns
    case turn
    when player1
      self.turn = player2
    when player2
      self.turn = player1
    end
  end

  def name?(person)
    ask "What is #{person} name?"
  end

  def request_name
    answer = gets.chomp
    if answer.empty?
      invalid 'name'
      answer = request_name
    end
    answer
  end

  def player_intro
    clear_screen
    title "#{player1} versus #{player2}"
  end

  def play(player)
    show_board
    player.turn(board)
  end

  def show_board
    puts board
  end

  def play_again?
    answer = ''
    loop do
      ask "Would you like to play your opponent again in #{GAME_NAME}? y or n"
      answer = gets.chomp.downcase
      break if %(y n).include? answer
      invalid 'selection'
    end

    case answer
    when 'y'
      self.class.new(player1, player2).start
    when 'n'
      goodbye
    end
  end

  def goodbye
    clear_screen
    title 'GAMEOVER'
    title "Thank you for playing #{self.class::GAME_NAME}"
    title 'Have a nice day!'
  end
end

# Classic game of TicTacToe
class TicTacToe < Game
  GAME_NAME = 'Object Oriented Tic Tac Toe'
  PLAYER1_MARKER = 'X'
  PLAYER2_MARKER = 'O'
  WINNING_POSITIONS = [[1, 2, 3],
                       [4, 5, 6],
                       [7, 8, 9],
                       [1, 4, 7],
                       [2, 5, 8],
                       [3, 6, 9],
                       [1, 5, 9],
                       [3, 5, 7]]

  def initialize(player1 = nil, player2 = nil)
    super
    @board = Gameboard.new
  end

  def start
    welcome
    player_setup
    until board.filled? || winning_position
      player_intro
      play(turn)
      change_turns
    end
    conclude_match
    play_again?
  end

  private

  def show_winner(position)
    winning_marker = board[position.first - 1].mark
    winning_player = case winning_marker
                     when player1.mark
                       player1
                     when player2.mark
                       player2
                     end

    title "#{winning_player} WON"
  end

  def winning_position
    winning_position = []
    WINNING_POSITIONS.each do |position|
      winning_position = position if board.same?(position)
    end
    winning_position.empty? ? nil : winning_position
  end

  def conclude_match
    clear_screen
    title 'Match Over'
    winner = winning_position
    if winner
      show_winner(winner)
    else
      puts 'Tie game.'
    end
    show_board
  end
end

TicTacToe.new.start
