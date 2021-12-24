lines = File.readlines("in/day_08.txt", chomp: true)
lines = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]
notes = lines.map{|line| line.split(" | ").map{|x| x.split(" ")}}
unique_digit_count = 0
notes.each do |_, output|
    unique_digits = output.filter{|digit| [2, 3, 4, 7].include?(digit.length)}
    unique_digit_count += unique_digits.length
end
notes.each do |signals, _|
    all_options = ["a", "b", "c", "d", "e", "f", "g"]
    option_choices = { }
    all_options.each do |option|
        option_choices[option] = all_options
    end
    signals.each do |signal|
        new_choices = case signal.length
            when 2 then ["c", "f"]
            when 3 then ["a", "c", "f"]
            when 4 then ["b", "c", "d", "f"]
            else all_options
        end
        signal.split("") do |option|
            option_choices[option] = option_choices[option] & new_choices
        end
    end
    puts option_choices
end
puts "number of times the digits 1, 4, 7, and 8 appear"
puts unique_digit_count
