
def decoder_version_1(kernal)
    mask_on = 0
    mask_off = 0
    mem = { }
    kernal.each_line do |line|
        if match = line.match(/\s*mask\s*=\s*([01X]{36})\s*/)
            mask = match.captures[0]
            mask_on = mask.gsub("X", "0").to_i(2)
            mask_off = mask.gsub("X", "1").to_i(2)
        else
            key, val = line.match(/\s*mem\[(\d+)\]\s*=\s*(\d+)\s*/).captures
            mem[key] = (val.to_i | mask_on) & mask_off
        end
    end
    mem.values.reduce(:+)
end

kernal = File.read("in/day_14.txt")
sum_1 = decoder_version_1(kernal)
puts "the sum of all memory after initialisation\n#{sum_1}"
