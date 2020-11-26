input = File.readlines ARGV[0]

def answer(input)
  state = initial_state(input[0])
  rules = rules(input)
  state, origin = end_state(state, rules)
  sum_pots(state, origin)
end

def initial_state(line)
  state = line.strip.split(': ')[1]
end

def rules(input)
  rules = Hash.new
  input[2..-1].each do |line|
    k, v = line.strip.split(' => ')
    rules[k] = v
  end
  rules
end

def end_state(state, rules)
  origin = 0
  new_state = ''

  (1..ARGV[1].to_i).each do |gen|
    puts gen
    state, origin = pad(state, origin)
    length = state.length
    (0...length).each do |i|
      if i < 2
        new_state[i] = '.'
      elsif i > length - 3
        new_state[i] = '.'
      else
        chunk = state[(i - 2)..(i + 2)]
        new_state[i] = rules[chunk]
      end
    end
    old_state = state
    state = new_state
    new_state = old_state
  end

  [ state, origin ]
end

def pad(state, origin)
  front = state[0..2] == '...'
  back = state[-3..-1] == '...'
  return [ state, origin ] if front && back

  if front
    state = state + '...'
  elsif back
    state = '...' + state
    origin += 3
  else
    state = '...' + state + '...'
    origin += 3
  end

  [ state, origin ]
end

def sum_pots(state, origin)
  total = 0
  state.each_char.with_index do |char,i|
    pot = i - origin
    total += pot if char == '#'
  end
  total
end

result = answer(input)

puts result.inspect
