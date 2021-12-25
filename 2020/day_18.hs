import Data.Char
import Control.Applicative

data Parser a = Parser { parse :: String -> Maybe (a, String) }

instance Functor Parser
    where
    fmap f p = Parser $ \input -> do
        (v, output) <- parse p input
        return (f v, output)

instance Applicative Parser
    where
    pure v    = Parser $ \input -> return (v, input)
    pf <*> pv = Parser $ \input -> do
        (f, input') <- parse pf input
        (v, output) <- parse pv input'
        return (f v, output)

instance Monad Parser
    where
    pv >>= f = Parser $ \input -> do
        (v, input') <- parse pv input
        parse (f v) input'

instance Alternative Parser
    where
    empty   = Parser $ \_ -> Nothing
    p <|> q = Parser $ \input -> case parse p input of
        Nothing -> parse q input
        x       -> x

next :: Parser Char
next = Parser $ \input -> case input of
    []       -> Nothing
    (x : xs) -> Just (x, xs)

sat :: (Char -> Bool) -> Parser Char
sat p = do
    x <- next
    if p x
    then return x
    else empty

whitespace :: Parser ()
whitespace = do
    many $ sat isSpace
    return ()

symbol :: Char -> Parser Char
symbol x = do
    whitespace
    sat (== x)

value :: Parser Int
value = do
    whitespace
    xs <- many $ sat isDigit
    return $ read xs

grouping :: Parser Int -> Parser Int
grouping p = paren <|> value
    where
    paren = do
        symbol '('
        n <- p
        symbol ')'
        return n

expr :: Parser Int
expr = line <|> grouping expr
    where
    code = do
        op <- symbol '+' <|> symbol '*'
        val <- grouping expr
        return (if op == '+' then (+) else (*), val)
    line = do 
        a <- grouping expr
        codes <- many code
        return $ foldl (\acc (f, val) -> f acc val) a codes

exprAdvanced :: Parser Int
exprAdvanced = exprProd
    where
    exprSum = plus <|> grouping exprAdvanced
        where
        plus = do
            a <- grouping exprAdvanced
            bs <- many (symbol '+' >> grouping exprAdvanced)
            return $ foldl (+) a bs
    exprProd = times <|> exprSum
        where
        times = do
            a <- exprSum
            bs <- many (symbol '*' >> exprSum)
            return $ foldl (*) a bs

homeworkSum :: Parser Int -> String -> Int
homeworkSum p = foldr (+) 0 . map (unwrap . parse p) . lines
    where
    unwrap (Just (x, _)) = x

main :: IO ()
main = do
    input <- readFile "in/day_18.txt"
    putStrLn $ "sum of answers for basic maths homework"
    putStrLn $ show $ homeworkSum expr input
    putStrLn $ "\nsum of answers for advanced maths homework"
    putStrLn $ show $ homeworkSum exprAdvanced input
