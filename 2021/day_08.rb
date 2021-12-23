lines = File.readlines("in/day_08.txt", chomp: true)
notes = lines.map{|line| line.split(" | ").map{|x| x.split(" ")}}
