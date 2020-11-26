input = File.readlines 'data'

def answer(input)
  numbers = numbers(input)
  tree = tree(numbers)
  metadata_sum(tree)
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
    node[:metadata].push datum
  end

  node
end

def node(num_children, num_metadata)
  { header: "#{num_children} #{num_metadata}", children: Array.new, metadata: Array.new }
end

def metadata_sum(node)
  if node[:children].empty?
    node[:metadata].sum
  else
    node[:metadata].reduce(0) do |t,r|
      if node[:children].count < r
        t + 0
      else
        t + metadata_sum(node[:children][r-1])
      end
    end
  end
end

result = answer(input)

puts result.inspect
