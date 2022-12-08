insts = File.readlines("in/day_07.txt", chomp: true).map{ |x| x.split(" ") }
dirs = { "/" => 0 }
paths = dirs.keys
insts.each do |inst|
    case inst
    in ["$", "cd", "/"]
        paths = ["/"]
    in ["$", "cd", ".."]
        paths.pop
    in ["$", "cd", path]
        paths.push("#{paths[-1]}#{path}/")
    in ["$", "ls"]
    in ["dir", name]
        dirs["#{paths[-1]}#{name}/"] = 0
    in [size, name]
        paths.each{ |path| dirs[path] += size.to_i }
    end
end
dir_sizes = dirs.values.sort
unused_space = 70000000 - dirs["/"]
small_total_size = dir_sizes.take_while{ |x| x < 100000 }.sum
delete_size = dir_sizes.select{ |x| unused_space + x >= 30000000 }.sort[0]
puts "total size of directories smaller than 100000"
puts small_total_size
puts "\nthe size of the smallest directory to delete to free enough space"
puts delete_size
