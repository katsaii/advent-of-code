function find_earliest_bus(depart, busses)
	earliest_bus_id = nil
	minimum_wait = math.huge
	for bus_id in busses:gmatch("([0-9]+),*") do
		m = tonumber(bus_id)
		wait_time = m - depart % m
		if wait_time < minimum_wait then
			minimum_wait = wait_time
			earliest_bus_id = m
		end
	end
	return earliest_bus_id, minimum_wait
end

file, _ = io.open("in/day_13.txt")
depart = tonumber(file:read())
busses = file:read()
bus_id, wait = find_earliest_bus(depart, busses)
msg = "the earliest bus multiplied by the number of minutes wait\n%d * %d = %d"
print(msg:format(bus_id, wait, bus_id * wait))
