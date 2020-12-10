{- def joltage_distribution(xs):
    diffs = [b - a for (a, b) in zip(xs, xs[1:])]
    dist = { }
    for diff in diffs:
        if diff in dist:
            dist[diff] += 1
        else:
            dist[diff] = 1
    return dist

def joltage_graph(xs, sep):
    return [list(filter(lambda x: x - xs[i] <= sep, xs[i + 1:])) for i in range(0, len(xs) - 1)]

adapters = [int(x) for x in open("in/day_10.txt").readlines()]
adapters = [
16,
10,
15,
5,
1,
11,
7,
19,
6,
12,
4,
]
max_joltage = max(adapters)
joltage_sep = 3
adapters.append(0)                         # the socket
adapters.append(max_joltage + joltage_sep) # the device
adapters.sort()
dist = joltage_distribution(adapters)
jolt_product = dist[1] * dist[3]
jolt_graph = joltage_graph(adapters, joltage_sep)
print(list(zip(adapters, jolt_graph)))
print("product of the number of 1 and 3 jolt differences\n%d" % jolt_product)
-}

import Data.List (sort)

joltageSep :: Int
joltageSep = 3

joltageDiff :: [Int] -> [Int]
joltageDiff (x : xs) = [b - a | (a, b) <- zip (x : xs) xs]
joltageDiff _        = []

countOf :: Int -> [Int] -> Int
countOf a = length . filter (== a)

adapterArrangements :: [Int] -> Int
adapterArrangements []       = 1
adapterArrangements (_ : []) = 1
adapterArrangements (x : xs) = foldl search 0 branches
    where
    search acc xs = acc + adapterArrangements xs
    branches = [xss | (_, xss) <- zip (takeWhile (<= (x + joltageSep)) xs) (iterate tail xs)]

main :: IO ()
main = do
    input <- readFile "in/day_10.txt"
    let ints = [read x :: Int | x <- lines input]
    let adapters = sort (0 : maximum ints + joltageSep : ints)
    let diff = joltageDiff adapters
    let jolt1 = countOf 1 diff
    let jolt3 = countOf 3 diff 
    putStrLn $ show adapters
    putStrLn $ show $ jolt1 * jolt3
    putStrLn $ show $ adapterArrangements adapters

