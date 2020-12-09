def find_sum_pairs(xs, n):
    return [(a, b) for a in xs for b in xs if a != b and a + b == n]

def find_invalid_numbers(xs, offset):
    return [xs[i] for i in range(offset, len(xs)) if not len(find_sum_pairs(xs[i - offset:i], xs[i]))]

content = open("in/day_9.txt").read()[:-1]
cipher = [int(x) for x in content.split("\n")]
preamble = 25
invalid_numbers = find_invalid_numbers(cipher, preamble)
print(invalid_numbers)
