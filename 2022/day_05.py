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
import copy
stacks_9000 = copy.deepcopy(stacks)
for [n, from_, to] in insts:
    for _ in range(n):
        stacks_9000[to - 1].append(stacks_9000[from_ - 1].pop())
stacks_9001 = copy.deepcopy(stacks)
for [n, from_, to] in insts:
    for offset in range(n)[::-1]:
        src_stack = stacks_9001[from_ - 1]
        stacks_9001[to - 1].append(src_stack[-1 - offset])
        del src_stack[-1 - offset]
[top_9000, top_9001] = [
    "".join([items[-1] for items in stacks])
    for stacks in [stacks_9000, stacks_9001]
]
print(top_9000, top_9001)
