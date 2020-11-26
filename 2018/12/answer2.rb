input = File.readlines ARGV[0]

def answer(input)
  state = initial_state(input[0])
  rules = rules(input)
  state, start, finish = end_state(state, rules)
  sum_pots(state, start, finish)
end

def initial_state(line)
  state = Hash.new
  
  line.strip.split(': ')[1].split('').each.with_index do |char,i|
    state[i] = char == '#'
  end

  state
end

def rules(input)
  rules = Hash.new { |h1,k1| h1[k1] = Hash.new {
                     |h2,k2| h2[k2] = Hash.new {
                     |h3,k3| h3[k3] = Hash.new {
                     |h4,k4| h4[k4] = Hash.new } } } }

  input[2..-1].each do |line|
    i, o = line.strip.split(' => ')
    k1, k2, k3, k4, k5 = i.split('').map { |k| k == '#' }
    rules[k1][k2][k3][k4][k5] = (o == '#')
  end

  rules
end

def end_state(state, rules)
  start = 0
  finish = 99
  old_state = Hash.new
  new_state = Hash.new

  (1..ARGV[1].to_i).each do |gen|
    new_state = Hash.new
    state, start, finish = pad(state, start, finish)
    (start..finish).each do |i|
      if i < (start + 2) || i > finish - 2
        new_state[i] = false
      else
        new_state[i] = rules[state[i - 2]][state[i - 1]][state[i]][state[i + 1]][state[i + 2]]
      end
    end
    state = new_state
  end

  [ state, start, finish ]
end

def pad(state, start, finish)
  front = state[start] || state[start + 1] || state[start + 2]
  back = state[finish - 2] || state[finish - 1] || state[finish]
  return [ state, start, finish ] if !front && !back

  (1..3).each do |i| 
    state[start - i] = false if front
    state[finish + i] = false if back
  end

  new_start = start
  new_finish = finish

  if front
    (0..Float::INFINITY).each do |i|
      new_start = start - 3 + i
      break if state[start + i]
    end
  end
    
  if back
    (0..Float::INFINITY).each do |i|
      new_finish = finish + 3 - i
      break if state[finish - i]
    end
  end

  [ state, new_start, new_finish ]
end

def sum_pots(state, start, finish)
  total = 0
  (start..finish).each do |i|
    total += i if state[i]
  end
  total
end

result = answer(input)

puts result.inspect
