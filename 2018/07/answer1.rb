input = File.readlines 'data'

def answer(input)
  conditions =rules(input)
  steps = steps(conditions)
  steps.join
end

def rules(lines)
  conditions = Hash.new { |h,k| h[k] = Array.new }
  
  lines.each do |line|
    rel = line.scan(/[S|s]tep ([A-z])/).flatten
    conditions[rel[0]]
    conditions[rel[1]].push rel[0]
  end

  conditions
end

def steps(conditions)
  steps = Array.new

  letters = ('A'..'Z').to_a
  alphabet = letters.each

  loop do
    begin
      letter = alphabet.next
      next unless conditions[letter].count == 0
      steps.push letter
      conditions.each { |k,v| v.delete(letter) }
      letters.delete letter
      alphabet = letters.each
    rescue StopIteration
      break
    end
  end

  steps
end

result = answer(input)

puts result.inspect
