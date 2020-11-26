input = File.readlines 'data'

def answer(input)
  claims = input.map { |line| claim(line.strip) }
  unique claims
end

def claim(input)
  portion = input.split(' ')

  { id: id(portion[0]),
    left: left(portion[2]),
    top: top(portion[2]),
    width: width(portion[3]),
    height: height(portion[3]),
    clash: false }
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

def unique(claims)
  fabric = Hash.new { |h,k| h[k] = Hash.new(false) }
  
  claims.each do |claim|
    claim[:width].times do |w|
      claim[:height].times do |h|
        x = claim[:left] + w
        y = claim[:top] + h
        if other = fabric[x][y]
          other[:clash] = true
          claim[:clash] = true
        else
          fabric[x][y] = claim
        end
      end
    end
  end

  claims.reject { |obj| obj[:clash] }
end

puts answer(input)
