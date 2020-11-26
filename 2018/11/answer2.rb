@cache = Hash.new

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
  size = 0
  largest = grid.max do |a,b|
    puts [ a[0], b[0] ].inspect
    a_max, a_size = square(grid, a[0])
    size = a_size if a_size > size
    b_max, b_size = square(grid, b[0])
    size = b_size if b_size > size 
    a_max <=> b_max
  end
  [ largest, size ]
end

def square(grid, coords)
  return @cache[coords] unless @cache[coords].nil?

  x, y = coords.split(', ').map(&:to_i)
  sum = 0
  size = 0
  max_sum = nil
  max_size = (x < y) ? 300 - y : 300 - x

  (0..max_size).each do |s|
    (0..s-1).each do |t|
      sum += grid["#{x + t}, #{y + s}"]
      sum += grid["#{x + s}, #{y + t}"]
    end
    
    sum += grid["#{x + s}, #{y + s}"]

    if max_sum.nil? || max_sum < sum
      max_sum = sum
      size = s
    end
  end

  @cache[coords] = [ max_sum, size ]
end
   
result = answer(input)

puts result.inspect
