class Player
  CHOICES = { rock: 'r', paper: 'p', scissors: 's' }
  attr_reader :name
  attr_accessor :choice
end

class Human < Player
  def initialize
    @name = request_name
  end

  def choose
    self.choice = request_choice
  end

  def request_name
    puts "What is your name?"
    answer = gets.chomp
    if answer.empty?
      puts "Must provide a name."
      answer = request_name
    end
    answer
  end

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

class Computer < Player
  def initialize
    @name = ['R2D2', 'C3PO', 'Chappie', 'Number 5'].sample
  end

  def choose
    self.choice = CHOICES.keys.sample
  end
end

class Rule
  def self.result(player1, player2)
    if tie? player1, player2
      :tie
    elsif winner? player1, player2
      :player1
    else
      :player2
    end
  end

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

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    gameplay
    display_goodbye_message
  end

  private

  def display_welcome_message
    system 'clear'
    puts "#{human.name}, welcome to the notorious game of Rock Paper Scissors".center(90, "-")
  end

  def request_player_name
    puts "What's your name?"
    name = gets.chomp
    if name.length < 3
      puts "Name must be at least 3 letters long."
      name = request_player_name
    end
    name
  end

  def display_winner
    case Rule.result(human, computer)
    when :tie
      puts "It's a tie. You both threw #{human.choice}."
    when :player1
      puts "#{winner_line human, computer}"
    when :player2
      puts "#{winner_line computer, human}"
    end
  end

  def winner_line(winner, loser)
    "#{winner.choice.capitalize} beats #{loser.choice}. #{winner.name} wins and #{loser.name} loses."
  end

  def display_goodbye_message
    puts "GAMEOVER".center(90, '-')
    puts "Have a nice day!"
  end

  def gameplay
    loop do
      human.choose
      computer.choose
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
