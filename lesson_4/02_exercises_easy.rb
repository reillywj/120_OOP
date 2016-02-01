require_relative 'basics'

question 1, 'What is result', ''
response 'A string: "You will eat a nice lunch" or some other variant from the choices in the choices method/array'

question 2, 'What is result', ''
response 'A string: "You will <visit Vegas or fly to Fiji or romp in Rom>"'
response 'Each method invocation goes back through the hierarchal chain.'

question 3, 'How do you find where Ruby will look for a method when that method is called', "How can you find an object's ancestors", 'What is the lookup chain for Orange and HotSauce', ''
response "You look at instance's inheritance or ancestral chain"
response 'Use #ancestors methods'
response 'Orange > Taste > Object > Kernel > BasicObject'
response 'HotSauce > Taste > object > ...'

question 4, 'How to add to class to simplify it and remove two methods from the class definition while still maintaining the same functionality', ''
response 'attr_accessor :type line of code to the class and remove the type and type= methods and can replace @type with type'

question 5, 'What are different types of variables and how do you know which is which', ''
response 'local variable'
response 'instance variable'
response 'class variable'
response 'Based on whether they have an "at" symbol or not and how many'

question 6, 'Given class, which one is a class method and how do you know', 'How would you call a class method', ''
response 'The method prepended with self. is the class method.'
response 'Invoke by doing Television.manufacturer'


question 7, 'What does @@cats_count do', 'How does it work', 'What code would you need to write to test your theory', ''
response '@@cats_count: every time a Cat class or a subclass is initialized cats_count increment 1 that either also increments this class when overriding the initialize method or uses the Cat#initialze method and is a class variable'
response 'It stores the value of the number of cats and can be accessed by calling Cat.cats_count'

question 8, 'What can we add to the Bingo class to allow it to inherit the play method from the Game class', ''
response 'class Bingo < Game; end'

question 9, 'What would happen if we added a play method to Bingo class', ''
response 'It would override the Game#play method as the stack would look within the Bingo class first and find play their'
response 'You can still use the Game#play method by using the super keyword within the Bingo#play method if there is some behavior still wanted from the super-class method of play'

question 10, 'What are the benefits of using OOP in Ruby', ''
response 'In Ruby, everything is an object and can be treated as such'
response 'Objects are considered nouns'
response 'Can reveal behaviors with intention and purpose that an object should'
response 'Easier to manage code as it becomes more complex'
