filter :: [Int] -> [Int]
filter [] = []
filter (x:xs) = 
    if x < 0
    then filter xs
    else x : filter xs
