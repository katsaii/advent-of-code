import Data.List (break, intercalate)
import Data.Char (isSpace, isDigit)

type Field = (String, String)
type Passport = [Field]

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

fieldIsValid :: Field -> Bool
fieldIsValid field = case field of
    ("byr", x) -> length x == 4 && range x 1920 2002
    ("iyr", x) -> length x == 4 && range x 2010 2020
    ("eyr", x) -> length x == 4 && range x 2020 2030
    ("hgt", x) -> case break (not . isDigit) x of
        (s, "cm") -> range s 150 193
        (s, "in") -> range s 59 76
        _         -> False
    ("hcl", '#' : x) -> length x == 6 && isHexDec x
    ("ecl", x) -> any (== x) ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    ("pid", x) -> length x == 9 && isIntegral x
    ("cid", _) -> True
    _ -> False
    where
        isIntegral = all isDigit
        isHexDec = all (\x -> isDigit x || x `elem` "abcdef")
        range s min max
            | isIntegral s = n >= min && n <= max
            | otherwise    = False
            where
            n = read s :: Integer

passportMissingFields :: Passport -> Bool
passportMissingFields p = not $ all (`elem` fields) expectFields
    where
    expectFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    fields = map fst p

passportIsValid :: Passport -> Bool
passportIsValid p = (not . passportMissingFields) p && all fieldIsValid p

validPassportCount :: [Passport] -> Integer
validPassportCount = foldr (+) 0 . map (truthy . passportIsValid)
    where
    truthy True = 1
    truthy False = 0

correctPassportCount :: [Passport] -> Integer
correctPassportCount = foldr (+) 0 . map (notTruthy . passportMissingFields)
    where
    notTruthy True = 0
    notTruthy False = 1

main :: IO ()
main = do
    input <- readFile "in/day_4.txt"
    let passports = identifyPassports input
    putStrLn "# of passports with the correct fields"
    putStrLn $ show $ correctPassportCount passports
    putStrLn "\n# of valid passports"
    putStrLn $ show $ validPassportCount passports
