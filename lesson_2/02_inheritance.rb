require_relative 'basics'

module Pet
  def speak
    'bark!'
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog
  include Pet

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

question 1, "Given Dog class, write Bulldog subclass and override swim method"
class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

mac = Bulldog.new
puts "Can Mac swim? #{mac.swim}"

question 2, "Given extra behaviors in Dog, create a Cat class and figure out how to mixin so hierarchy to share behaviors"

class Cat
  include Pet

  def speak
    'meow'
  end
end

stripes = Cat.new
p stripes.speak
p stripes.jump

question 3, "Draw class hierarchy of the classes form step 2:"
response "Cat:"
puts Cat.ancestors
response "Dog:"
puts Dog.ancestors
response "Bulldog:"
puts Bulldog.ancestors

question 4, "What is method lookup path", "How is it important", ""
response "Method lookup path is the order at which Ruby searches different scopes in the hierarchy for methods. If Ruby can't find a certain method it goes to the next ancestor in the hierarchy to look for the method. And keeps going until it can't find it."
response "This is important because you can override methods from ancestors by creating the same method in the current class/module"
