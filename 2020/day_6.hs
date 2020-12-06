import Data.List (break, intercalate, nub)
import Data.Char (isSpace, isDigit)

type Group = [String]

splitBy :: (a -> Bool) -> [a] -> [[a]]
splitBy f xs = case break f xs of
    (a, _ : b) -> a : splitBy f b
    (a, _)     -> a : []

identifyGroups :: String -> [Group]
identifyGroups s = chunks
    where
    lines = splitBy (== '\n') s
    chunks = filter (/= []) $ splitBy (all isSpace) lines

groupAnswersAny :: Group -> Int
groupAnswersAny = length . nub . concat

groupAnswersAll :: Group -> Int
groupAnswersAll = length . intersection
    where
    intersection (x : []) = x
    intersection (x : xs) = [c | c <- intersection xs, c `elem` x]

totalAnswers :: (Group -> Int) -> [Group] -> Int
totalAnswers f = foldr (+) 0 . map f

main :: IO ()
main = do
    input <- readFile "in/day_6.txt"
    let groups = identifyGroups input
    putStrLn $ show $ totalAnswers groupAnswersAll groups
