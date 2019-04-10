module Proj1 (Pitch, toPitch, feedback,
                GameState, initialGuess, nextGuess) where    

import Data.List

data Pitch = Pitch {note :: Char
                   ,octave :: Char
        }deriving (Eq)

instance Show Pitch where
        show a = [note a, octave a]

type GameState = [[Pitch]]
    
removeItem :: Pitch -> [Pitch] -> [Pitch]
removeItem _ [] = []
removeItem x (y:ys) | x == y = removeItem x ys
                    | otherwise = y : removeItem x ys

toPitch :: String -> Maybe Pitch
toPitch x = if length x == 2 && head x `elem` ['A'..'G'] && last x `elem` ['1','2','3']
                then Just Pitch {note = head x, octave = last x}
                else Nothing

feedback :: [Pitch] -> [Pitch] -> (Int,Int,Int)
feedback x y 
                | length nonRepeatingList == 0 = (3,0,0)
                | length nonRepeatingList == 2 = (2, (correctNote noteX guess), (correctOctave octaveX guess))
                | length nonRepeatingList == 4 = (1, (correctNote noteX guess), (correctOctave octaveX guess))
                | length nonRepeatingList == 6 = (0, (correctNote noteX guess), (correctOctave octaveX guess))
                where nonRepeatingList = nonRepeating x y
                      target = take index nonRepeatingList
                      guess = drop index nonRepeatingList
                      index = (length nonRepeatingList) `quot` 2
                      noteX = [note a| a <- target]
                      octaveX = [octave a| a <- target]

correctNote :: [Char] -> [Pitch] -> Int
correctNote [] [] = 0
correctNote _ [] = 0
correctNote [] _ = 0
correctNote x (y:ys) = if (note y) `elem` x
                                then (+) (correctNote (delete (note y) x) ys) 1
                                else correctNote x ys
               

correctOctave :: [Char] -> [Pitch] -> Int
correctOctave [] [] = 0
correctOctave _ [] = 0
correctOctave [] _ = 0
correctOctave x (y:ys) = if (octave y) `elem` x
                                then (+) (correctOctave (delete (octave y) x) ys) 1
                                else correctOctave x ys
               

nonRepeating :: [Pitch] -> [Pitch] -> [Pitch]
nonRepeating x [] = x
nonRepeating x (y:ys) = if y `elem` x
                                then nonRepeating (removeItem y x) ys
                                else nonRepeating (x ++ [y]) ys

initialGuess :: ([Pitch], GameState)
initialGuess = ( [ Pitch {note = 'B',octave = '1'}, Pitch {note = 'D',octave = '3'}, Pitch {note = 'G',octave = '1'} ], allOptions )
    
nextGuess :: ([Pitch], GameState) -> (Int, Int, Int) -> ([Pitch], GameState)
nextGuess (lastGuess, gameState) lastFeedback = (newGuess, newGameState)
        where newGameState = remainingItem gameState lastGuess lastFeedback
              newGuess = newGameState !! index
              index = (length newGameState) `quot` 2

allOptions :: [[Pitch]]
allOptions =  [ [x,y,z] | x <- combination, y <-combination , z <- combination , note x < note y || (note x == note y && octave x < octave y), note y < note z || (note y == note z && octave y < octave z) ]
        where combination = [ Pitch {note = x, octave = y} | x <- ['A'..'G'], y <- ['1','2','3'] ]

remainingItem :: [[Pitch]] -> [Pitch] -> (Int,Int,Int) -> [[Pitch]]
remainingItem [] _ _ = []
remainingItem (x:xs) lastGuess lastFeedback = if feedback x lastGuess == lastFeedback
                                                        then x : (remainingItem xs lastGuess lastFeedback)
                                                        else remainingItem xs lastGuess lastFeedback