=begin
1. Write description of the problem
  -Tic Tac Toe
    -Board consists of a grid: 3x3
    -2 players take turns placing board piece
    -Game is over when the board is filled up or if a player lines up 3 in a row
2. Extract major nouns and verbs
  -Gameboard (3x3) -> checks for game status
  -Players: Human and Computer options -> place piece on board
  -Players have game piece
  -Players take turns
3. Organize and do exploratory programming
=end

require 'pry'

module Selectable
  def ask(question)
    puts question
  end

  def ask_inline(question)
    print question
  end

  def invalid(msg = 'entry')
    puts "Invalid #{msg}. Try again."
  end
end

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
    board.place_piece board.options.sample.to_i, mark
  end
end

class Human < Player
  include Selectable

  def turn(board)
    ask_inline "#{self.name}, place your piece: "
    board.place_piece select_position(board).to_i, mark
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

class Computer < Player
end

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
    marks = pos_arr.map { |pos| squares[pos - 1].mark}.uniq
    (marks.size == 1) && !!marks.first
  end

  def options
    squares.select { |square| square.mark.nil? }.map { |square| square.position }
  end

  def place_piece(position, marker)
    squares[position - 1].mark = marker
  end

  private

  def empty_line
    ((" " * 3) + "|") * 2 + (" " * 3) + "\n"
  end

  def divider
    ("---+" * 2) + ("-" * 3) + "\n"
  end

  def row(pos_arr)
    top = empty_line
    middle = " #{squares[pos_arr[0] - 1]} | #{squares[pos_arr[1] - 1]} | #{squares[pos_arr[2] - 1]} \n"
    bottom = empty_line
    top + middle + bottom
  end
end

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

class GameMarker
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    marker
  end
end

class Game
  GAME_NAME = 'Object Oriented Tic Tac Toe'
  WINNING_POSITIONS = [[1,2,3],
                       [4,5,6],
                       [7,8,9],
                       [1,4,7],
                       [2,5,8],
                       [3,6,9],
                       [1,5,9],
                       [3,5,7]]

  include Selectable

  attr_accessor :player1, :player2, :board, :turn
  attr_reader :first_game

  def initialize(player1 = nil, player2 = nil)
    @first_game = (player1 && player2) ? false : true
    @board = Gameboard.new
    @player1 = player1 if player1
    @player2 = player2 if player2
  end

  def start
    welcome
    number = ask_number_of_players if first_game
    ask_name(number) if first_game
    reset_turn
    self.turn = player1
    until board.filled? || winning_position
      player_intro
      play(turn)
      change_turns
    end
    conclude_match
    play_again?
  end

  private

  def welcome
    system 'clear'
    title "Let's play some #{GAME_NAME}"
  end

  def ask_number_of_players
    ask "How many human players? 1 or 2."
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
      name? "your"
      @player1 = Human.new(request_name, "X")
      @player2 = Computer.new("R2D2", "O")
    when 2
      name? "Player 1's"
      @player1 = Human.new(request_name, "X")
      name? "Player 2's"
      @player2 = Human.new(request_name, "O")
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
    system 'clear'
    title "#{player1} versus #{player2}"
  end

  def play(player)
    show_board
    player.turn(board)
  end

  def show_board
    puts board
  end

  def show_winner(position)
    winning_marker = board.squares.select { |square| position.include? square.position.to_i }.first.mark
    winning_player = case winning_marker
                     when player1.mark
                       player1
                     when player2.mark
                       player2
                     end

    puts "#{winning_player} WON"
  end

  def winning_position
    # answer = false
    winning_position = []
    WINNING_POSITIONS.each do |position|
      # answer ||= board.same? position
      winning_position = position if board.same?(position)
    end
    winning_position.empty? ? nil : winning_position
  end

  def conclude_match
    system 'clear'
    title 'Match Over'
    winner = winning_position
    if winner
      show_winner(winner)
    else
      puts "Tie game."
    end
    show_board
  end

  def play_again?
    answer = ''
    loop do
      ask "Would you like to play your opponent again in Tic Tac Toe? y or n"
      answer = gets.chomp.downcase
      break if %(y n).include? answer
      invalid 'selection'
    end

    case answer
    when 'y'
      Game.new(player1, player2).start
    when 'n'
      goodbye
    end
  end

  def goodbye
    system 'clear'
    title 'GAMEOVER'
    title "Thank you for playing #{GAME_NAME}"
    title 'Have a nice day!'
  end

  def title(str)
    puts str.center 100, '-'
  end
end

Game.new.start







