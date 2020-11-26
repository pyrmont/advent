input = File.readlines ARGV[0]

def answer(input)
  map = initial_state(input)
end

def initial_state(lines)
  map = Array.new

  for y in 0...lines.size do
    line = lines[y].strip
    map[y] = Array.new

    for x in 0...line.length do
      map[y][x] = line[x]
    end
  end

  map
end

result = answer(input)

puts result.inspect
