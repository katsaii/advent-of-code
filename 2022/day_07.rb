def file_create(name, size, parent)
    file = {
        :name => name,
        :size => size,
        :children => { },
        :parent => parent,
    }
    if parent != nil
        parent[:children][name] = file
        while parent != nil
            parent[:size] += size
            parent = parent[:parent]
        end
    end
    file
end

insts = File.readlines("in/day_07.txt", chomp: true).map{ |x| x.split(" ") }
root = file_create("/", 0, nil)
cwd = root
dirs = [root]
insts.each do |inst|
    case inst
    in ["$", "cd", "/"]
        cwd = root
    in ["$", "cd", ".."]
        cwd = cwd[:parent]
    in ["$", "cd", path]
        cwd = cwd[:children][path]
    in ["$", "ls"]
    in ["dir", name]
        dirs << file_create(name, 0, cwd)
    in [size, name]
        file_create(name, size.to_i, cwd)
    end
end
dir_sizes = dirs.map{ |x| x[:size] }.sort
total_size = root[:size]
unused_space = 70000000 - total_size
small_total_size = dir_sizes.take_while{ |x| x < 100000 }.sum
delete_size = dir_sizes.select{ |x| unused_space + x >= 30000000 }.sort[0]

puts small_total_size

puts delete_size
