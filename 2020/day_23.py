from functools import reduce

class CupNode:
    def __init__(self, label):
        self.label = label
        self.pred = None
        self.succ = None

class CupList:
    def __init__(self, cups):
        self.length = len(cups)
        self.max_cup = max(cups)
        self.min_cup = min(cups)
        self.lookup = { x : CupNode(x) for x in cups }
        self.current = self.lookup[cups[0]]
        for i in range(0, self.length):
            node = self.lookup[cups[i]]
            pred = self.lookup[cups[(i - 1) % self.length]]
            succ = self.lookup[cups[(i + 1) % self.length]]
            node.pred = pred
            node.succ = succ

    def shift_until(self, label):
        while self.current.label != label:
            self.current = self.current.pred

    def encode(self):
        start = self.current
        end = start.succ
        out = ""
        while end != start:
            out += str(end.label)
            end = end.succ
        return out

def shift_cups(cups):
    return cups[1:] + cups[:1]

def encode_cups(cups):
    while cups[0] != 1:
        cups = shift_cups(cups)
    cups = shift_cups(cups)
    return reduce(lambda acc, n: acc + str(n), cups[:-1], "")

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
cup_list = CupList(cups)
cup_list.shift_until(1)
print(cup_list.encode())

#basic_cups = cups
#for _ in range(0, 100):
#    basic_cups = make_move(basic_cups)
#complex_cups = cups + list(range(max(cups), 1000001))
#for _ in range(0, 10000000):
#    complex_cups = make_move(complex_cups)
#print(encode_cups(cups))
