require_relative 'basics'

question 1, "Who's right", ""
response 'Ben is correct. attr_reader creates a getter method that returns the value of @balance to check to see if there is a positive balance'

question 2, 'What is the mistake and how to fix', ''
response 'Tried to set quantity but is currently a read-only, getter method'
response 'either put @quantity = updated_count... OR create the attr_writer/accessor for :quantity and use self.quantity = ...'

question 3, 'Is there anything wrong', 'How to fix', ''
response 'Nothing wrong, just need to use self.quantity when setting'
response 'Real answer: you are opening up the method as a public method that can be changed by any client as a setter method (instance.quantity = <new value>)'

question 4, 'Do some stuff'
class Greeting
  def greet(str)
    puts str
    str
  end
end

class Hello < Greeting
  def hi
    self.greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    self.greet("Goodbye")
  end
end

oh = Hello.new
good = Goodbye.new
oh.hi
good.bye

question 5, 'Do some more stuff'
class KrispyKreme
  attr_reader :filling_type, :glazing

  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    "#{filling_type || "Plain"}#{" with "+ glazing if glazing}"
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
puts donut2
puts donut3
puts donut4
puts donut5

question 6, "What's the difference in code", ""
repsonse "No difference, just self. is not required as we have the attr_accessor declared on template"

question 7, "How to change method name so that method name is more clear and less repetitive", ""
response "rename to self.information or self.info so that Light.light_information would change to Light.information or Light.info and flows much better without repetitiveness"
