input = File.readlines 'data'

def answer(input)
  all = all_coords(input)
  boundary = boundary(all)
  
  region = Array.new
  for x in boundary[:left]..boundary[:right] do
    for y in boundary[:bottom]..boundary[:top] do
      region.push [ x, y ] if within_region?([ x, y ], all)
    end
  end

  region.count
end

def all_coords(input)
  input.map { |line| line.split(', ').map { |coord| coord.to_i } }
end

def boundary(all)
  max = { top: nil, bottom: nil, left: nil, right: nil }
  
  all.each do |x,y|
    max[:top] = y if max[:top].nil? || y > max[:top]
    max[:bottom] = y if max[:bottom].nil? || y < max[:bottom]
    max[:left] = x if max[:left].nil? || x < max[:left]
    max[:right] = x if max[:right].nil? || x > max[:right]
  end

  max
end

def within_region?(point, candidates)
  max = 10_000

  candidates.reduce(0) do |total,a|
    distance = (point[0] - a[0]).abs + (point[1] - a[1]).abs
    return false if total + distance > max
    total + distance
  end
  
  true
end

result = answer(input)

puts result.inspect
