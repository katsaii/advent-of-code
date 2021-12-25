
data ParseResult = Ok String | Err Char
    deriving (Show)

type Parser = String -> ParseResult

grouping :: Parser
grouping src = case src of
    '(':xs -> close ')' xs
    '[':xs -> close ']' xs
    '<':xs -> close '>' xs
    ""     -> Ok ""
    where
    close expect input@(x:output)
        | expect == x = grouping output
        | otherwise   = case grouping input of
            Ok output -> close expect output
            Err x     -> Err x

main :: IO ()
main = putStrLn $ show $ grouping "()(>"
