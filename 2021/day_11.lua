local dumbos = { }
for line in io.lines("in/day_11.txt") do
	local row = { }
	for pos = 1, #line do
		row[pos] = tonumber(line:sub(pos, pos))
	end
	dumbos[#dumbos + 1] = row
end
local flashCount = 0
for _ = 1, 100 do
	for i, row in pairs(dumbos) do
		for j, _ in pairs(row) do
			function mark_dumbo(i, j)
				local row = dumbos[i]
				if row == nil then return end
				local energy = row[j]
				if energy == nil then return end
				dumbos[i][j] = energy + 1
				if energy == 9 then
					print("yeah")
					flashCount = flashCount + 1
					for ioff = -1, 1 do
						for joff = -1, 1 do
							if ioff ~= 0 or joff ~= 0 then
								mark_dumbo(i + ioff, j + joff)
							end
						end
					end
				end
			end
			mark_dumbo(i, j)
		end
	end
	for i, row in pairs(dumbos) do
		for j, val in pairs(row) do
			if val > 9 then
				dumbos[i][j] = 0
			end
		end
	end
end
for _, row in pairs(dumbos) do
	msg = ""
	for _, val in pairs(row) do
		msg = msg .. val
	end
	print(msg)
end
print("flash count")
print(flashCount)
