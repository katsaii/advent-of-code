from dataclasses import dataclass
import heapq

@dataclass
class Node:
    pos : (int, int)
    risk : int
    visited : bool
    inserted : bool
    parent : ...
    weight : int

    def new(row, col, risk):
        return Node((row, col), risk, False, False, None, float('inf'))

    def __lt__(self, other):
        return self.weight < other.weight

def search(risk_map):
    nodes = [
        [Node.new(row, col, risk) for (col, risk) in enumerate(line)]
        for (row, line) in enumerate(risk_map)
    ]
    height, width = len(nodes), len(nodes[0])
    start = nodes[0][0]
    dest = nodes[-1][-1]
    start.weight = 0
    start.inserted = True
    queue = [start]
    while queue:
        node = heapq.heappop(queue)
        if node == dest:
            break
        node.visited = True
        row, col = node.pos
        neighbours_pos = [
            (row - 1, col), (row + 1, col),
            (row, col - 1), (row, col + 1),
        ]
        for (nrow, ncol) in neighbours_pos:
            if nrow in { -1, height } or ncol in { -1, width }:
                continue
            neighbour = nodes[nrow][ncol]
            if neighbour.visited:
                continue
            new_weight = node.weight + neighbour.risk
            if new_weight < neighbour.weight:
                neighbour.weight = new_weight
                neighbour.parent = node
                if not neighbour.inserted:
                    queue.append(neighbour)
                    dirty = True
        if dirty:
            heapq.heapify(queue)
    return dest.weight

lines = open("in/day_15.txt").read().splitlines()
risks = [[int(c) for c in line] for line in lines]
print("total risk level of the journey")
print(search(risks))
