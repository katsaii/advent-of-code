lines = readlines("in/day_05.txt")
lines = map((x) -> split(x, r",|( -> )"), lines)
lines = collect(Iterators.flatten(lines))
lines = map((x) -> parse(Int64, x), lines)
lines = reshape(lines, 4, :)'
size_x = maximum([lines[:, 1]; lines[:, 3]]) + 1
size_y = maximum([lines[:, 2]; lines[:, 4]]) + 1
axis_votes = zeros(Int64, size_x, size_y)
diag_votes = zeros(Int64, size_x, size_y)
for row in eachrow(lines)
    step_x = sign(row[3] - row[1])
    step_y = sign(row[4] - row[2])
    xs = step_x == 0 ? Iterators.cycle(row[1]) : (row[1]:step_x:row[3])
    ys = step_y == 0 ? Iterators.cycle(row[2]) : (row[2]:step_y:row[4])
    target = step_x == 0 || step_y == 0 ? axis_votes : diag_votes
    for (x, y) in zip(xs, ys)
        target[x, y] += 1
    end
end
println("sum of votes greater than 2 for axis-aligned points")
println(sum((x) -> x >= 2, axis_votes))
println()
println("sum of votes greater than 2 for axis-aligned and diagonal points")
println(sum((x) -> x >= 2, axis_votes + diag_votes))
