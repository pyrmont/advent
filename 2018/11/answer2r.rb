@cache = Hash.new { |h,k| h[k] = Hash.new { |i,l| i[l] = Hash.new } }
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
  coords = nil
  largest = nil
  longest = 0
  
  grid.reverse_each do |k,v|
    puts k.inspect
    level, size = square(grid, k)
    if largest.nil? || level > largest
      coords = k
      largest = level
      longest = size
    end
  end
  
  [ coords, longest ]
end

def square(grid, coords)
  x, y = coords.split(', ').map(&:to_i) 
  length = (x < y) ? 300 - y + 1 : 300 - x + 1
  max = nil
  size = nil
  top = nil
  left = nil

  (1..length).each do |l|
    if l == 1
      level = grid[coords]
      max = level
      size = l
      top = level
      left = 0
    else
      margin = l - 1
      top += grid["#{x + margin}, #{y}"] 
      left += grid["#{x}, #{y + margin}"] 
      level = top + left + @cache[x + 1][y + 1][margin]
      if level > max
        max = level
        size = l
      end
    end
    
    @cache[x][y][l] = level
  end

  [ max, size ]
end
   
result = answer(input)

puts result.inspect
