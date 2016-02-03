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

class Player
  attr_reader :mark, :name

  def initialize(name, mark)
    @name = name
    @mark = GameMarker.new(mark)
  end

  def to_s
    "#{name} (#{mark}s)"
  end
end

class Human < Player
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
    "build gameboard"
  end

  def filled?
    answer = true
    squares.each do |square|
      answer &&= square.filled?
    end
    answer
  end

  def same?(pos_arr)
    marks = pos_arr.map { |pos| squares[pos - 1].mark}.uniq
    (marks.size == 1) && !!marks.first
  end
end

class Square
  attr_reader :position, :mark

  def initialize(position)
    @position = position
  end

  def to_s
    mark || position
  end

  def fill(mark)
    @mark = mark
  end

  def filled?
    !!mark
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
  WINNING_POSITIONS = [[1,2,3],
                       [4,5,6],
                       [7,8,9],
                       [1,4,7],
                       [2,5,8],
                       [3,6,9],
                       [1,5,9],
                       [3,5,7]]
  attr_accessor :player1, :player2, :board

  def initialize
    @board = Gameboard.new()
  end

  def start
    welcome
    number = ask_number_of_players
    ask_name(number)
    player_intro
    play
  end

  private

  def welcome
    system 'clear'
    puts "Let's play some Object Oriented Tic Tac Toe".center(100, '-')
  end

  def ask_number_of_players
    puts "How many human players? 1 or 2."
    answer = gets.chomp.to_i
    unless [1, 2].include? answer
      puts "Invalid entry."
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

  def name?(person)
    puts "What is #{person} name?"
  end

  def request_name
    answer = gets.chomp
    if answer.empty?
      puts "Please provide a name."
      answer = request_name
    end
    answer
  end

  def player_intro
    puts "#{player1} versus #{player2}".center(100,'-')
  end

  def play
    until board.filled? || winner?
      puts "Something"
      gets.chomp
    end
  end

  def winner?
    answer = false
    WINNING_POSITIONS.each do |position|
      answer ||= board.same? position
    end
    answer
  end
end

Game.new.start








