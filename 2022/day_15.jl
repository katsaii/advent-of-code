re = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
const manhatten(x1, y1, x2, y2) = abs(x2 - x1) + abs(y2 - y1)
const sensors = sort([
	tuple([parse(Int64, n) for n in match(re, line).captures]...)
	for line in readlines("in/day_15.txt")
], by = sensor -> sensor[2] + manhatten(sensor...))
function resolve_collision(x::Int64, y::Int64)
	dy = 0
	for (sx, sy, bx, by) in sensors
		r = manhatten(sx, sy, bx, by)
		d = manhatten(sx, sy, x, y + dy)
		if d > r
			continue
		end
		dy += r + 1 - abs(x - sx) + abs(y + dy - sy)
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

#function occupied_count(x1::Int64, x2::Int64, y::Int64)
#	n, i = 0, nothing
#	for x in x1:x2
#		for (sx, sy, bx, by) in sensors
#			dist = abs(bx - sx) + abs(by - sy)
#			dist_target = abs(y - sy)
#			if dist < dist_target
#				continue
#			end
#			r = dist - dist_target
#			if abs(sx - x) <= r
#				n += 1
#				i = x
#				break
#			end
#		end
#	end
#	n, i
#end
#occupied_y2000000 = begin
#	const minx = minimum([sx - r for (sx, _, _, _, r) in sensors])
#	const maxx = maximum([sx + r for (sx, _, _, _, r) in sensors])
#	const ty = 2000000
#	occupied_count(minx, maxx, ty)[1] -
#		length(Set([(bx, by) for (_, _, bx, by, _) in sensors if by == ty]))
#end
#distress_x, distress_y = 0, 0
#const size = 4000000::Int64
#for y in 0:size
#	n, x = occupied_count(0, size, y)
#	if n == size
#		global distress_x = x
#		global distress_y = y
#		break
#	end
#end
#
#@show occupied_y2000000
#@show distress_x, distress_y

#time = @elapsed for (sx, sy, bx, by) in sensors
#	if by == ty
#		push!(beacons, (bx, by))
#	end
#	dist = abs(bx - sx) + abs(by - sy)
#	dist_target = abs(ty - sy)
#	if dist < dist_target
#		continue
#	end
#	r = dist - dist_target
#	for i in 1:r
#		push!(no_beacons, (sx + i, ty))
#		push!(no_beacons, (sx - i, ty))
#	end
#	push!(no_beacons, (sx, ty))
#end
#println(time)
#@show length(no_beacons) - length(beacons)
