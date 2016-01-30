class Player
  CHOICES = { rock: 'r', paper: 'p', scissors: 's' }

  attr_reader :auto
  attr_accessor :choice

  def initialize(auto_play = false)
    @auto = auto_play
  end

  def choose
    self.choice = auto ? CHOICES.keys.sample : request_choice
    puts "You chose #{choice}." unless auto
  end

  private

  def request_choice
    puts "Rock (R) Paper (P) or Scissors(S)?"
    selection = gets.chomp.downcase
    unless valid? selection
      puts "Invalid selection."
      selection = request_choice
    end

    if CHOICES.keys.include?(selection.to_sym)
      selection.to_sym
    else
      CHOICES.select { |_, value| value == selection }.keys.first
    end
  end

  def valid?(selection)
    CHOICES.keys.include?(selection.to_sym) || CHOICES.values.include?(selection)
  end
end

class Rule
  def self.result(player1, player2)
    if tie? player1, player2
      :tie
    elsif winner?(player1, player2)
      :player
    else
      :computer
    end
  end

  private

  def self.tie?(player1, player2)
    player1.choice == player2.choice
  end

  def self.winner?(player1, player2)
    p2_choice = player2.choice
    case player1.choice
    when :rock
      p2_choice == :scissors
    when :paper
      p2_choice == :rock
    when :scissors
      p2_choice == :paper
    else
      false
    end
  end
end

def compare(move1, move2)
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(true)
  end

  def play
    display_welcome_message
    gameplay
    display_goodbye_message
  end

  private

  def display_welcome_message
    system 'clear'
    puts "Welcome to the notorious game of Rock Paper Scissors".center(90, "-")
  end

  def human_choose_move
    human.choose
  end

  def computer_choose_move
    computer.choose
  end

  def display_winner
    case Rule.result(human, computer)
    when :tie
      puts "It's a tie. You both threw #{human.choice}."
    when :player
      puts "#{winner_line human, computer} You win!"
    when :computer
      puts "#{winner_line computer, human} You lose."
    else
      puts "THIS SHOULD NEVER SHOW"
    end
  end

  def winner_line(winner, loser)
    "#{winner.choice.capitalize} beats #{loser.choice}."
  end

  def display_goodbye_message
    puts "GAMEOVER".center(90, '-')
    puts "Have a nice day!"
  end

  def gameplay
    loop do
      human_choose_move
      computer_choose_move
      display_winner
      break unless play_again?
    end
  end

  def play_again?
    puts "Would you like to play another round? y or n."
    answer = gets.chomp.downcase
    %w(yes y).include? answer
  end
end

RPSGame.new.play
