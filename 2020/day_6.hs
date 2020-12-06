import Data.List (break, intercalate, nub)
import Data.Char (isSpace, isDigit)

type Group = String

splitBy :: (a -> Bool) -> [a] -> [[a]]
splitBy f xs = case break f xs of
    (a, _ : b) -> a : splitBy f b
    (a, _)     -> a : []

identifyGroups :: String -> [Group]
identifyGroups s = map concat chunks
    where
    lines = splitBy (== '\n') s
    chunks = filter (/= []) $ splitBy (all isSpace) lines

groupAnswers :: Group -> Int
groupAnswers = length . nub

totalAnswers :: [Group] -> Int
totalAnswers = foldr (+) 0 . map groupAnswers

main :: IO ()
main = do
    input <- readFile "in/day_6.txt"
    let groups = identifyGroups input
    putStrLn $ show $ totalAnswers groups
