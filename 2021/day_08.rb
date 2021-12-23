lines = File.readlines("in/day_08.txt", chomp: true)
notes = lines.map{|line| line.split(" | ").map{|x| x.split(" ")}}
unique_digit_count = 0
notes.each do |_, output|
    unique_digits = output.filter{|digit| [2, 3, 4, 7].include?(digit.length)}
    unique_digit_count += unique_digits.length
end
puts "number of times the digits 1, 4, 7, and 8 appear"
puts unique_digit_count
