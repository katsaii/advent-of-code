field = permutedims(hcat(map(collect, readlines("in/day_12.txt"))...))
height, width = size(field)
start = Tuple(findall(==('S'), field)[1])
exit = Tuple(findall(==('E'), field)[1])
frontier = Vector([exit])
edges = Dict(exit=>(-1, -1))
while !isempty(frontier)
	(y, x) = frontier[1]
	deleteat!(frontier, 1)
	neighbours = [(1, 0), (-1, 0), (0, 1), (0, -1)]
	for (dy, dx) in neighbours
		y2, x2 = y + dy, x + dx
		if y2 < 1 || x2 < 1 || y2 > height || x2 > width || (y2, x2) in edges.keys
			continue
		end
		convert_signal(v) = v == 'S' ? 'a' : v == 'E' ? 'z' : v
		if convert_signal(field[y2, x2]) + 1 < convert_signal(field[y, x])
			continue
		end
		edges[(y2, x2)] = (y, x)
		push!(frontier, (y2, x2))
	end
end
function path_length(dest)
	steps = 0
	while haskey(edges, dest) && edges[dest] != (-1, -1)
		steps += 1
		dest = edges[dest]
	end
	steps, dest
end
shortest_path = typemax(Int)
for y = 1:height
	for x = 1:width
		if field[y, x] != 'a'
			continue
		end
		length, root = path_length((y, x))
		if length < shortest_path && root == exit
			global shortest_path = length
		end
	end
end
println("shortest path between the start and end of the trail")
println(path_length(start)[1])
println("\nshortest possible path from the bottom of the mountain to the end of the trail")
println(shortest_path)
