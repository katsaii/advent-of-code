x = 1
cycle = 1
signals = []
crt = ""
for inst in [inst.split() for inst in open("in/day_10.txt").readlines()]:
    for _ in range(1 if inst[0] == "noop" else 2):
        if (cycle - 20) % 40 == 0:
            signals.append(cycle * x)
        crt += "#" if abs((cycle - 1) % 40 - x) < 2 else "."
        if cycle % 40 == 0:
            crt += "\n"
        cycle += 1
    if inst[0] != "noop":
        x += int(inst[1])
print("sum of interesting signals")
print(sum(signals))
print("\ncrt display output")
print(crt.strip())
