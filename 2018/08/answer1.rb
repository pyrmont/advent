input = File.readlines 'data'

def answer(input)
  numbers = numbers(input)
  tree = tree(numbers)
  puts tree.inspect
  # output(tree)
  metadata_sum(tree)
end

def output(node)
  print node[:children].count
  print ' '
  print node[:metadata].count
  print ' '
  node[:children].each do |c|
    output(c)
  end
end

def numbers(input)
  input.join.split(' ' ).map(&:to_i)
end

def tree(numbers)
  parse(numbers)
end

def parse(numbers)
  num_children = numbers.shift
  num_metadata = numbers.shift
  
  node = node(num_children, num_metadata)
  
  num_children.times do |i|
    child = parse(numbers)
    node[:children].push child
  end

  num_metadata.times do |i|
    datum = numbers.shift
    puts datum
    node[:metadata].push datum
  end

  node
end

def node(num_children, num_metadata)
  { header: "#{num_children} #{num_metadata}", children: Array.new, metadata: Array.new }
end

def metadata_sum(node)
  sum_this = node[:metadata].sum
  sum_children = node[:children].reduce(0) { |t,c| t + metadata_sum(c) } 
  sum_this + sum_children
end

result = answer(input)

puts result.inspect
