input = File.readlines 'data'

def answer(input)
  records = records(input)
  shifts = shifts(records)
  guards = guards(shifts)
  result = sleepiest(guards)
  [ result[0], result[1][:mins].max { |a,b| a[1] <=> b[1] }[0] ]
end

def records(input)
  input.map { |line| record(line.strip) }.sort do |a,b|
    if a[0] == b[0]
      a[1] <=> b[1]
    else
      a[0] <=> b[0]
    end
  end
end

def record(input)
  portion = input.scan /\[(\d+-\d+-\d+) (\d+:\d+)\] (.+)/
  portion.flatten!
end

def shifts(records)
  shifts = Array.new

  for i in 0...records.size do
    date = records[i][0]
    time = records[i][1]
    note = records[i][2]

    if note.include? 'Guard'
      shift = { no: guard_no(note), awake: Array.new, asleep: Array.new }
      shift[:awake].push time
      shifts.push shift
    elsif note.include? 'wakes'
      shifts.last()[:awake].push time
    elsif note.include? 'falls'
      shifts.last()[:asleep].push time
    end
  end

  shifts
end

def guard_no(note)
  note.scan(/Guard #(\d+) .+/)[0][0].to_i
end

def guards(shifts)
  guards = Hash.new { |h,k| h[k] = { count: 0, mins: Hash.new { |i,l| i[l] = 0 } } }
  
  shifts.each do |s|
    guard = guards[s[:no]]
    naps = naps(s[:awake], s[:asleep])
    for i in 0..59 do
      next unless asleep?(naps, i)
      guard[:count] += 1
      guard[:mins][i] += 1
    end
  end
  
  guards
end

def naps(wakes, falls)
  falls.map.with_index do |fall, i|
    (fall.split(':')[1].to_i)...(wakes[i+1].split(':')[1].to_i)
  end
end

def asleep?(naps, i)
  naps.any? do |n|
    n.include? i
  end
end

def sleepiest(guards)
  guards.max do |a,b| 
    if a[1][:mins].empty? && b[1][:mins].empty?
      a <=> b
    elsif a[1][:mins].empty?
      -1
    elsif b[1][:mins].empty?
      1
    else
      min_a = a[1][:mins].max { |c,d| c[1] <=> d[1] }[1]
      min_b = b[1][:mins].max { |c,d| c[1] <=> d[1] }[1]
      min_a <=> min_b
    end
  end
end

result = answer(input)
puts result.inspect
puts (result[0] * result[1])
