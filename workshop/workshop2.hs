data FontColor
    = ColourName String
    | Hex Int
    | RGB Int Int Int

data FontTag = FontTag (Maybe Int) (Maybe String) (Maybe FontColor)

longestPrefix :: Eq a => [a] -> [a] -> [a]
longestPrefix _ [] = []
longestPrefix [] _ = []
longestPrefix (x:xs) (y:ys)
    | x == y = x : (longestPrefix xs ys)
    | otherwise = []
    
   