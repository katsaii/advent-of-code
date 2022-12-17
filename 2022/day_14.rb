require "set"
$field = Set[]
File.readlines("in/day_14.txt", chomp: true).map do |line|
    points = line.split(" -> ").map{ |pair| pair.split(",").map{ |x| x.to_i } }
    x1, y1 = points[0]
    points.drop(1).each do |x2, y2|
        x1.step(x2, x2 < x1 ? -1 : 1) do |x|
            y1.step(y2, y2 < y1 ? -1 : 1) do |y|
                $field.add([x, y])
            end
        end
        x1, y1 = x2, y2
    end
end
y_limit = $field.map{ |_, y| y }.max
def simulate &block
    sand = $field.clone
    iterations = 0
    loop do
        endx, endy, complete = yield [500, 0, sand]
        if complete
            break
        end
        sand.add([endx, endy])
        iterations += 1
    end
    iterations
end
iterations = simulate do |startx, starty, sand|
    x, y = startx, starty
    stablised = false
    while y <= y_limit
        if !sand.include?([x, y + 1])
            y += 1
        elsif !sand.include?([x - 1, y + 1])
            x -= 1
            y += 1
        elsif !sand.include?([x + 1, y + 1])
            x += 1
            y += 1
        else
            stablised = true
            break
        end
    end
    [x, y, !stablised]
end
iterations_floor = simulate do |startx, starty, sand|
    x, y = startx, starty
    complete = sand.include?([startx, starty])
    loop do
        if y > y_limit
            break
        elsif !sand.include?([x, y + 1])
            y += 1
        elsif !sand.include?([x - 1, y + 1])
            x -= 1
            y += 1
        elsif !sand.include?([x + 1, y + 1])
            x += 1
            y += 1
        else
            break
        end
    end if !complete
    [x, y, complete]
end
puts "number of iterations for particles to fall into the void"
puts iterations
puts "\nnumber of iterations for particles to fill the board with a floor"
puts iterations_floor
