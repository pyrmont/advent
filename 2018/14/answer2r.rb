digits = nil
input = (ARGV[0] || DATA.read.chomp).tap { |s| digits = s.chars.map(&:to_i) }.to_i

def step
  scoreboard = [3, 7]
  first = 0
  second = 1

  loop do
    score = scoreboard[first] + scoreboard[second]
    (scoreboard << score / 10; yield scoreboard) if score > 9
    scoreboard << score % 10
    yield scoreboard
    first = (first + scoreboard[first] + 1) % scoreboard.size
    second = (second + scoreboard[second] + 1) % scoreboard.size
  end
end

start = nil
len = 0
scoreboard = step do |board|
  if board.size == input + 10
    recipes = board[input, 10].map(&:to_s).join
    puts "Part 1: #{recipes}"
  end

  unless board.last == digits[len]
    len = 0
    start = nil
  end

  if board.last == digits[len]
    len += 1
    start = board.size - 1 if start.nil?
    break board if len == digits.size
  end
end

puts "Part 2: #{start}"
puts "Scoreboard: #{scoreboard.inspect}"
