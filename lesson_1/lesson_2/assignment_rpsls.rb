# 1. Rock Paper Scissors Lizard Spock
#   - Scissors cuts Paper covers Rock crushes
#     Lizard poisons Spock smashes Scissors decapitates
#     Lizard eats Paper disproves Spock vaporizes
#     Rock crushes Scissors
# 2. Game welcome
#   - Ask player name
#   - Ask player best of
#   - Start gameplay
# 3. Gameplay
#   - ask player to move
#   - computer moves
#   - decide winner
#   - keep playing until best of limit is achieved

# Bonus
# 1. Keep track of history of moves
# 2. Adjust computer choice based on history
# 3. Computer personalities

require 'pry'

class Player
  CHOICES = [:rock, :paper, :scissors, :lizard, :spock]

  attr_reader :name
  attr_accessor :move

  def to_s
    name
  end

  def throw_move
    self.move = CHOICES.sample
  end
end

class Human < Player
  def initialize
    @name = name_of
  end

  def throw_move
    self.move = request_move
  end

  private

  def name_of
    puts "What's your name?"
    answer = gets.chomp
    if answer.empty?
      puts "Must provide a name."
      answer = name
    end
    answer
  end

  def request_move
    puts "Rock, Paper, Scissors, Lizard, Spock?"
    answer = gets.chomp.downcase.to_sym
    unless CHOICES.include? answer
      puts "Invalid throw. Try again."
      answer = throw_move
    end
    answer
  end
end

class Computer < Player
  def initialize
    @name = %w(R2D2 C3P0 Chappie Sonny Number5).sample
  end
end

class History
  attr_accessor :rounds
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @rounds = []
    @player1 = player1
    @player2 = player2
  end

  def to_s
    str = ''
    rounds.each_with_index do |round, num|
      str += "#{num + 1}. #{round[0]} :: #{round[1]}\n"
    end
    str
  end

  def add_move
    rounds << [player1.move, player2.move]
  end

  def empty?
    rounds.empty?
  end
end

class Scoreboard
  attr_accessor :score
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @score = {player1 => 0, player2 => 0}
    @player1 = player1
    @player2 = player2
  end

  def increment(player)
    self.score[player] += 1
  end

  def max_score
    score.values.sort.last
  end

  def tied?
    score.values.uniq.size == 1
  end

  def winning?(player)
    score[player] == max_score && !tied?
  end

  def to_s
    "Score: #{score[player1]} :: #{score[player2]}"
  end
end

class Game
  attr_reader :human, :computer
  attr_accessor :best_of, :history, :scoreboard

  def initialize
    system 'clear'
    @human = Human.new
    @computer = Computer.new
    @best_of = request_best_of
    @history = History.new human, computer
    @scoreboard = Scoreboard.new human, computer
  end

  def play
    welcome
    play_until_overall_winner
    goodbye
  end

  private

  def welcome
    puts "#{human}, let's play #{computer} in Rock Paper Scissors Lizard Spock".center(90, '-')
  end

  def request_best_of
    print "Winner will be determined by who wins this many games: "
    answer = gets.chomp.to_i
    unless answer > 0
      puts "Invalid."
      answer = request_best_of
    end
    answer
  end

  def play_until_overall_winner
    loop do
      info
      human.throw_move
      computer.throw_move
      history.add_move
      if winner? human, computer
        scoreboard.increment human
      elsif winner? computer, human
        scoreboard.increment computer
      else
        puts "It's a tie!"
      end

      break unless scoreboard.max_score < best_of
    end
  end

  def winner?(player1, player2)
    p2_move = player2.move
    case player1.move
    when :rock
      [:scissors, :lizard].include? p2_move
    when :paper
      [:rock, :spock].include? p2_move
    when :scissors
      [:paper, :lizard].include? p2_move
    when :lizard
      [:paper, :spock].include? p2_move
    when :spock
      [:scissors, :rock].include? p2_move
    end
  end

  def info
    system 'clear'
    puts "#{human} :: #{computer} -- First to #{best_of}"
    puts scoreboard
    puts history unless history.empty?
  end

  def goodbye
    info
    if scoreboard.winning? human
      puts "You WON!"
    else
      puts "You LOST!"
    end
    puts "GAMEOVER".center(90, '-')
  end
end

Game.new.play
