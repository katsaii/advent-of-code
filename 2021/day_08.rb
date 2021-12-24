lines = File.readlines("in/day_08.txt", chomp: true)
notes = lines.map{|line| line.split(" | ").map{|x| x.split(" ")}}
unique_digit_count = 0
notes.each do |_, output|
    unique_digits = output.filter{|digit| [2, 3, 4, 7].include?(digit.length)}
    unique_digit_count += unique_digits.length
end
output_sum = 0
notes.each do |signals, output|
    digits = Array.new(10, [])
    signals.each do |signal|
        signal = signal.split("").map{|x| x.to_sym}
        candidates = case signal.length
            when 2 then [1]
            when 3 then [7]
            when 4 then [4]
            when 5 then [2, 3, 5]
            when 6 then [0, 6, 9]
            when 7 then [8]
            else []
        end
        candidates.each do |digit|
            digits[digit] = digits[digit] | [signal]
        end
    end
    digits = digits.map{|candidates| candidates.length == 1 ? candidates[0] : candidates}
    digits[2] = digits[2].find{|candidate| (candidate - digits[4]).length == 3}
    digits[3] = digits[3].find{|candidate| (digits[1] - candidate).empty?}
    digits[5] = digits[5].find{|candidate| candidate != digits[2] && candidate != digits[3]}
    digits[6] = digits[6].find{|candidate| (candidate - digits[7]).length == 4}
    digits[9] = digits[9].find{|candidate| ((digits[3] | digits[4]) - candidate).empty?}
    digits[0] = digits[0].find{|candidate| candidate != digits[6] && candidate != digits[9]}
    digits = digits.map{|digit| digit.sort}
    output_value = 0
    output_unit = 1000
    output.each do |output_digit|
        output_digit = output_digit.split("").map{|x| x.to_sym}.sort
        output_value += output_unit * digits.find_index(output_digit)
        output_unit /= 10
    end
    output_sum += output_value
end
puts "number of times the digits 1, 4, 7, and 8 appear"
puts unique_digit_count
puts "\nsum of output values for the display"
puts output_sum
