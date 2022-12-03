priorities = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
rucksacks = File.readlines("in/day_03.txt", chomp: true).map do |line|
    line.split("").map{ |item| priorities.index(item) }
end
total = 0
rucksacks.each do |rucksack|
    lhs, rhs = rucksack.each_slice((rucksack.size / 2).round).to_a
    dup = lhs & rhs
    dup.each do |duplicate|
        total += duplicate + 1
    end
end

puts total
