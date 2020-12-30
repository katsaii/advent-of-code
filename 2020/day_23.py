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

    def find(self, label):
        return self.lookup[label]

    def shift_until(self, label):
        while self.current.label != label:
            self.current = self.current.pred

    def make_move(self):
        current_label = self.current.label
        dest_label = current_label
        pred = self.current
        a = self.current.succ
        b = a.succ
        c = b.succ
        self.current = c.succ
        self.current.pred = pred
        pred.succ = self.current
        while True:
            dest_label = self.max_cup if dest_label == self.min_cup else dest_label - 1
            if not dest_label in { a.label, b.label, c.label }:
                break
        dest = self.lookup[dest_label]
        c.succ = dest.succ
        dest.succ = a

    def encode(self):
        start = self.current
        end = start.succ
        out = ""
        while end != start:
            out += str(end.label)
            end = end.succ
        return out

cups = [int(x) for x in open("in/day_23.txt").read() if not x.isspace()]
cup_list = CupList(cups)
for _ in range(0, 100):
    cup_list.make_move()
cup_labels = cup_list.encode()
large_cup_list = CupList(cups + list(range(max(cups) + 1, 1000001)))
for i in range(0, 10000000):
    large_cup_list.make_move()
base = large_cup_list.find(1)
star_a = base.succ.label
star_b = base.succ.succ.label
print("cup labels after 100 moves\n%s" % cup_labels)
print("\ncups with labels %d and %d contain the stars\n%d" % (star_a, star_b, star_a * star_b))
