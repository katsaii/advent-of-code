require "fileutils"

data = if File.file?("input")
    File.read("input")
else
    puts "input file doesn't exist"
    ""
end
valid_sled = 0
valid_toboggan = 0
data.scan(/(\d+)\s*-\s*(\d+)\s+(.):\s*([^\s]*)/) do |x|
    min = x[0].to_i
    max = x[1].to_i
    target = x[2]
    pass = x[3]
    count = 0
    # sled
    pass.each_char do |c|
        if c != target
            next
        end
        count += 1
        if count > max
            break
        end
    end
    if count >= min and count <= max
        valid_sled += 1
    end
    # toboggan
    if (pass[min - 1] == target) != (pass[max - 1] == target)
        valid_toboggan += 1
    end
end
puts "valid passwords according to the sled policies\n#{valid_sled}"
puts "\nvalid passwords according to the toboggan policies\n#{valid_toboggan}"
