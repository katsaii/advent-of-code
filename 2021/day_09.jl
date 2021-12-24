bytes = read("in/day_09.txt")
width = findfirst(bytes .== 0x0a)
numbers = reshape(map((byte) -> Int64(byte - 0x30), bytes[bytes .!= 0x0a]), width - 1, :)'
println(numbers)
