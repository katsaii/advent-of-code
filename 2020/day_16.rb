data = File.read("in/day_16.txt")
notes = data.split(/\n\n/)
fields = { }
notes[0].scan(/(.+): (\d+)-(\d+) or (\d+)-(\d+)/) do |x|
    key = x[0]
    min1 = x[1].to_i
    max1 = x[2].to_i
    min2 = x[3].to_i
    max2 = x[4].to_i
    fields[key] = [[min1, max1], [min2, max2]]
end
my_ticket = notes[1]
        .split(/\n/)[1]
        .split(/,/)
        .map{|x| x.to_i}
tickets = notes[2]
        .split(/\n/)
        .drop(1)
        .map{|x| x
                .split(/,/)
                .map{|x| x.to_i}}
ticket_error_rate = 0
tickets.each do |ticket|
    ticket.each do |value|
        catch :success do
            fields.each do |_, ranges|
                ranges.each do |min, max|
                    if value >= min and value <= max
                        throw :success
                    end
                end
            end
            ticket_error_rate += value
        end
    end
end
puts "ticket scanning error rate of nearby tickets\n#{ticket_error_rate}"
