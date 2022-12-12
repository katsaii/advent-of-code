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
		if y + dy < 1 || x + dx < 1 || y + dy > height || x + dx > width || (y + dy, x + dx) in edges.keys
			continue
		end
		function convert_signal(v)
			return v == 'S' ? 'a' : v == 'E' ? 'z' : v
		end
		curr = field[y, x]
		dest = field[y + dy, x + dx]
		if convert_signal(dest) + 1 < convert_signal(curr)
			continue
		end
		edges[(y + dy, x + dx)] = (y, x)
		push!(frontier, (y + dy, x + dx))
	end
end
steps = 0
while edges[start] != (-1, -1)
	global steps += 1
	global start = edges[start]
end
@show steps
