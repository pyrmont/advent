input = File.readlines ARGV[0]

def answer(input)
  no_players, last_marble = details(input)
  board = play_game(no_players, last_marble * 100)
  find_highest(board)
end

def details(input)
  result = input.pop.scan(/(\d+) players; last marble is worth (\d+) points/).pop
  result.map(&:to_i)
end

def play_game(no_players, last_marble)
  scores = Hash.new { |h,k| h[k] = Array.new }
  current_player = 0
  current_marble = nil
  for i in 0..last_marble do
    current_player = next_player(current_player, no_players)
    current_marble, taken = add_marble(current_marble, i)
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

def add_marble(current, marble)
  if current.nil?
    current = Node.new(marble)
    return [ current, Array.new ]
  end

  if marble % 23 == 0
    current, removed = remove_marble(current)
    return [ current, [ marble, removed ] ]
  end

  current = current.next.insert(marble)

  [ current, Array.new ]
end

def remove_marble(current)
  7.times do
    current = current.prev
  end
  removed = current
  current = current.remove
  [ current, removed.data ]
end

def find_highest(scores)
  highest = scores.max { |a,b| a[1].sum <=> b[1].sum }
  highest[1].sum
end

class Node
  attr_accessor :data, :prev, :next

  def initialize(data)
    @data = data
    @prev = self
    @next = self
  end

  def insert(data)
    new_next = Node.new(data)
    old_next = self.next
    
    new_next.prev = self
    new_next.next = old_next
    
    old_next.prev = new_next
    
    self.next = new_next

    new_next
  end

  def remove()
    old_prev = self.prev
    old_next = self.next

    old_prev.next = old_next
    old_next.prev = old_prev

    self.prev = nil
    self.next = nil
    
    old_next
  end
end  

result = answer(input)

puts result.inspect
