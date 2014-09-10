{-# LANGUAGE LambdaCase, OverloadedStrings #-}
module Chapter7.Eval where

import Control.Applicative

import Data.Display
import Chapter7.Syntax

data Terminate = NoRuleApplies -- | TypeError Ty FuncForm Term
  deriving (Eq, Show)

instance Display Terminate where
  toDisplay NoRuleApplies = "[TERMINATE]"

isVal :: Context -> Term -> Bool
isVal _ (TmAbs _ _) = True
isVal _ _           = False

eval1 :: Context -> Term -> Either Terminate Term
eval1 c = \case
  TmApp v1@(TmAbs _ t) v2
    | isVal c v2 -> Right $ substTop v2 t
    | otherwise  -> TmApp v1 <$> eval1 c v2
  TmApp t1 t2 ->
    TmApp <$> eval1 c t1 <*> pure t2
  _ ->
    Left NoRuleApplies

eval :: Context -> Term -> Either Terminate Term
eval c t = case eval1 c t of
  Right t' -> eval c t'
  Left  _  -> Right t
