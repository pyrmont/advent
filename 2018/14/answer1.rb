input = ARGV[0]

def answer(input)
  elves = [ { current: nil }, { current: nil } ]
  limit = input.to_i
  scoreboard = scores(limit, elves)
  scoreboard.slice(limit, 10).join
end

def scores(limit, elves)
  scoreboard = Array.new

  scoreboard.push(3)
  elves[0][:current] = 0

  scoreboard.push(7)
  elves[1][:current] = 1

  loop do
    recipes = recipes(elves, scoreboard)
    scoreboard = add_recipes(scoreboard, recipes)
    elves = advance(elves, scoreboard)
    break if scoreboard.size > limit + 10
  end

  scoreboard
end

def recipes(elves, scoreboard)
  result = scoreboard[elves[0][:current]] + scoreboard[elves[1][:current]]
  first = (result / 10 == 0) ? nil : result / 10
  second = result % 10
  [ first, second ]
end

def add_recipes(scoreboard, recipes)
  recipes.each { |r| scoreboard.push(r) unless r.nil? }
  scoreboard
end

def advance(elves, scoreboard)
  elves.each do |elf|
    current = elf[:current]
    moves = scoreboard[current] + 1
    moves.times do
      pos = elf[:current] + 1
      elf[:current] = (pos == scoreboard.size) ? 0 : pos
    end
  end

  elves
end

result = answer(input)

puts result.inspect
