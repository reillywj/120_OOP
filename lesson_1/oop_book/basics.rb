def title(str)
  puts str.center(80,"-")
end

def question(num, question, message = "")
  puts "#{num}. #{question}?#{" " + message+"."}"
end

def response(message)
  puts "=> #{message}"
end
