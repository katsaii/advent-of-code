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
ticket_fields = my_ticket.map{|_| fields.keys}
tickets = notes[2]
        .split(/\n/)
        .drop(1)
        .map{|x| x
                .split(/,/)
                .map{|x| x.to_i}}
ticket_error_rate = 0
valid_tickets = tickets.filter do |ticket|
    ticket_is_valid = true
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
            ticket_is_valid = false
        end
    end
    ticket_is_valid
end
valid_tickets.each do |ticket|
    ticket.each_with_index do |value, col|
        valid_fields = ticket_fields[col] - ticket_fields[col].filter do |key|
            fields[key].any?{|min, max| value >= min and value <= max}
        end
        ticket_fields[col] -= valid_fields
    end
end
loop do
    id = ticket_fields.index{|fields| not fields.is_a?(String) and fields.length == 1}
    if not id
        break
    end
    field = ticket_fields[id][0]
    ticket_fields[id] = field
    ticket_fields.map! do |fields|
        if fields.is_a?(String)
            fields
        else
            fields - [field]
        end
    end
end
puts "ticket scanning error rate of nearby tickets\n#{ticket_error_rate}"
puts "\nmy ticket"
departure_sum = 1
my_ticket.each_with_index do |value, col|
    field = ticket_fields[col]
    puts "  #{field}: #{value}"
    if field.match(/departure.*/)
        departure_sum *= value
    end
end
puts "\nproduct of departure values\n#{departure_sum}"
