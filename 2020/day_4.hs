import Data.List (break, intercalate)
import Data.Char (isSpace)

type Passport = [(String, String)]

split1 :: Eq a => a -> [a] -> ([a], [a])
split1 x xs = case break (== x) xs of
    (a, _ : b) -> (a, b)
    x          -> x

split :: Eq a => (a -> Bool) -> [a] -> [[a]]
split f xs = case break f xs of
    (a, _ : b) -> a : split f b
    (a, _)     -> a : []

splitChar :: Eq a => a -> [a] -> [[a]]
splitChar x = split (== x)

identifyPassports :: String -> [Passport]
identifyPassports s = map (map (split1 ':') . words . intercalate " ") passports
    where
    records = splitChar '\n' s
    passports = filter (/= []) $ split (all isSpace) records

passportFields :: Passport -> [String]
passportFields = map fst

passportIsValid :: Passport -> Bool
passportIsValid p = foldr (&&) True $ map (`elem` fields) expect
    where
    expect = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    fields = passportFields p

validPassportCount :: [Passport] -> Integer
validPassportCount = foldr (+) 0 . map (truthy . passportIsValid)
    where
    truthy True = 1
    truthy False = 0

main :: IO ()
main = do
    input <- readFile "in/day_4.txt"
    let passports = identifyPassports input
    putStrLn $ show $ validPassportCount passports

