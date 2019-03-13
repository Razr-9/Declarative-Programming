module Assignment1 (subst, interleave, unroll) where
    subst :: Eq t => t -> t -> [t] -> [t]
    subst _ _ [] = []
    subst a b c = if head c == a 
        then b : subst a b (tail c)
        else head c : subst a b (tail c)

    interleave :: [t] -> [t] -> [t]
    interleave [] [] = []
    interleave a [] = a
    interleave [] a = a
    interleave a b = head a : head b : interleave (tail a) (tail b)

    unroll :: Int -> [a] -> [a]
    unroll x y = if length y > x
        then take x y
        else unroll x (y ++ y)
