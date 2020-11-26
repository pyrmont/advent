input = File.readlines ARGV[0]

def answer(input)
  state = initial_state(input[0])
  rules = rules(input)
  state = end_state(state, rules)
  sum_pots(state)
end

def initial_state(line)
  state = line.strip.split(': ')[1]
end

def rules(input)
  input[2..-1].map { |line| line.strip.split(' => ') }
end

def end_state(state, rules)
  result = nil
  side = '...'

  (1..20).each do |gen|
    new_state = ''
    state = side + state + side
    (2...(state.length - 2)).each do |i|
      chunk = state.slice((i - 2)..(i + 2))
      rule = rules.find { |r| r[0] == chunk } 
      new_state += rule[1]
    end
    state = new_state
  end

  state
end

def sum_pots(state)
  total = 0
  state.split('').each.with_index do |char,i|
    total += i - 20 if char == '#'
  end
  total
end

result = answer(input)

puts result.inspect
