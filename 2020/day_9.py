def find_pair_sums(xs, n):
    return [(a, b) for a in xs for b in xs if a != b and a + b == n]

def find_contiguous_sums(xs, n):
    sums = list()
    while True:
        limit = len(xs)
        for start in range(0, limit):
            if xs[start] == n:
                continue
            end = start
            total = 0
            while total < n and end < limit:
                total += xs[end]
                end += 1
            if total == n:
                sums.append(xs[start:end])
        return sums

def find_invalid_numbers(xs, offset):
    return [xs[i] for i in range(offset, len(xs)) if not len(find_pair_sums(xs[i - offset:i], xs[i]))]

content = open("in/day_9.txt").read()[:-1]
cipher = [int(x) for x in content.split("\n")]
preamble = 25
invalid_numbers = find_invalid_numbers(cipher, preamble)
contiguous_sums = [find_contiguous_sums(cipher, n) for n in invalid_numbers]
invalid_number = invalid_numbers[0]
contiguous_sum = contiguous_sums[0][0]
encryption_weakness = min(contiguous_sum) + max(contiguous_sum)
print("this number does not satisfy the XMAS property\n%d" % invalid_number)
print("\nencryption weakness of this number\n%d" % encryption_weakness)
