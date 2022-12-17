re = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
function compile_sensor(sensor)
	sx, sy, bx, by = tuple([parse(Int64, n) for n in sensor]...)
	sx, sy, bx, by, abs(bx - sx) + abs(by - sy)
end
const sensors = [
	compile_sensor(match(re, line).captures)
	for line in readlines("in/day_15.txt")
]
function occupied_count(x1::Int64, x2::Int64, y::Int64)
	n, i = 0, nothing
	for x in x1:x2
		for (sx, sy, bx, by) in sensors
			dist = abs(bx - sx) + abs(by - sy)
			dist_target = abs(y - sy)
			if dist < dist_target
				continue
			end
			r = dist - dist_target
			if abs(sx - x) <= r
				n += 1
				i = x
				break
			end
		end
	end
	n, i
end
occupied_y2000000 = begin
	const minx = minimum([sx - r for (sx, _, _, _, r) in sensors])
	const maxx = maximum([sx + r for (sx, _, _, _, r) in sensors])
	const ty = 2000000
	occupied_count(minx, maxx, ty)[1] -
		length(Set([(bx, by) for (_, _, bx, by, _) in sensors if by == ty]))
end
@show occupied_y2000000

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
