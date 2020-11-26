input = File.readlines 'data'

def answer(input)
  all = all_coords(input)
  boundary = boundary(all)
  
  areas = Hash.new { |h,k| h[k] = 0 }
  for x in boundary[:left]..boundary[:right] do
    for y in boundary[:bottom]..boundary[:top] do
      closest = closest_point([ x, y ], all)
      areas[closest] += 1
    end
  end

  areas.values.max
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

def closest_point(point, candidates)
  candidates.min do |a,b|
    (point[0] - a[0]).abs + (point[1] - a[1]).abs <=>
    (point[0] - b[0]).abs + (point[1] - b[1]).abs
  end
end

result = answer(input)

puts result.inspect
