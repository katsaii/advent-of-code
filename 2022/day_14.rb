require "set"
field = Set[]
File.readlines("in/day_14.txt", chomp: true).map do |line|
    points = line.split(" -> ").map{ |pair| pair.split(",").map{ |x| x.to_i } }
    x1, y1 = points[0]
    points.drop(1).each do |x2, y2|
        x1.step(x2, x2 < x1 ? -1 : 1) do |x|
            y1.step(y2, y2 < y1 ? -1 : 1) do |y|
                field.add([x, y])
            end
        end
        x1, y1 = x2, y2
    end
end
y_limit = field.map{ |_, y| y }.max
sand = field.clone
iterations = 0
loop do
    stablised = false
    sx, sy = 500, 0
    while sy <= y_limit
        if !sand.include?([sx, sy + 1])
            sy += 1
        elsif !sand.include?([sx - 1, sy + 1])
            sx -= 1
            sy += 1
        elsif !sand.include?([sx + 1, sy + 1])
            sx += 1
            sy += 1
        else
            stablised = true
            break
        end
    end
    if !stablised
        break
    end
    sand.add([sx, sy])
    iterations += 1
end
puts iterations
