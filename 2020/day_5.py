import math

def seat_numbers(x):
    # row
    row_min = 0
    row_max = 127
    for i in range(0, 6):
        mid = (row_max + row_min) / 2
        if x[i] == "F":
            row_max = math.floor(mid)
        else:
            row_min = math.ceil(mid)
    row = row_min if x[6] == "F" else row_max
    # column
    col_min = 0
    col_max = 7
    for i in range(7, 10):
        mid = (col_max + col_min) / 2
        if x[i] == "L":
            col_max = math.floor(mid)
        else:
            col_min = math.ceil(mid)
    col = col_min if x[6] == "F" else col_max
    # seat id
    return row * 8 + col

file = open("in/day_5.txt")
content = file.read()[ : -1]
file.close()
seats = list(map(seat_numbers, content.split("\n")))
print("highest seat number\n%s" % max(seats))
converse = filter(lambda x: not (x in seats), range(0, 128 * 8))
print("\nempty seats")
for seat in converse:
    if seat - 1 in seats and seat + 1 in seats:
        print(seat)
