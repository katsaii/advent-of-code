import math

file = open("in/day_5.txt")
content = file.read()[ : -1]
file.close()
highest_seat = 0
for line in content.split("\n"):
    # row
    row_min = 0
    row_max = 127
    for i in range(0, 6):
        mid = (row_max + row_min) / 2
        if line[i] == "F":
            row_max = math.floor(mid)
        else:
            row_min = math.ceil(mid)
    row = row_min if line[6] == "F" else row_max
    # column
    col_min = 0
    col_max = 7
    for i in range(7, 10):
        mid = (col_max + col_min) / 2
        if line[i] == "L":
            col_max = math.floor(mid)
        else:
            col_min = math.ceil(mid)
    col = col_min if line[6] == "F" else col_max
    # seat id
    seat = row * 8 + col
    if seat > highest_seat:
        highest_seat = seat
print("highest seat number\n%s" % highest_seat)
