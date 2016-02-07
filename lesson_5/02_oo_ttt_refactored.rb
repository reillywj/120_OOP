class Player
  attr_reader :name, :marker, :points

  def initialize
    @points = 0
  end
end

class Human < Player
end

class Computer < Player
end

class TTTBoard
  attr_accessor :squares

  def initialize
    @squares = Hash.new
    (1..9).each { |num| @squares[num] = Square.new(num) }
  end
end

class Square
  attr_reader :position
  def initialize(num)
    @position = num
  end
end

class Game
end

class TicTacToe < Game
end














