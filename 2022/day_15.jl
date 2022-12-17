re = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
sensors = [
	tuple([parse(Int, n) for n in match(re, line).captures]...)
	for line in readlines("in/day_15.txt")
]
ty = 2000000
beacons = Set([])
no_beacons = Set([])
for (sx, sy, bx, by) in sensors
	if by == ty
		push!(beacons, (bx, by))
	end
	dist = abs(bx - sx) + abs(by - sy)
	dist_target = abs(ty - sy)
	if dist < dist_target
		continue
	end
	r = dist - dist_target
	for i in 1:r
		push!(no_beacons, (sx + i, ty))
		push!(no_beacons, (sx - i, ty))
	end
	push!(no_beacons, (sx, ty))
end
@show length(no_beacons) - length(beacons)
