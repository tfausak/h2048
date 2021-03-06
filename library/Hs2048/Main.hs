-- | Main entry point for the console interface to the game.
module Hs2048.Main
    ( direction
    , getChars
    , getMove
    , plai
    , play
    ) where

import           Data.List        (maximumBy)
import           Data.Ord         (comparing)
import qualified Hs2048.AI        as AI
import qualified Hs2048.Board     as B
import qualified Hs2048.Direction as D
import qualified Hs2048.Game      as G
import           Hs2048.Renderer  (renderGame)
import qualified Hs2048.Tile      as T
import           System.IO        (BufferMode (NoBuffering), hSetBuffering,
                                   hSetEcho, stdin)
import qualified System.Random    as R

{- |
    Converts a string into a direction.

    >>> direction "\ESC[D"
    Just West
    >>> direction "<"
    Nothing
-}
direction :: String -> Maybe D.Direction
direction "\ESC[D" = Just D.West
direction "\ESC[B" = Just D.South
direction "\ESC[C" = Just D.East
direction "\ESC[A" = Just D.North
direction _ = Nothing

{- |
    Gets up to three characters from standard input. If the input corresponds
    to an arrow key, it will be returned. Otherwise 'Nothing' will be returned.
    Will only consume enough input to determine if the input is an arrow key or
    not.
-}
getChars :: IO (Maybe String)
getChars = do
    a <- getChar
    if a /= '\ESC' then return Nothing else do
        b <- getChar
        if b /= '[' then return Nothing else do
            c <- getChar
            return $ if c `elem` "ABCD"
                then Just [a, b, c]
                else Nothing

{- |
    Reads from standard input and converts it into a direction. See 'getChars'.
-}
getMove :: IO (Maybe D.Direction)
getMove = fmap (maybe Nothing direction) getChars

{- |
    Automatically plays the game as an AI.
-}
plai :: R.RandomGen r => (B.Board, r) -> (T.Tile, Int)
plai (b, r) = if G.isOver b
    then (maxTile, B.score b)
    else plai (G.addRandomTile (B.move b (AI.bestMove b)) r)
  where
    maxTile = maximumBy (comparing T.rank) (concat b)

{- |
    Plays the game.
-}
play :: R.RandomGen r => (B.Board, r) -> IO ()
play (b, r) = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False

    putStr (renderGame b)

    if G.hasWon b then putStrLn "You won!" else do
        if G.isOver b then putStrLn "You lost." else do
            m <- getMove
            case m of
                Nothing -> putStrLn "Unknown move." >> play (b, r)
                Just d -> if B.canMove b d
                    then putStrLn (D.render d) >> play (G.addRandomTile (B.move b d) r)
                    else putStrLn "Invalid move." >> play (b, r)
