
data ParseResult = Ok | Corrupted Char | Incomplete
    deriving (Show)

type Parser = String -> ParseResult

getClosingParen :: Char -> Char
getClosingParen '(' = ')'
getClosingParen '[' = ']'
getClosingParen '{' = '}'
getClosingParen '<' = '>'
getClosingParen _   = '\0'

isOpeningParen :: Char -> Bool
isOpeningParen = (/= '\0') . getClosingParen

parse :: Parser
parse = go []
    where
    go expects [] = if null expects then Ok else Incomplete
    go expects (x:xs)
        | isOpeningParen x = go (getClosingParen x:expects) xs
    go (expect:expects) (x:xs)
        | expect == x = go expects xs
        | otherwise   = Corrupted x

parenScore :: Char -> Integer
parenScore ')' = 3
parenScore ']' = 57
parenScore '}' = 1197
parenScore '>' = 25137

syntaxErrorScore :: String -> Integer
syntaxErrorScore = foldl (+) 0 . map parenScore . onlyCorrupted . lines
    where
    onlyCorrupted xs = [unwrap x | x <- map parse xs, isCorrupted x]
    isCorrupted (Corrupted _) = True
    isCorrupted _             = False
    unwrap (Corrupted chr) = chr

main :: IO ()
main = do
    input <- readFile "in/day_10.txt"
    putStrLn $ "sum of answers for basic maths homework"
    putStrLn $ show $ syntaxErrorScore input
