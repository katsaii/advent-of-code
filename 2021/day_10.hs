import Data.Either (lefts, rights)
import Data.List (sort)

type ParseResult = Either Char String

getClosingParen :: Char -> Char
getClosingParen '(' = ')'
getClosingParen '[' = ']'
getClosingParen '{' = '}'
getClosingParen '<' = '>'
getClosingParen _   = '\0'

isOpeningParen :: Char -> Bool
isOpeningParen = (/= '\0') . getClosingParen

parse :: String -> ParseResult
parse = go []
    where
    go expects [] = Right expects
    go expects (x:xs)
        | isOpeningParen x = go (getClosingParen x:expects) xs
    go (expect:expects) (x:xs)
        | expect == x = go expects xs
        | otherwise   = Left x

parseLines :: String -> [ParseResult]
parseLines = map parse . lines

syntaxErrorScore :: String -> Integer
syntaxErrorScore = foldl (+) 0 . map score . lefts . parseLines
    where
    score ')' = 3
    score ']' = 57
    score '}' = 1197
    score '>' = 25137

autocompleteScores :: String -> [Integer]
autocompleteScores = map (foldl (\acc x -> acc * 5 + score x) 0) . rights . parseLines
    where
    score ')' = 1
    score ']' = 2
    score '}' = 3
    score '>' = 4

autocompleteScore :: String -> Integer
autocompleteScore src = sort scores !! (length scores `div` 2)
    where
    scores = autocompleteScores src

main :: IO ()
main = do
    input <- readFile "in/day_10.txt"
    putStrLn $ "syntax checker score"
    putStrLn $ show $ syntaxErrorScore input
    putStrLn $ "\nautocomplete score"
    putStrLn $ show $ autocompleteScore input
