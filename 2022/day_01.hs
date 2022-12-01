import Data.List (groupBy, sort)

main :: IO ()
main = do
    elves <- map (\xs -> [read x :: Int | x <- xs])
             <$> filter (/=[""])
             <$> groupBy (\a b -> a /= "" && b /= "")
             <$> lines
             <$> readFile "in/day_01.txt"
    let totalCalories = reverse $ sort $ map sum elves
    putStrLn "calories held by elf with the most calories"
    putStrLn $ show $ head totalCalories
    putStrLn "\ntotal calories held by the top three elves"
    putStrLn $ show $ sum $ take 3 totalCalories
