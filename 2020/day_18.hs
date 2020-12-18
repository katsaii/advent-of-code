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

expr :: Parser Int
expr = exprSumAndProd

exprSumAndProd :: Parser Int
exprSumAndProd = line <|> exprGroup
    where
    code = do
        op <- symbol '+' <|> symbol '*'
        val <- exprGroup
        return (if op == '+' then (+) else (*), val)
    line = do 
        a <- exprGroup
        codes <- many code
        return $ foldl (\acc (f, val) -> f acc val) a codes

exprGroup :: Parser Int
exprGroup = paren <|> value
    where
    paren = do
        symbol '('
        n <- expr
        symbol ')'
        return n

homeworkSum :: String -> Int
homeworkSum = foldr (+) 0 . map (unwrap . parse expr) . lines
    where
    unwrap (Just (x, _)) = x

main = do
    input <- readFile "in/day_18.txt"
    putStrLn $ show $ homeworkSum input
