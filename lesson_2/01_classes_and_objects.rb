require_relative 'basics'
require 'pry'

question 1, "Given code, code the class definition"
response "See here:"

class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end
bob = Person.new('bob')
puts bob.name                  # => 'bob'
bob.name = 'Robert'
puts bob.name                  # => 'Robert'

question 2, "Modify class definition to facilitate following methods."

class Person2
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    names = full_name.split
    @first_name = names.first
    @last_name = names.size > 1 ? names.last : ''
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    names = full_name.split
    self.first_name = names.first
    self.last_name = names.size > 1 ? names.last : ''
  end

  def ==(other_person)
    name == other_person.name
  end

  def to_s
    name
  end

end

bob = Person2.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name

question 3, "Add name= method"

bob.name = "John Adams"
p bob.name
p bob.first_name
p bob.last_name

question 4, "Create a few more people"
bob = Person2.new('Robert Smith')
rob = Person2.new('Robert Smith')
p bob == rob
p rob == bob

question 5, "Add to_s method"
p "The person's name is: #{bob}."

