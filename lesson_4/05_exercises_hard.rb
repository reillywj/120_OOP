require_relative 'basics'

question 1, "Fix SecretFile for logging to happen when data is invoked"
response "Add logging variable to store SecurityLogger"
response "remove attr_reader and create a getter method that first invokes create_log_entry method of logger instance of SecurityLogger before returning value of data"
class SecretFile
  def initialize(secret_data, logger)
    @data = secret_data
    @logger = logger
  end

  def data
    @logger.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
    str = "Some logging of security breech"
    puts str
    str
  end
end

sf = SecretFile.new("super secret info", SecurityLogger.new)
puts sf.data


question 2, "Address boat v wheeled vehicle issue"
response "Offshore similar behaviors into a module or modules and mix-in module"

question 3, "How to modify vehicles code to incorporate new Motorboat class", ""
response "Set Motorboat as the super class and inherit states/behaviors into Catamaran"
response "Or create a separate class that the Motorboat and Catamaran can inherit"

question 4
response "In Seacraft class define method #range that invokes the module #range method and then adds 10 to the value"
