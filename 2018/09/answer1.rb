input = File.readlines ARGV[0]

def answer(input)
  no_players, last_marble = details(input)
  board = play_game(no_players, last_marble)
  find_highest(board)
end

def details(input)
  result = input.pop.scan(/(\d+) players; last marble is worth (\d+) points/).pop
  result.map(&:to_i)
end

def play_game(no_players, last_marble)
  board = Array.new
  scores = Hash.new { |h,k| h[k] = Array.new }
  current_player = 0
  current_marble = 0
  for i in 0..last_marble do
    current_player = next_player(current_player, no_players)
    board, current_marble, taken = add_marble(board, current_marble, i)
    next if taken.empty?
    taken.each { |t| scores[current_player].push t }
  end

  scores
end

def next_player(current, no_players)
  next_number = current + 1
  if next_number > no_players
    1
  else
    next_number
  end
end

def add_marble(board, current, marble)
  if board.size < 2
    board.push marble
    current = board.size - 1
    return [ board, current, Array.new ]
  end

  if marble % 23 == 0
    board, current, removed = remove_marble(board, current)
    return [ board, current, [ marble, removed ] ]
  end

  pos = current + 2
  two_cw = if pos > board.size
             1
           else
             pos
           end

  board = board.insert(two_cw, marble)
  current = two_cw
  [ board, current, Array.new ]
end

def remove_marble(board, current)
  diff = current - 7
  pos = diff < 0 ? board.size + diff : diff
  removed = board.slice!(pos)
  [ board, pos, removed ]
end

def find_highest(scores)
  highest = scores.max { |a,b| a[1].sum <=> b[1].sum }
  highest[1].sum
end

result = answer(input)

puts result.inspect
