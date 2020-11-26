input = File.readlines('data')

def answer(barcodes)
  lowest = Float::INFINITY
  result = [ nil, nil ]

  barcodes_as_chars = barcodes.map { |b| b.strip.chars }
  
  while barcodes_as_chars.size > 0
    code_1 = barcodes_as_chars.pop
    barcodes_as_chars.each do |code_2|
      raise "Barcodes are not the same length" unless code_1.size == code_2.size
      differences = 0
      code_1.each.with_index do |char,i|
        differences += 1 unless char == code_2[i]
      end
      if differences < lowest
        result = [ code_1, code_2 ]
        lowest = differences
      end
    end
  end

  result
end

def common_letters(ary_1, ary_2)
  result = Array.new
  ary_1.each.with_index do |char,i|
    result.push char if char == ary_2[i]
  end
  result
end 

result = answer(input)
result = common_letters(result[0], result[1]).join
puts result
