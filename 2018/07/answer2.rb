input = File.readlines 'data'

def answer(input)
  conditions = conditions(input)
  steps, seconds = steps(conditions)
  [ steps.join, seconds ]
end

def conditions(lines)
  conditions = Hash.new { |h,k| h[k] = Array.new }
  
  lines.each do |line|
    rel = line.scan(/[S|s]tep ([A-z])/).flatten
    conditions[rel[0]]
    conditions[rel[1]].push rel[0]
  end

  conditions
end

def steps(conditions)
  steps = Array.new
  seconds = 0

  workers = Array.new(5) { { step: Array.new, time: 0 } }
  letters = ('A'..'Z').to_a

  loop do
    break if letters.empty? && workers.all? { |w| w[:step].empty? }
    
    workers.each do |w|
      next if letters.empty? && w[:step].empty?

      finished = w[:step].count > 0 && w[:time] == 0
      if finished
        step = w[:step].pop
        conditions.each { |k,v| v.delete(step) }
        steps.push step
      end

      waiting = w[:step].empty? || w[:time] == 0
      if waiting
        assign_step(w, next_letter(letters, conditions))
      end
      
      work(w)
    end

    seconds += 1
  end

  [ steps, seconds ]
end

def assign_step(worker, step)
  return unless step

  worker[:step].push step
  worker[:time] = (step.ord - 64) + 60
end

def next_letter(letters, conditions)
  result = letters.find { |letter| conditions[letter].empty? }
  letters.delete(result)
end

def work(worker)
  return if worker[:step].empty?
  worker[:time] -= 1
end

result = answer(input)

puts result.inspect
