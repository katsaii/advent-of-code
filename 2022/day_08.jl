trees = permutedims(hcat(map(collect, readlines("in/day_08.txt"))...))
height, width = size(trees)
visible_count = 0
max_scenic_score = 0
for i = 1:height
	for j = 1:width
		tree = trees[i, j]
		neighbours = [
			trees[i, (j - 1):-1:begin],
			trees[i, (j + 1):end],
			trees[(i - 1):-1:begin, j],
			trees[(i + 1):end, j],
		]
		visible = any(map(x -> all(map(<(tree), x)), neighbours))
		if visible
			global visible_count += 1
		end
		view_dist(trees) = something(findfirst(tree .<= trees), length(trees))
		scenic_score = prod(map(view_dist, neighbours))
		if scenic_score > max_scenic_score
			global max_scenic_score = scenic_score
		end
	end
end
println("total number of visible trees from the edges of the forest")
println(visible_count)
println("\nmaximum scenic score out of trees in the forest")
println(max_scenic_score)
