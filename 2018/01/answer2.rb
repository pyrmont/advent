input = File.readlines('data').map(&:to_i)

answers = Hash.new
current = 0
numbers = input.to_enum

loop do
  begin
    current = current + numbers.next
    puts current
    break if answers[current]
    answers[current] = true
  rescue StopIteration
    numbers.rewind
  end
end

puts current
