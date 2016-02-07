require 'pry'

# Promptable module for mixins
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
    full_question = "#{question} #{answer_options}"
    get_correct_answer(full_question) do |ans|
      'Invalid entry. Try again.' unless arr_options.include? ans
    end
  end

  def ask_question_not_empty?(question)
    get_correct_answer(question) { |ans| 'Cannot be empty.' if ans.empty? }
  end

  def ask_question_single_char?(question, invalid_char)
    get_correct_answer(question) do |ans|
      msg = ''
      if ans.empty?
        msg += 'Cannot be empty.'
      elsif ans.size != 1
        msg += 'Must be single character.'
      end

      if ans == ans.to_i.to_s
        msg += "#{' ' unless msg.empty?}Cannot be a number."
      end

      if invalid_char == ans
        msg += "#{' ' unless msg.empty?}Cannot be #{invalid_char}."
      end

      msg.empty? ? nil : msg
    end
  end

  def enter_to_move_on
    warning 'Press enter to move on.'
    gets.chomp
    clear
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

  def string_of_acceptable_answers(arr_answers)
    possible_answers = ''
    case arr_answers.size
    when 1
      possible_answers = arr_answers.first
    when 2
      possible_answers = "#{arr_answers.first} or #{arr_answers.last}"
    else
      arr_answers.each_with_index do |val, index|
        if index < arr_answers.size - 1
          possible_answers << "#{val}, "
        else
          possible_answers << "or #{val}"
        end
      end
    end
  end
end

# Player class
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

  def won
    @points += 1
    "#{self} WON"
  end

  def show_score
    "#{name}: #{points}"
  end

  def >(other)
    points > other.points
  end

  def <(other)
    points < other.points
  end

  def tied?(other)
    points == other.points
  end

  def take_turn(board)
    square_num = board.options.sample
    board[square_num] = marker
  end
end

# Human player class
class Human < Player
  include Promptable

  def initialize(invalid_marker = nil)
    super()
    @name = ask_question_not_empty? 'What is your name?'
    @marker = ask_question_single_char? 'Pick a single char as your marker.', invalid_marker
  end

  def take_turn(board)
    square_num = ask_question?("#{self}, pick a square.", board.options.map(&:to_s)).to_i
    board[square_num] = marker
  end
end

# Computer player
class Computer < Player
  def initialize(other_player_marker = nil)
    super()
    @name = 'R2D2'
    @marker = %w(o O).include?(other_player_marker) ? 'X' : 'O'
  end
end

# Tic Tac Toe board setup
class TTTBoard
  attr_accessor :squares

  def initialize
    @squares = {}
    (1..9).each { |num| @squares[num] = Square.new(num) }
  end

  def reset
    squares.each_value(&:reset) # { |square| square.reset }
  end

  def filled?
    options.empty?
  end

  def []=(position, marker)
    self[position].marker = marker
  end

  def [](position)
    squares[position]
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

  def options
    squares.reject { |_, square| square.marker }.keys
  end

  def same?(pos_arr)
    markers = []
    pos_arr.each do |pos|
      markers << self[pos].marker
    end
    markers.uniq.size == 1 && !markers.first.nil?
  end

  def winner?(positions)
    !winning_positions(positions).empty?
  end

  def winning_positions(positions)
    positions.select { |combo| same?(combo) }
  end

  def winning_marker(positions)
    win_pos = winning_positions(positions)
    if win_pos.empty?
      nil
    else
      self[win_pos.first.first].marker
    end
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

# Square class
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

# Standard game setup to remove complexities from TicTacToe class.
class Game
  include Promptable
  GAME_NAME = 'Game'
  GAME_LIMIT = 5

  attr_reader :player1, :player2
  attr_accessor :player_to_move

  def initialize(player1 = nil, player2 = nil)
    welcome
    number_of_humans = how_many_humans?.to_i unless player1 && player2
    case number_of_humans
    when 1
      @player1 = Human.new
      @player2 = Computer.new(@player1.marker)
    when 2
      title 'Player 1'
      @player1 = Human.new
      title 'Player 2'
      @player2 = Human.new(@player1.marker)
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
    line = ('~' * scores.size).center 100
    puts line
    puts scores.center 100
    puts line
  end

  def sign
    if player1 > player2
      '>' * 2
    elsif player1 < player2
      '<' * 2
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

  def show_turn
    title "#{player_to_move}'s Turn"
  end

  def max_score
    player_point_arr.max
  end

  def min_score
    player_point_arr.min
  end

  def score_verb
    case score_diff
    when 0
      'evenly matches'
    when 1
      'barely beat'
    when 2
      'beat'
    when 3...self.class::GAME_LIMIT
      'hammered'
    when self.class::GAME_LIMIT
      'totally annihilated'
    end
  end

  def player_point_arr
    [player1.points, player2.points]
  end

  def score_diff
    max_score - min_score
  end

  def game_limit?
    max_score >= self.class::GAME_LIMIT
  end

  def gameover
    title 'GAMEOVER'
    title "Thank you for playing #{self.class::GAME_NAME}"
  end

  private

  def how_many_humans?
    ask_question? 'How many human players?', %w(1 2)
  end
end

# Classic game of Tic Tac Toe
class TicTacToe < Game
  GAME_NAME = 'Object Oriented Tic Tac Toe'
  WINNING_POSITIONS = [[1, 2, 3],
                       [4, 5, 6],
                       [7, 8, 9],
                       [1, 4, 7],
                       [2, 5, 8],
                       [3, 6, 9],
                       [1, 5, 9],
                       [3, 5, 7]]

  attr_accessor :board

  def initialize
    super
    @board = TTTBoard.new
  end

  def start
    loop do
      play_one_game
      break if game_limit?
      board.reset
    end
    show_match_result
    gameover
  end

  def play_one_game
    loop do
      show_standard_info
      show_turn
      player_to_move.take_turn(board)
      change_turns
      break if board.filled? || winner?
    end

    show_game_result
  end

  private

  def show_standard_info(params = {yes_show_board: true})
    clear
    game_title
    scoreboard
    show_board if params[:yes_show_board]
  end

  def show_board
    puts board
  end

  def show_game_result
    winning_player = winner
    msg = if winning_player
            winning_player.won
          else
            'Great game. It was a tie.'
          end
    show_standard_info
    title msg
    enter_to_move_on
  end

  def show_match_result
    show_standard_info({yes_show_board: false})
    title "#{determine_match_winner} #{score_verb} #{determine_match_loser}"
  end

  def winner?
    board.winner? WINNING_POSITIONS
  end

  def winner
    determine_player(board.winning_marker(WINNING_POSITIONS))
  end

  def determine_player(marker)
    case marker
    when player1.marker
      player1
    when player2.marker
      player2
    end
  end

  def determine_match_winner
    case max_score
    when player1.points
      player1
    when player2.points
      player2
    end
  end

  def determine_match_loser
    case determine_match_winner
    when player1
      player2
    when player2
      player1
    end
  end
end

TicTacToe.new.start
