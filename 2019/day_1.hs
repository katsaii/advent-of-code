fuelRequirement :: Integer -> Integer
fuelRequirement n
    | x < 2     = 0
    | otherwise = x - 2
    where
    x = n `div` 3

fuelFuelRequirement :: Integer -> Integer
fuelFuelRequirement n
    | x == 0    = 0
    | otherwise = x + fuelFuelRequirement x
    where
    x = fuelRequirement n

fuelSum :: [Integer] -> Integer
fuelSum = foldr (+) 0

main :: IO ()
main = do
    input <- readFile "in/day_1.txt"
    let xs = map read $ words input :: [Integer]
    putStrLn "total fuel requirement (naive)"
    putStrLn $ show $ fuelSum $ map fuelRequirement xs
    putStrLn "\ntotal fuel requirement (corrected)"
    putStrLn $ show $ fuelSum $ map fuelFuelRequirement xs
