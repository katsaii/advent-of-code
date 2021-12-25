bytes = read("in/day_09.txt")
samples = [Int64(byte - 0x30) for byte in bytes[bytes .!= 0x0a]]
hm = reshape(samples, findfirst(bytes .== 0x0a) - 1, :)'
height, width = size(hm)
risk_level_sum = 0
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
    end
end
println("sum of risk levels of low points in the heightmap")
println(risk_level_sum)
