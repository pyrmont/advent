input = File.readlines('data').map(&:to_i)

result = input.reduce(0) do |memo,change|
           memo + change
         end

puts result
