def joltage_distribution(xs):
    diffs = [b - a for (a, b) in zip(xs, xs[1:])]
    dist = { }
    for diff in diffs:
        if diff in dist:
            dist[diff] += 1
        else:
            dist[diff] = 1
    return dist

def adapter_combinations(xs, sep):
    graph = [len(list(filter(lambda x: x - xs[i] <= sep, xs[i + 1:]))) for i in range(0, len(xs) - 1)] + [1]
    for i in range(0, len(graph) - 1)[::-1]:
        count = graph[i]
        subtotal = 0
        for j in range(0, count):
            subtotal += graph[i + j + 1]
        graph[i] = subtotal
    return graph[0]

adapters = [int(x) for x in open("in/day_10.txt").readlines()]
max_joltage = max(adapters)
joltage_sep = 3
adapters.append(0)                         # the socket
adapters.append(max_joltage + joltage_sep) # the device
adapters.sort()
dist = joltage_distribution(adapters)
combinations = adapter_combinations(adapters, joltage_sep)
jolt_product = dist[1] * dist[3]
print("product of the number of 1 and 3 jolt differences\n%d" % jolt_product)
print("\nnumber of combinations of adapter\n%d" % combinations)
