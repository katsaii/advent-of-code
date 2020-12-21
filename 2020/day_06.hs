import Data.List (break, intercalate, nub)
import Data.Char (isSpace)

type Group = [String]

splitBy :: (a -> Bool) -> [a] -> [[a]]
splitBy f xs = case break f xs of
    (a, _ : b) -> a : splitBy f b
    (a, _)     -> a : []

identifyGroups :: String -> [Group]
identifyGroups = splitBy (all isSpace) . splitBy (== '\n')

groupAnswersAny :: Group -> Int
groupAnswersAny = length . nub . concat

groupAnswersAll :: Group -> Int
groupAnswersAll = length . intersection
    where
    intersection []       = []
    intersection (x : []) = x
    intersection (x : xs) = filter (`elem` x) $ intersection xs

totalAnswers :: (Group -> Int) -> [Group] -> Int
totalAnswers f = foldr (+) 0 . map f

main :: IO ()
main = do
    input <- readFile "in/day_06.txt"
    let groups = identifyGroups input
    putStrLn "sum of answers from any individual in each group"
    putStrLn $ show $ totalAnswers groupAnswersAny groups
    putStrLn "\nsum of answers shared by all individuals in each group"
    putStrLn $ show $ totalAnswers groupAnswersAll groups
