def make_move(cups, dist=3):
    cup_max = max(cups)
    cup_min = min(cups)
    current = cups[0]
    head = cups[1:dist + 1]
    tail = cups[dist + 1:]
    dest = current
    while True:
        dest = cup_max if dest == cup_min else dest - 1
        if dest == current or dest in tail:
            break
    if dest == current:
        # no change
        return cups
    else:
        pos = tail.index(dest)
        left = tail[0:pos + 1]
        right = tail[pos + 1:]
        return left + head + right + [current]

cups = [int(x) for x in open("in/day_23.txt").read() if not x.isspace()]
for _ in range(0, 10):
    cups = make_move(cups)
print(cups)
