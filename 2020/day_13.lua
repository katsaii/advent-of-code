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

function find_timespan(busses)
	local start = 0
	while true do
		::search::
		local limit = start
		for i, bus_id in ipairs(busses) do
			if bus_id == 0 then
				limit = limit + 1
			elseif limit % bus_id == 0 then
				limit = limit + 1
			else
				local wait_time = bus_id - limit % bus_id
				start = limit + wait_time - (i - 1)
				goto search
			end
		end
		return start, limit
	end
end

file, _ = io.open("in/day_13.txt")
depart = tonumber(file:read())
busses = find_bus_ids(file:read())
bus_id, wait = find_earliest_bus(depart, busses)
start, limit = find_timespan(busses)
print("the earliest bus multiplied by the number of minutes wait")
print(("%d * %d = %d"):format(bus_id, wait, bus_id * wait))
print("\nthe earliest timespan where busses depart at offsets matching their bus id")
print(("%d -- %d"):format(start, limit))
