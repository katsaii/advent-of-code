monkeys = [(x[:-6], x[-6:]) for x in [[
    int(item) if item.isnumeric() else item
    for item in monkey.replace(",", "").split() if item.isnumeric() or item in "+*old"
] for monkey in open("in/day_11.txt").read().split("\n\n")]]
gcd = 1
for _, [_, _, _, mod, _, _] in monkeys:
    gcd *= mod
def monkey_business(n, worried):
    inspects = len(monkeys) * [0]
    import copy
    monkeys_ = copy.deepcopy(monkeys)
    for i in range(n):
        for idx, (items, [lhs, op, rhs, mod, bt, bf]) in enumerate(monkeys_):
            for _ in range(len(items)):
                inspects[idx] += 1
                lhs_ = items[0] if lhs == "old" else lhs
                rhs_ = items[0] if rhs == "old" else rhs
                items[0] = lhs_ * rhs_ if op == "*" else lhs_ + rhs_
                if worried:
                    items[0] = items[0] // 3
                target = bt if items[0] % mod == 0 else bf
                monkeys_[target][0].append(items[0] % gcd)
                del items[0]
    inspects.sort()
    return inspects
inspects_20 = monkey_business(20, True)
inspects_10000 = monkey_business(10000, False)
print("total monkey business after 20 rounds")
print(inspects_20[-1] * inspects_20[-2])
print("\ntotal monkey business after 10000 rounds")
print(inspects_10000[-1] * inspects_10000[-2])
