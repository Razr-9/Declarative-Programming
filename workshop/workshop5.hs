maybeApply :: (a -> b) -> Maybe a -> Maybe b
maybeApply f Nothing = Nothing
maybeApply f (Just a) = Just (f a)

zWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zWith f _ [] = []
zWith f [] _ = []
zWith f (x:xs) (y:ys) = (f x y) : zWith f xs ys

linearEqn :: Num a => a -> a -> [a] -> [a]
linearEqn a b c = map (+b) (map (*a) c)