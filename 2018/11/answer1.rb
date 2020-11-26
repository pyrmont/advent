input = ARGV[0]

def answer(input)
  serial_no = serial_no(input)
  levels = levels(serial_no)
  largest(levels)
end

def serial_no(input)
  input.to_i
end

def levels(serial_no)
  grid = Hash.new
  
  for x in 1..300 do
    rack_id = x + 10
    for y in 1..300 do
      level = ((((rack_id * y) + serial_no) * rack_id) / 100 % 10) - 5
      grid["#{x}, #{y}"] = level
    end
  end

  grid
end

def largest(grid)
  grid.max do |a,b|
    square(grid, a[0]) <=> square(grid, b[0])
  end
end

def square(grid, coords)
  x, y = coords.split(', ').map(&:to_i)
  sum = 0
  
  for i in 0..2 do
    for j in 0..2 do
      level = grid["#{x + i}, #{y + j}"]
      return -(Float::INFINITY) if level.nil?
      sum += level
    end
  end

  sum
end
   
result = answer(input)

puts result.inspect
