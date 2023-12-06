lines = File.readlines("in/day_01.txt", chomp: true)
calibrations_digit = lines.map do |line|
    digits = line.scan(/[0-9]/)
    (digits[0] + digits[-1]).to_i
end
nums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
nums_r = nums.map{ |x| x.reverse }
calibrations_all = lines.map do |line|
    ldigits = line.scan(/[1-9]|#{nums.join("|")}/)
    rdigits = line.reverse.scan(/[1-9]|#{nums_r.join("|")}/)
    ldigit = nums.include?(ldigits[0]) ? (nums.index(ldigits[0]) + 1).to_s : ldigits[0]
    rdigit = nums_r.include?(rdigits[0]) ? (nums_r.index(rdigits[0]) + 1).to_s : rdigits[0]
    (ldigit + rdigit).to_i
end
puts "calibrations only including numeric digits"
puts calibrations_digit.sum
puts "\ncalibrations including both numeric and written digits"
puts calibrations_all.sum
