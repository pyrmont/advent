input = File.readlines ARGV[0]

def answer(input)
  map, carts = initial_state(input)
  play(map, carts)
end

def initial_state(lines)
  map = Hash.new { |h,k| h[k] = Hash.new }
  carts = Array.new

  lines.each.with_index do |line,y|
    line.each_char.with_index do |char,x|
      next if char == " " || char == "\n"
      case char
      when "<", ">"
        map[x][y] = "-"
        carts.push({ x: x, y: y, turns: 0, dir: char == ">" ? :right : :left })
      when "^", "v"
        map[x][y] = "|"
        carts.push({ x: x, y: y, turns: 0, dir: char == "^" ? :up : :down })
      else
        map[x][y] = char
      end
    end
  end

  [ map, carts ]
end

def play(map, carts)
  tick = 0

  loop do
    waiting = Array.new

    while cart = carts.shift
      cart, map = move(cart, map)
      if other_cart = (crash(cart, carts) || crash(cart, waiting))
        carts.delete(other_cart)
      else
        waiting.push(cart)
      end
    end

    carts = waiting

    carts.sort! do |a,b|
      if a[:y] == b[:y]
        a[:x] <=> b[:x]
      else
        a[:y] <=> b[:y]
      end
    end

    tick += 1
    puts tick

    break carts if carts.size == 1
  end
end

def move(cart, map)
  case cart[:dir]
  when :up
    cart[:y] += -1
    next_seg = map[cart[:x]][cart[:y]]
    case next_seg
    when "\\"
      cart[:dir] = :left
    when "/"
      cart[:dir] = :right
    when "+"
      cart = turn(cart)
    end
  when :down
    cart[:y] += 1
    next_seg = map[cart[:x]][cart[:y]]
    case next_seg
    when "\\"
      cart[:dir] = :right
    when "/"
      cart[:dir] = :left
    when "+"
      cart = turn(cart)
    end
  when :left
    cart[:x] += -1
    next_seg = map[cart[:x]][cart[:y]]
    case next_seg
    when "\\"
      cart[:dir] = :up
    when "/"
      cart[:dir] = :down
    when "+"
      cart = turn(cart)
    end
  when :right
    cart[:x] += 1
    next_seg = map[cart[:x]][cart[:y]]
    case next_seg
    when "\\"
      cart[:dir] = :down
    when "/"
      cart[:dir] = :up
    when "+"
      cart = turn(cart)
    end
  end

  [ cart, map ]
end

def turn(cart)
  case cart[:turns] % 3
  when 0
    cart[:dir] = rotate(:left, cart[:dir])
  when 2
    cart[:dir] = rotate(:right, cart[:dir])
  end

  cart[:turns] += 1
  cart
end

def rotate(dir, start)
  case start
  when :up
    dir == :left ? :left : :right
  when :down
    dir == :left ? :right : :left
  when :left
    dir == :left ? :down : :up
  when :right
    dir == :left ? :up : :down
  end
end

def crash(cart, carts)
  carts.find do |other|
    other != cart && other[:x] == cart[:x] && other[:y] == cart[:y]
  end
end

result = answer(input)

puts result.inspect
