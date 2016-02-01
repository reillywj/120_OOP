require_relative 'basics'

question 1, 'Which of following are objects in Ruby', 'If they are object how can you find out what class they belong to', ''
response 'They are all objects.'
response 'Can call #class method on them.'
puts true.class
puts 'hello'.class
puts [1,2,3,'happy days'].class
puts 142.class

question 2, 'How can we add ability using module Speed', 'How can you check if Car or Truck can now go fast', ''

response 'Mixin the module with include'
response 'Create instances of Car and Truck and invoke #go_fast method on those objects.'

question 3, 'How is this done', ''
response 'Looks at the small_car object and looks for method go_fast. Does not find it, moves up to mixed in Module Speed and finds it. invokes the method, which puts the string to the cmd line prompt. Because self is the car object, the method #class is the Car class. String interpolation prints this as a string "Car"'

question 4, 'How do we create new instance of AngryCat class', ''
response 'a = AngryCat.new'

question 5, 'Which of two classes has instance variable', 'How do you know', ''
response 'Pizza does. @name with "at" character.'
response 'Can also call #instance_variables to get an array of the instance variables of an instance.'

question 6, 'How to access instance variable @volume', ''
response 'attr_reader :volume or instance method that returns value of @volume'
response 'Can call #instance_variable_get("@volume") to get value of instance variable.'

question 7, 'What is the default thing that Ruby will print to the screen if you call to_s on an object', 'Where could you go to find out if you want to be sure', ''
response 'Default is to print Object notation with Class of object and object_id'
response 'Could puts object as this calls to_s on object.'

question 8, 'What does self refer to here', ''
response 'refers to the object instance of Cat and then the accessor method #age that is the instance variable age of the instance'

question 9, 'What does self refer in this context', ''
response 'Refers to the class and creates the class method Cat#cats_count that returns the class variable @@cats_count'

question 10, 'What would you need to call to create a new instance of this class', ''
response 'Bag.new("some_color like blue", "some material like plastic")'