input = File.readlines 'data'

def answer(input)
  polymer = input[0].strip
  polymer = scan(polymer)
  polymer.length
end

def scan(input)
  i = 0
  keep_going = true
  while keep_going
    input, result = react(input, i)
    case result
    when :nothing
      i += 1
      next
    when :reacted
      i = (i == 0) ? 0 : i - 1
      next
    when :complete
      keep_going = false
    end
  end

  input
end

def react(input, i)
  return [ input, :complete ] if input.length == i + 1
  this_char = input[i]
  next_char = input[i + 1]
  if reactive?(this_char, next_char)
    input = input.slice(0...i) + input.slice((i + 2)..-1)
    [ input, :reacted ]
  else
    [ input, :nothing ]
  end
end

def reactive?(a, b)
  return false if b == nil
  a != b && a.upcase == b.upcase
end

result = answer(input)

puts result.inspect
