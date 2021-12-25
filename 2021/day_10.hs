
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

main :: IO ()
main = putStrLn $ show $ parse "<{([([[(<>()){}]>(<<{{"
