function find_bus_ids(s)
	local busses = { }
	for bus_id in s:gmatch("([^,]+),*") do
		local val = (bus_id == "x") and 0 or tonumber(bus_id)
		table.insert(busses, val)
	end
	return busses
end

function find_earliest_bus(depart, busses)
	local earliest_bus_id = nil
	local minimum_wait = math.huge
	for _, bus_id in ipairs(busses) do
		if bus_id ~= 0 then
			local wait_time = bus_id - depart % bus_id
			if wait_time < minimum_wait then
				minimum_wait = wait_time
				earliest_bus_id = bus_id
			end
		end
	end
	return earliest_bus_id, minimum_wait
end

function find_furthest_jump(depart, busses)
	local maximum_jump = 0
	for i, bus_id in ipairs(busses) do
		if bus_id ~= 0 then
			local off = (depart + i - 1) % bus_id
			if off ~= 0 then
				local jump = bus_id - off
				if jump > maximum_jump then
					maximum_jump = jump
				end
			end
		end
	end
	return maximum_jump
end

function find_timespan(busses)
	local t = 1
	repeat
		local jump = find_furthest_jump(t, busses)
		t = t + jump
	until jump == 0
	return t, t + #busses
end

file, _ = io.open("in/day_13.txt")
depart = tonumber(file:read())
busses = find_bus_ids(file:read())
bus_id, wait = find_earliest_bus(depart, busses)
start, limit = find_timespan(find_bus_ids("2,4,5,7,8,98,100,3000"))
print(jump)
print("the earliest bus multiplied by the number of minutes wait")
print(("%d * %d = %d"):format(bus_id, wait, bus_id * wait))
print("\nthe earliest timespan where busses depart at offsets matching their bus position")
print(("%d -- %d"):format(start, limit))
