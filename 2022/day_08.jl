trees = permutedims(hcat(map(collect, readlines("in/day_08.txt"))...))
height, width = size(trees)
visible_count = 0
for i = 1:height
	for j = 1:width
		tree = trees[i, j]
		neighbours = [
			trees[i, begin:(j - 1)],
			trees[i, (j + 1):end],
			trees[begin:(i - 1), j],
			trees[(i + 1):end, j],
		]
		visible = any(map(x -> all(map(<(tree), x)), neighbours))
		if visible
			global visible_count += 1
		end
	end
end
@show visible_count
