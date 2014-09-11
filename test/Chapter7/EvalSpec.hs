{-# LANGUAGE OverloadedStrings #-}
module Chapter7.EvalSpec where

import Test.Hspec

import Data.Display
import Chapter7.Syntax
import Chapter7.Eval

spec :: Spec
spec = do

  describe "isVal" $ do

    it "isVal (\\ x x) => True" $
      isVal [] (cIdn "x") `shouldBe` True

    it "isVal \\.0 => False" $
      isVal [] (0 <+ 1) `shouldBe` False

  describe "eval1" $ do

    it "eval1 id => NoRuleApplies" $
      eval1 [] (cIdn "x") `shouldBe` Left NoRuleApplies

    it "eval1 (id id) => id" $
      eval1 [] (TmApp (cIdn "x") $ cIdn "x") `shouldBe`
      Right (cIdn "x")

    it "eval1 (fls $ \\ x x) => (\\ f f)" $
      eval1 [] (cFls <+> cIdn "x") `shouldBe`
      Right (cIdn "f")

    it "eval1 (tru $ \\ x x) => (\\ f $ \\ x x)" $
      eval1 [] (cTru <+> cIdn "x") `shouldBe`
      Right (TmAbs "f" . TmAbs "x" $ TmVar 0 2)

  describe "eval" $ do

    it "eval (id (id (id (id (\\ x x))))) => (\\ x x)" $ do
      let expr = cIdn "a" <+> cIdn "b" <+> cIdn "c" <+> cIdn "d" <+> cIdn "x"
      eval [] expr `shouldBe` Right (cIdn "x")

    describe "tru/fls" $ do
      it "eval (tru A B) => A" $ do
        let expr = cTru <+> cIdn "a" <+> cIdn "b"
        eval [] expr `shouldBe` Right (cIdn "a")

      it "eval (fls A B) => B" $ do
        let expr = cFls <+> cIdn "a" <+> cIdn "b"
        eval [] expr `shouldBe` Right (cIdn "b")

    describe "(test)" $ do
      it "eval (test) => test" $ do
        eval [] cTest `shouldBe` Right cTest

      it "eval (test tru v w) => v" $ do
        let expr = cTest <+> cTru <+> cIdn "v" <+> cIdn "w"
        eval [] expr `shouldBe` Right (cIdn "v")

      it "eval (test fls v w) => w" $ do
        let expr = cTest <+> cFls <+> cIdn "v" <+> cIdn "w"
        eval [] expr `shouldBe` Right (cIdn "w")

    describe "(and)" $ do

      it "eval (and) => and" $
        eval [] cAnd `shouldBe` Right cAnd

      it "eval (and tru tru) => tru" $ do
        let expr = cAnd <+> cTru <+> cTru
        eval [] expr `shouldBe` Right cTru

      it "eval (and fls tru) => fls" $ do
        let expr = cAnd <+> cFls <+> cTru
        eval [] expr `shouldBe` Right cFls

      it "eval (and tru fls) => fls" $ do
        let expr = cAnd <+> cTru <+> cFls
        eval [] expr `shouldBe` Right cFls

      it "eval (and fls fls) => fls" $ do
        let expr = cAnd <+> cFls <+> cFls
        eval [] expr `shouldBe` Right cFls

    describe "(or)" $ do

      it "eval (or) => or" $ do
        eval [] cOr `shouldBe` Right cOr

      it "eval (or tru tru) => tru" $ do
        let expr = cOr <+> cTru <+> cTru
        eval [] expr `shouldBe` Right cTru

      it "eval (or fls tru) => tru" $ do
        let expr = cOr <+> cFls <+> cTru
        eval [] expr `shouldBe` Right cTru

      it "eval (or tru fls) => tru" $ do
        let expr = cOr <+> cTru <+> cFls
        eval [] expr `shouldBe` Right cTru

      it "eval (or fls fls) => fls" $ do
        let expr = cOr <+> cFls <+> cFls
        eval [] expr `shouldBe` Right cFls

  describe "Terminate" $ do

    it "can display own expression" $ do
      toDisplay NoRuleApplies `shouldBe` "[TERMINATE]"