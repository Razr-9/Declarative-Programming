sumlist :: Num a => [a] -> a
sumlist [] = 0
sumlist (x : xs) = x + sumlist xs