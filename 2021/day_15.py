from dataclasses import dataclass
from copy import copy
import heapq

@dataclass
class Node:
    pos : (int, int)
    risk : int
    visited : bool
    parent : ...
    weight : int

    def new(row, col, risk):
        return Node((row, col), risk, False, None, float('inf'))

    def __lt__(self, other):
        return self.weight < other.weight

def search(risk_map):
    nodes = [
        [Node.new(row, col, risk) for (col, risk) in enumerate(line)]
        for (row, line) in enumerate(risk_map)
    ]
    height, width = len(nodes), len(nodes[0])
    start = nodes[0][0]
    start.weight = 0
    queue = [start]
    dest_pos = (height - 1, width - 1)
    while queue:
        node = heapq.heappop(queue)
        if node.visited:
            continue
        if node.pos == dest_pos:
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
                new_neighbour = copy(neighbour)
                neighbour.visited = True
                nodes[nrow][ncol] = new_neighbour
                new_neighbour.weight = new_weight
                new_neighbour.parent = node
                heapq.heappush(queue, new_neighbour)
    return nodes[-1][-1].weight

lines = open("in/day_15.txt").read().splitlines()
risks = [[int(c) for c in line] for line in lines]
print("total risk level of the journey")
print(search(risks))
