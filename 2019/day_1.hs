main :: IO ()
main = do
    input <- readFile "in/day_1.txt"
    let xs = map read $ words input :: [Integer]
    let f = map (\n -> n `div` 3 - 2)
    putStrLn "total fuel requirement"
    putStrLn $ show $ foldr (+) 0 $ f xs
