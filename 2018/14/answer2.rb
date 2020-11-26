input = ARGV[0]

def answer(input)
  elves = [ { current: nil }, { current: nil } ]
  needle = input
  position = position(needle, elves)
end

def position(needle, elves)
  scoreboard = ''

  scoreboard += 3.to_s
  elves[0][:current] = 0

  scoreboard += 7.to_s
  elves[1][:current] = 1

  i = 0
  loop do
    recipes = recipes(elves, scoreboard)
    scoreboard = add_recipes(scoreboard, recipes)
    elves = advance(elves, scoreboard)
    puts scoreboard.length
    pos = index(scoreboard, needle)
    return pos if pos
  end
end

def recipes(elves, scoreboard)
  result = scoreboard[elves[0][:current]].to_i + scoreboard[elves[1][:current]].to_i
  first = (result / 10 == 0) ? nil : result / 10
  second = result % 10
  [ first, second ]
end

def add_recipes(scoreboard, recipes)
  recipes.each { |r| scoreboard += r.to_s unless r.nil? }
  scoreboard
end

def advance(elves, scoreboard)
  elves.each do |elf|
    current = elf[:current]
    moves = scoreboard[current].to_i + 1
    if current + moves < scoreboard.length
      elf[:current] = current + moves
    else
      moves.times do
        pos = elf[:current] + 1
        elf[:current] = (pos == scoreboard.size) ? 0 : pos
      end
    end
  end

  elves
end

def index(scoreboard, needle)
  scoreboard.rindex(needle)
end

result = answer(input)

puts result.inspect
