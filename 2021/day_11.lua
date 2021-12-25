local dumbos = { }
for line in io.lines("in/day_11.txt") do
	local row = { }
	for pos = 1, #line do
		row[pos] = tonumber(line:sub(pos, pos))
	end
	dumbos[#dumbos + 1] = row
end
local flashCount = 0
local stepCount = 0
local synchronisationStep = nil
while synchronisationStep == nil or stepCount <= 100 do
	stepCount = stepCount + 1
	for i, row in pairs(dumbos) do
		for j, _ in pairs(row) do
			function mark_dumbo(i, j)
				local row = dumbos[i]
				if row == nil then return end
				local energy = row[j]
				if energy == nil then return end
				dumbos[i][j] = energy + 1
				if energy == 9 then
					if stepCount <= 100 then
						-- only track flash count for the first 100 iterations
						flashCount = flashCount + 1
					end
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
	local synchronised = true
	for i, row in pairs(dumbos) do
		for j, val in pairs(row) do
			if val > 9 then
				dumbos[i][j] = 0
			else
				synchronised = false
			end
		end
	end
	if synchronisationStep == nil and synchronised then
		synchronisationStep = stepCount
	end
end
print("dumbo flash count after 100 steps")
print(flashCount)
print("\nsteps until synchronisation")
print(synchronisationStep)
