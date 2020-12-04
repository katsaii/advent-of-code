fuelRequirement :: Int -> Int
fuelRequirement n
    | x < 2     = 0
    | otherwise = x - 2
    where
    x = n `div` 3

fuelFuelRequirement :: Int -> Int
fuelFuelRequirement n
    | x == 0    = 0
    | otherwise = x + fuelFuelRequirement x
    where
    x = fuelRequirement n

fuelSum :: [Int] -> Int
fuelSum = foldr (+) 0

main :: IO ()
main = do
    input <- readFile "in/day_1.txt"
    let xs = map read $ words input :: [Int]
    putStrLn "total fuel requirement (naive)"
    putStrLn $ show $ fuelSum $ map fuelRequirement xs
    putStrLn "\ntotal fuel requirement (corrected)"
    putStrLn $ show $ fuelSum $ map fuelFuelRequirement xs
