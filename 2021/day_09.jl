bytes = read("in/day_09.txt")
samples = [Int64(byte - 0x30) for byte in bytes[bytes .!= 0x0a]]
hm = reshape(samples, findfirst(bytes .== 0x0a) - 1, :)'
bin = hm .== 9
height, width = size(hm)
risk_level_sum = 0
islands = Int64[]
for i = 1:height
    for j = 1:width
        left = i == 1 ? typemax(Int64) : hm[i - 1, j]
        top = j == 1 ? typemax(Int64) : hm[i, j - 1]
        right = i == height ? typemax(Int64) : hm[i + 1, j]
        bottom = j == width ? typemax(Int64) : hm[i, j + 1]
        cell = hm[i, j]
        if cell < left && cell < top && cell < right && cell < bottom
            global risk_level_sum += hm[i, j] + 1
        end
        function search(i, j)
            if i < 1 || j < 1 || i > height || j > width || bin[i, j]
                return 0
            end
            bin[i, j] = true
            return 1 +
                    search(i - 1, j) +
                    search(i, j - 1) +
                    search(i + 1, j) +
                    search(i, j + 1)
        end
        island = search(i, j)
        if island != 0
            push!(islands, island)
        end
    end
end
sort!(islands, rev=true)
println("sum of risk levels of low points in the heightmap")
println(risk_level_sum)
print("\nproduct of the three largest basins ")
println("(", islands[1], " * ", islands[2], " * ", islands[3], ")")
println(islands[1] * islands[2] * islands[3])
