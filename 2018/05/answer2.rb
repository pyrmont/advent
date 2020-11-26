input = File.readlines 'data'

def answer(input)
  polymer = input[0].strip
  candidates = ('a'..'z').map do |letter|
    regex = Regexp.new("[#{letter}#{letter.upcase}]")
    scan(polymer.gsub(regex, ''))
  end
  candidate = candidates.min { |a,b| a.length <=> b.length }
  candidate.length
end

def scan(input)
  i = 0
  loop do
    input, status = react(input, i)
    case status
    when :nothing
      i += 1
    when :reacted
      i = (i == 0) ? 0 : i - 1
    when :complete
      break
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
  a != b && a.upcase == b.upcase
end

result = answer(input)

puts result.inspect
