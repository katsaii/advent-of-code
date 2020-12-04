import Data.List (break, intercalate)
import Data.Char (isSpace, isDigit)

type Field = (String, String)
type Passport = [Field]

pair :: Eq a => a -> [a] -> ([a], [a])
pair x xs = case break (== x) xs of
    (a, _ : b) -> (a, b)
    x          -> x

splitBy :: Eq a => (a -> Bool) -> [a] -> [[a]]
splitBy f xs = case break f xs of
    (a, _ : b) -> a : splitBy f b
    (a, _)     -> a : []

split :: Eq a => a -> [a] -> [[a]]
split x = splitBy (== x)

identifyPassports :: String -> [Passport]
identifyPassports s = map (map (pair ':') . words . intercalate " ") chunks
    where
    lines = split '\n' s
    chunks = filter (/= []) $ splitBy (all isSpace) lines

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
    _          -> False
    where
        isIntegral = all isDigit
        isHexDec = all (\x -> isDigit x || x `elem` "abcdef")
        range s min max
            | isIntegral s = n >= min && n <= max
            | otherwise    = False
            where
            n = read s :: Int

passportMissingFields :: Passport -> Bool
passportMissingFields p = not $ all (`elem` fields) expectFields
    where
    expectFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    fields = map fst p

passportIsValid :: Passport -> Bool
passportIsValid p = (not . passportMissingFields) p && all fieldIsValid p

validPassportCount :: [Passport] -> Int
validPassportCount = foldr (+) 0 . map (fromEnum . passportIsValid)

correctPassportCount :: [Passport] -> Int
correctPassportCount = foldr (+) 0 . map (fromEnum . not . passportMissingFields)

main :: IO ()
main = do
    input <- readFile "in/day_4.txt"
    let passports = identifyPassports input
    putStrLn "No. of passports with the correct fields"
    putStrLn $ show $ correctPassportCount passports
    putStrLn "\nNo. of valid passports"
    putStrLn $ show $ validPassportCount passports
