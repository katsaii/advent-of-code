def joltage_distribution(xs):
    diffs = [b - a for (a, b) in zip(xs, xs[1:])]
    dist = { }
    for diff in diffs:
        if diff in dist:
            dist[diff] += 1
        else:
            dist[diff] = 1
    return dist

adapters = [int(x) for x in open("in/day_10.txt").readlines()]
max_joltage = max(adapters)
adapters.append(0)               # the socket
adapters.append(max_joltage + 3) # the device
adapters.sort()
dist = joltage_distribution(adapters)
jolt_product = dist[1] * dist[3]
print(dist)
print("product of the number of 1 and 3 jolt differences\n%d" % jolt_product)
