def title(str)
  puts str.center(80,"-")
end

def question(num, *questions, message)
  set_of_qs = ""
  questions.each do |question|
    set_of_qs += write_statement question, "?" unless question.empty?
  end
  puts "#{num}.#{set_of_qs unless set_of_qs.empty?}#{write_statement(message, ".") unless message.empty?}"
end

def write_statement(str, mark)
  " " + str + mark
end

def response(message)
  puts "=> #{message}"
end
