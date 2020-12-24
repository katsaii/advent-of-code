data = <<~TICKETS #File.read("in/day_16.txt")
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
TICKETS
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
        valid_fields = ticket_fields[col].filter do |key|
            fields[key].any?{|min, max| value >= min and value <= max}
        end
        ticket_fields[col] -= valid_fields
    end
end
puts "ticket scanning error rate of nearby tickets\n#{ticket_error_rate}"
puts "#{ticket_fields}"
