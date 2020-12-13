function find_bus_ids(s)
	local busses = { }
	for bus_id in s:gmatch("([0-9]+),*") do
		table.insert(busses, tonumber(bus_id))
	end
	return busses
end

function find_earliest_bus(depart, busses)
	local earliest_bus_id = nil
	local minimum_wait = math.huge
	for _, bus_id in ipairs(busses) do
		local wait_time = bus_id - depart % bus_id
		if wait_time < minimum_wait then
			minimum_wait = wait_time
			earliest_bus_id = bus_id
		end
	end
	return earliest_bus_id, minimum_wait
end

file, _ = io.open("in/day_13.txt")
depart = tonumber(file:read())
busses = find_bus_ids(file:read())
bus_id, wait = find_earliest_bus(depart, busses)
print("the earliest bus multiplied by the number of minutes wait")
print(("%d * %d = %d"):format(bus_id, wait, bus_id * wait))
