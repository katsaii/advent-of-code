insts = [inst.split() for inst in open("in/day_10.txt").readlines()]
x = 1
cycle = 1
interesting_signals = []
for inst in insts:
    for _ in range(1 if inst[0] == "noop" else 2):
        if (cycle - 20) % 40 == 0:
            interesting_signals.append(cycle * x)
        cycle += 1
    if inst[0] != "noop":
        x += int(inst[1])

print(sum(interesting_signals))
