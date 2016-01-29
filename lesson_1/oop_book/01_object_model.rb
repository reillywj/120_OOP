require_relative 'basics'
require 'pry'

title "The Object Model"

# 1. How do we create an object in Ruby? Give an example of the creation of an object.
question 1, "How do we create an object in Ruby", "Give an example of the creation of an object"
response "You create an object be instantiating a new object."
a = "A new string by default"
b = Array.new(5)
p a
p b

class MyClass; end
c = MyClass.new
p c

# 2. What is a module? What is its purpose? How do we use them with our classes? Create a module for the class you created in exercise 1 and include it properly.
question 2, "What is a module", "What is its purpose", "How do we use them with our classes", "Create a module for the class you created in exercise 1 and include it properly"
response "A module is a place to store behaviors that you wish to share with multiple classes."
response "You use them by 'include'ing them with your class."

module ForMyClass
  def go_to_sleep
    puts "z" * 10
  end
end

class MyClass
  include ForMyClass

  def study
    puts "Wake up and study!"
  end
end

a = MyClass.new
a.study
a.go_to_sleep