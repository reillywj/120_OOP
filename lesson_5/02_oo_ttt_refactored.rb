require 'pry'

module Promptable
  def clear
    system 'clear'
  end

  def title(msg)
    puts msg.center 100, '-'
  end

  def ask(question)
    puts "Q: #{question}"
  end

  def warning(msg)
    puts msg.center 100, '!*-*'
  end

  def ask_question?(question, arr_options)
    answer_options = string_of_acceptable_answers(arr_options)
    ask "#{question} #{answer_options}"
    answer = nil
    loop do
      answer = gets.chomp
      break if arr_options.include? answer
      warning "Invalid entry. Try again. #{answer_options}"
    end
    answer
  end

  def ask_question_not_empty?(question)
    ask question
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.empty?
      warning 'Cannot be blank.'
    end
    answer
  end

  private

  def string_of_acceptable_answers(arr_of_acceptable_answers)
    possible_answers = ''
    case arr_of_acceptable_answers.size
    when 1
      possible_answers = arr_of_acceptable_answers.first
    when 2
      possible_answers = "#{arr_of_acceptable_answers.first} or #{arr_of_acceptable_answers.last}"
    else
      arr_of_acceptable_answers.each_with_index do |val, index|
        if index < arr_of_acceptable_answers.size - 1
          possible_answers << "#{val}, "
        else
          possible_answers << "or #{val}"
        end
      end
    end
  end
end

class Player
  attr_reader :name, :marker, :points

  def initialize
    clear_score
  end

  def clear_score
    @points = 0
  end

  def to_s
    name
  end

  def show_score
    "#{name}: #{points}"
  end

  def >(other_player)
    points > other_player.points
  end

  def <(other_player)
    points < other_player.points
  end

  def tied?(other_player)
    points == other_player.points
  end

  def take_turn(board)
  end
end

class Human < Player
  include Promptable

  def initialize
    super
    @name = ask_question_not_empty? 'What is your name?'
  end
end

class Computer < Player
  def initialize
    super
    @name = 'R2D2'
  end
end

class TTTBoard
  attr_accessor :squares

  def initialize
    @squares = Hash.new
    (1..9).each { |num| @squares[num] = Square.new(num) }
  end

  def reset_board
    squares.each { |square| square.reset }
  end

  def filled?

  end

  def []=(position, marker)
    self[position].marker = marker
  end

  def [](position)
    self.squares[position]
  end

  def to_s
    breaker = empty_line + line_break + empty_line
    empty_line +
    line_values(1, 2, 3) +
    breaker +
    line_values(4, 5, 6) +
    breaker +
    line_values(7, 8, 9) +
    empty_line
  end

  private

  def empty_line
    ('   |' * 2) + "   \n"
  end

  def line_break
    ('---+' * 2) + ('-' * 3) + "\n"
  end

  def line_values(pos1, pos2, pos3)
    " #{self[pos1]} | #{self[pos2]} | #{self[pos3]} \n"
  end
end

class Square
  attr_reader :position
  attr_accessor :marker

  def initialize(num)
    @position = num
  end

  def reset
    self.marker = nil
  end

  def to_s
    value = marker ? marker : position
    value.to_s
  end
end

class Game
  include Promptable
  GAME_NAME = 'Game'

  attr_reader :player1, :player2
  attr_accessor :player_to_move

  def initialize(player1 = nil, player2 = nil)
    welcome
    number_of_humans = how_many_humans?.to_i unless player1 && player2
    case number_of_humans
    when 1
      @player1 = Human.new
      @player2 = Computer.new
    when 2
      title 'Player 1'
      @player1 = Human.new
      title 'Player 2'
      @player2 = Human.new
    end

    @player_to_move = self.player1
  end

  def welcome
    clear
    title "Welcome to #{self.class::GAME_NAME}"
    title "Let's get ready to play"
  end

  def game_title
    clear
    title self.class::GAME_NAME
  end

  def scoreboard
    scores = "| #{player1.show_score} #{sign} #{player2.show_score} |"
    line =  ('~' * scores.size).center 100
    puts line
    puts scores.center 100
    puts line
  end

  def sign
    if player1 > player2
      '>' * 3
    elsif player1 < player2
      '<' * 3
    else
      '| |'
    end
  end

  def change_turns
    case player_to_move
    when player1
      self.player_to_move = player2
    when player2
      self.player_to_move = player1
    end
  end

  private

  def how_many_humans?
    ask_question? 'How many human players?', %w(1 2)
  end
end

class TicTacToe < Game
  GAME_NAME = 'Object Oriented Tic Tac Toe'

  attr_accessor :board

  def initialize
    super
    @board = TTTBoard.new
  end

  def start
    loop do
      clear
      game_title
      scoreboard
      show_board
      player_to_move.take_turn(board)
      change_turns
      # break if board.filled? || winner?
      break
    end
  end

  private

  def show_board
    puts board
  end
end

TicTacToe.new.start












