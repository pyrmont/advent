input = File.readlines ARGV[0]

def answer(input)
  points = points(input)
  points = fast_forward(points)
  print_message(points)
end

def points(lines)
  num = '\s*(-?\d+)'
  regex = /position=<#{num},#{num}> velocity=<#{num},#{num}>/
  lines.map do |line|
    figures = line.scan(regex)[0]
    raise "Error: Regex was bad" unless figures.size == 4
    pos = { x: figures[0].to_i, y: figures[1].to_i }
    vel = { x: figures[2].to_i, y: figures[3].to_i }
    [ pos, vel ]
  end
end

def fast_forward(points)
  for i in 0...(ARGV[1].to_i) do
    positions = positions(points)
    points = points.map do |pos,vel|
      pos[:x] = pos[:x] + vel[:x]
      pos[:y] = pos[:y] + vel[:y]
      [ pos, vel ]
    end
  end

  points
end

def positions(points)
  points.map do |pos,_|
    { x: pos[:x], y: pos[:y] }
  end
end

def unique_x(positions)
  result = Hash.new
  positions.each do |pos|
    result[pos[:x]] = true
  end
  result.keys.size
end

def print_message(points)
  col_max = nil
  col_min = nil
  row_max = nil
  row_min = nil
  canvas = Hash.new { |h,k| h[k] = Hash.new }
  points.each do |pos,_|
    canvas[pos[:x]][pos[:y]] = true
    col_max = pos[:x] if col_max.nil? || col_max < pos[:x]
    col_min = pos[:x] if col_min.nil? || col_min > pos[:x]
    row_max = pos[:y] if row_max.nil? || row_max < pos[:y]
    row_min = pos[:y] if row_min.nil? || row_min > pos[:y]
  end

  for row in row_min..row_max do
    for col in col_min..col_max do
      if canvas[col][row]
        print '#'
      else
        print '.'
      end
    end
    print "\n"
  end

  nil
end

result = answer(input)

puts result.inspect
