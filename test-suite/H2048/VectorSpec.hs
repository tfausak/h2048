module H2048.VectorSpec (spec) where

import           H2048.Vector
import           Test.Hspec

spec :: Spec
spec = do
    describe "parse" $ do
        it "returns [] for \"\"" $ do
            parse "" `shouldBe` []

        it "returns [Nothing, Just 2, Just 4, Just 8] for \"- 2 4 8\"" $ do
            parse "- 2 4 8" `shouldBe` [Nothing, Just 2, Just 4, Just 8]

    describe "render" $ do
        it "returns \"\" for []" $ do
            render [] `shouldBe` ""

        it "returns \"- 2 4 8\" for [Nothing, Just 2, Just 4, Just 8]" $ do
            render [Nothing, Just 2, Just 4, Just 8] `shouldBe` "- 2 4 8"

    describe "score" $ do
        it "returns 0 for []" $ do
            score [] `shouldBe` 0

        it "returns 14 for [Nothing, Just 2, Just 4, Just 8]" $ do
            score [Nothing, Just 2, Just 4, Just 8] `shouldBe` 14
