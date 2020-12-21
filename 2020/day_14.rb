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

def apply_mask(n, mask, i=0)
    if i >= mask.length
        return [n]
    end
    case mask[i]
        when "0" then apply_mask(n, mask, i + 1)
        when "1" then apply_mask(n | (1 << i), mask, i + 1)
        when "X" then
                apply_mask(n | (1 << i), mask, i + 1) +
                apply_mask(n & (~(1 << i)), mask, i + 1)
    end
end

def decoder_version_2(kernal)
    mask = ""
    mem = { }
    kernal.each_line do |line|
        if match = line.match(/\s*mask\s*=\s*([01X]{36})\s*/)
            mask = match.captures[0].reverse
        else
            key, val = line.match(/\s*mem\[(\d+)\]\s*=\s*(\d+)\s*/).captures
            apply_mask(key.to_i, mask).each{|x| mem[x] = val.to_i}
        end
    end
    mem.values.sum
end

kernal = File.read("in/day_14.txt")
sum_1 = decoder_version_1(kernal)
sum_2 = decoder_version_2(kernal)
puts "the sum of all memory after initialisation\n#{sum_1}"
puts "\nthe sum of all memory after initialisation using version 2\n#{sum_2}"
