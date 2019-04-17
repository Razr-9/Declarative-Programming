-- COMP90048 Declarative Programming
-- File: Project 1
-- Author: Runze Nie 
-- LoginID: runzen
-- StudentID: 956690

------------------------------------------------------------------

{- 
Introduction: The code is to represent a guessing game. The player need 
to guess a list of 3 Pitches and get feedback. The target is to reach 
the correct answer with minimum number of guesses. The algorithm is for 
the best average of guesses.
-}

module Proj1 (Pitch, toPitch, feedback,
                GameState, initialGuess, nextGuess) where    

-- for using function delete
import Data.List

-- creating a typeclass to store the Pitch and make the show instance
data Pitch = Pitch {note :: Char
                   ,octave :: Char
        }deriving (Eq)

instance Show Pitch where
        show a = [note a, octave a]

-- Using this GameState to store the alternative pool
type GameState = [[Pitch]]
    
-- the function which convert a String to a Maybe Pitch
toPitch :: String -> Maybe Pitch
toPitch x = if length x == 2 
                && head x `elem` ['A'..'G'] 
                && last x `elem` ['1','2','3']
                then Just Pitch {note = head x, octave = last x}
                else Nothing

{- 
A function to get feedback with the target and the guess. The result 
includes three Int which means correct Pitch, correct Note and correct 
Octave. 

The first half of nonRepeatingList means the target and the last half 
of nonRepeatingList means the guess which have all been removed duplicates.

noteX and octaveX means all notes or octaves in the target.
-}
feedback :: [Pitch] -> [Pitch] -> (Int,Int,Int)
feedback x y 
                | length nonRepeatingList == 0 = (3,0,0)
                | length nonRepeatingList == 2 = (2, correctNote noteX guess, correctOctave octaveX guess)
                | length nonRepeatingList == 4 = (1, correctNote noteX guess, correctOctave octaveX guess)
                | length nonRepeatingList == 6 = (0, correctNote noteX guess, correctOctave octaveX guess)
                where nonRepeatingList = nonRepeating x y
                      target = take index nonRepeatingList
                      guess = drop index nonRepeatingList
                      index = (length nonRepeatingList) `quot` 2
                      noteX = [note a| a <- target]
                      octaveX = [octave a| a <- target]


-- A function removes duplicates from two lists and merge them into one.
nonRepeating :: [Pitch] -> [Pitch] -> [Pitch]
nonRepeating x [] = x
nonRepeating x (y:ys) = if y `elem` x
                                then nonRepeating (delete y x) ys
                                else nonRepeating (x ++ [y]) ys

{- 
Calculates the correct notes with two parameters, one for a list of notes 
in the target and another for the guess. 
-}
correctNote :: [Char] -> [Pitch] -> Int
correctNote [] [] = 0
correctNote _ [] = 0
correctNote [] _ = 0
correctNote x (y:ys) = if (note y) `elem` x
                                then (+) (correctNote (delete (note y) x) ys) 1
                                else correctNote x ys
               
{- 
Calculates the correct octaves with two parameters, one for a list of octaves 
in the target and another for the guess. 
-}
correctOctave :: [Char] -> [Pitch] -> Int
correctOctave [] [] = 0
correctOctave _ [] = 0
correctOctave [] _ = 0
correctOctave x (y:ys) = if (octave y) `elem` x
                                then (+) (correctOctave (delete (octave y) x) ys) 1
                                else correctOctave x ys
               
{- 
Represents the beginning of the game with the first guess which is hard coded.
With the initial GameState including all possible picks.
-}
initialGuess :: ([Pitch], GameState)
initialGuess = ( [ Pitch {note = 'B',octave = '1'}, 
                Pitch {note = 'D',octave = '3'}, 
                Pitch {note = 'G',octave = '1'} ], allOptions )

{- 
The function that makes the next guess according to the last feedback.
Using the feedback to zoom out the range of possible picks and pick the 
middle one due to that the pick pool (GameState) is in a kind of order.
-}
nextGuess :: ([Pitch], GameState) -> (Int, Int, Int) -> ([Pitch], GameState)
nextGuess (lastGuess, gameState) lastFeedback = (newGuess, newGameState)
        where newGameState = remainingItem gameState lastGuess lastFeedback
              newGuess = newGameState !! index
              index = (length newGameState) `quot` 2
{- 
Get all possible guesses with 7 * 3 = 21 combinations with irrelevant order 
and no reapeating. Also make the list in a kind of increasing order.
-} 
allOptions :: [[Pitch]]
allOptions =  [ [x,y,z] | x <- combination , y <-combination , z <- combination , 
                note x < note y || (note x == note y && octave x < octave y) , 
                note y < note z || (note y == note z && octave y < octave z) ]
        where combination = [ Pitch {note = x, octave = y} | x <- ['A'..'G'], y <- ['1','2','3'] ]

{- 
If (feedback B C) gets the same result with (feedback A B), then C will be 
possibly A in this guessing game. So this function is going to find every 'C' 
in all possible picks. It reduces the GameState and remain possible correct 
answers.
-}
remainingItem :: [[Pitch]] -> [Pitch] -> (Int,Int,Int) -> [[Pitch]]
remainingItem [] _ _ = []
remainingItem (x:xs) lastGuess lastFeedback = if feedback x lastGuess == lastFeedback
                                                then x : (remainingItem xs lastGuess lastFeedback)
                                                else remainingItem xs lastGuess lastFeedback