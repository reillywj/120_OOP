require_relative 'basics'

question 1, "Create superclass Vehicle for MyCar class to inherit from and move behavior that isn't specific to MyCar to superclass. Create constant that stores info about vehicle that makes it different from other types of vehicles. Create new class MyTruck inherits from superclass that also has constant defined that separates it from MyCar"

module Towable
  def can_tow?(pounds)
    pounds < 2000
  end
end


class Vehicle
  attr_accessor :color, :status, :speed
  attr_reader :year, :model

  @@number_of_vehicles = 0

  TYPE = 'Vehicle'

  def initialize(year = Time.now.year, color = "red", model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @status = true
    @@number_of_vehicles += 1
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

  def spray_paint(color = 'black')
    self.color = color
  end

  def self.mileage(miles, gallons)
    mpg = miles / gallons
    puts "Fuel efficiency: #{mpg} mpg."
    mpg
  end

  def self.number_of_vehicles
    @@number_of_vehicles
  end

  def is_old?
    age > 150
  end

  private 

  def age
    Time.now.year - year
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
end

class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2
end

accord = MyCar.new(2010, 'red', "Honda Accord")
truck = MyTruck.new(1960, 'blue', "Ford F-150")

puts accord
puts truck
puts "Can tow 1500 pounds? #{truck.can_tow?(1500)}"
puts Vehicle.number_of_vehicles

question 4, "Print to screen method lookup for classes created"
response "Accord"
puts accord.class.ancestors
response "Truck"
puts truck.class.ancestors

question 6, "Wriet method called age that calls a private method to calculate age of the vehicle."

puts "Is the truck old? #{truck.is_old?}"


question 7, "Create Student class with attr's name and grade."
class Student
  def initialize(name, test_score)
    @name = name
    @grade = test_score
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  def grade
    @grade
  end
end

steve = Student.new('Steve', 90)
jerry = Student.new('Jerry', 75)

puts "Well done!" if steve.better_grade_than?(jerry)

question 8, 'NoMethodError: private method...'
response 'Means no access to a private method. Move the method hi above the private reserved word'