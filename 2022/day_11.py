monkeys = [(x[:-6], x[-6:]) for x in [[
    int(item) if item.isnumeric() else item
    for item in monkey.replace(",", "").split() if item.isnumeric() or item in "+*old"
] for monkey in open("in/day_11.txt").read().split("\n\n")]]
inspects = len(monkeys) * [0]
for i in range(20):
    print(f"Loop {i}")
    for idx, (items, [lhs, op, rhs, mod, bt, bf]) in enumerate(monkeys):
        print(f"  Monkey {idx}")
        for _ in range(len(items)):
            print(f"    Monkey inspects an item {items[0]}")
            inspects[idx] += 1
            lhs_ = items[0] if lhs == "old" else lhs
            rhs_ = items[0] if rhs == "old" else rhs
            items[0] = lhs_ * rhs_ if op == "*" else lhs_ + rhs_
            print(f"      Becomes {lhs_} {op} {rhs_} = {items[0]}")
            items[0] = items[0] // 3
            print(f"      Divided {items[0]}")
            target = bt if items[0] % mod == 0 else bf
            print(f"      Throws to monkey {target}")
            monkeys[target][0].append(items[0])
            del items[0]
inspects.sort()
print(inspects[-1] * inspects[-2])
