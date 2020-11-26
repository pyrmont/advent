input = File.readlines 'data'

def answer(input)
  claims = input.map { |line| claim(line.strip) }
  count claims
end

def claim(input)
  portion = input.split(' ')

  { id: id(portion[0]),
    left: left(portion[2]),
    top: top(portion[2]),
    width: width(portion[3]),
    height: height(portion[3]) }
end

def id(input)
  input.slice(1..-1).to_i
end

def left(input)
  input.split(',')[0].to_i
end

def top(input)
  input.split(',')[1].slice(0..-2).to_i
end

def width(input)
  input.split('x')[0].to_i
end

def height(input)
  input.split('x')[1].to_i
end

def count(claims)
  fabric = Hash.new { |h,k| h[k] = Hash.new(0) }
  
  claims.each do |claim|
    claim[:width].times do |w|
      claim[:height].times do |h|
        fabric[claim[:left] + w][claim[:top] + h] += 1
      end
    end
  end

  result = 0

  fabric.values.each do |w|
    w.values.each do |h|
      result += 1 if h > 1
    end
  end

  result
end

puts answer(input)
