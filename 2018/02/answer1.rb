input = File.readlines('data')

def count(barcodes)
  doubles = 0
  triples = 0
  
  barcodes.each do |barcode|
    twice = false
    thrice = false
    characters = barcode.strip.chars
    characters.uniq.each do |letter|
      case characters.count(letter)
      when 3
        thrice = true
      when 2
        twice = true
      end
    end
    doubles += 1 if twice
    triples += 1 if thrice
  end

  { doubles: doubles, triples: triples }
end

result = count(input)
puts result[:doubles] * result[:triples] 
