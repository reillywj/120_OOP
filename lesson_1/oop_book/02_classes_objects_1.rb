require_relative 'basics'

question 1, "Create a class called MyCar. When you initialize a new instance or object of the class, allow the user to define some instance variables that tell us the year, color, and model of the car. Create an instance variable that is set to 0 during instantiation of the object to track the current speed of the car as well. Create instance methods that allow the car to speed up, brake, and shut the car off."

class MyCar
  attr_accessor :speed, :status, :color
  attr_reader :year, :model

  def initialize(year = 2016, color = "red", model = "Accord")
    @year = year
    @color = color
    @model = model
    @speed = 0
    @status = true
  end

  def speed_up(delta = 5)
    self.speed += delta if status
  end

  def brake(delta = 5)
    speed > delta ? self.speed -= delta : self.speed = 0
  end

  def turnoff
    if speed > 0
      puts "Can't turnoff while moving. Still going #{speed}mph. Try braking."
    else
      self.status = false
      puts "Car is now turned off. Have a nice day."
    end
    status
  end

  def turnon
    if status
      puts 'Already turned on.'
    else
      self.status = true
    end
    status
  end

  def spray_paint(color = "red")
    self.color = color
    puts "You're now driving a #{self.to_s}."
  end

  def to_s
    "#{year} #{color} #{model}"
  end

  def self.what_am_i
    "A car"
  end
end