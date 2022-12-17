re = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
const sensors = [
	tuple([parse(Int64, n) for n in match(re, line).captures]...)
	for line in readlines("in/day_15.txt")
]
const spans = Dict{Int64, Vector{Tuple{Int64, Int64}}}([])
const manhatten(x1, y1, x2, y2) = abs(x2 - x1) + abs(y2 - y1)
function add_span(x, y1, y2)
	if !haskey(spans, x)
		spans[x] = Vector([])
	end
	push!(spans[x], (y1, y2))
end
for (sx, sy, bx, by) in sensors
	r = manhatten(sx, sy, bx, by)
	add_span(sx, sy - r, sy + r)
	for i in 1:r
		for dir in [-1, 1]
			add_span(sx + i * dir, sy - r + i, sy + r - i)
		end
	end
end
for (_, span) in spans
	sort!(span, by = x -> x[1])
end
function resolve_collision(x::Int64, y::Int64)
	dy = 0
	if haskey(spans, x)
		for (ystart, yend) in spans[x]
			if y + dy < ystart
				break
			end
			if y + dy <= yend
				dy += 1 + yend - (y + dy)
			end
		end
	end
	dy
end
const minx = minimum([s[1] - manhatten(s...) for s in sensors])
const maxx = maximum([s[1] + manhatten(s...) for s in sensors])
const y = 10
n = 0
for x in minx:maxx
	dy = resolve_collision(x, y)
	if dy > 0
		global n += 1
	end
end
n -= length(Set([(bx, by) for (_, _, bx, by) in sensors if by == y]))
@show n
distress_x, distress_y = 0, 0
const size = 20
prev = 0
for x in 0:size
	dy = resolve_collision(x, 0)
	if dy < size
		global distress_x, distress_y = x, dy
		break
	end
end
@show distress_x, distress_y, distress_x * 4000000 + distress_y
