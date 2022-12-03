priorities = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
rucksacks = File.readlines("in/day_03.txt", chomp: true).map do |line|
    line.split("").map{ |item| priorities.index(item) }
end
total = 0
rucksacks.each do |rucksack|
    lhs, rhs = rucksack.each_slice((rucksack.size / 2).round).to_a
    duplicates = lhs & rhs
    duplicates.each do |duplicate|
        total += duplicate + 1
    end
end
total_badges = 0
rucksacks.each_slice(3) do |rucksack1, rucksack2, rucksack3|
    duplicates = rucksack1 & rucksack2 & rucksack3
    duplicates.each do |duplicate|
        total_badges += duplicate + 1
    end
end
puts "sum of priorities of duplicate items in each rucksack"
puts total
puts "\nsum of priorities of badges"
puts total_badges
