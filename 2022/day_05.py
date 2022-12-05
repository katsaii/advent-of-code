[lines_head, lines_tail] = [
    group.splitlines()
    for group in open("in/day_05.txt").read().split("\n\n")
]
stack_count, lines_head = len(lines_head[-1].split()), lines_head[:-1]
stacks = []
for col in range(stack_count):
    stack = []
    stacks.append(stack)
    for row in range(len(lines_head))[::-1]:
        item = lines_head[row][1 + 4 * col]
        if item == " ":
            break
        stack.append(item)
import re
insts = [
    [int(item) for item in re.split("[^0-9]", inst) if item]
    for inst in lines_tail
]
for [n, from_, to] in insts:
    for _ in range(n):
        stacks[to - 1].append(stacks[from_ - 1].pop())
top_values = "".join([items[-1] for items in stacks])
print(top_values)
