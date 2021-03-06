{-# LANGUAGE LambdaCase #-}
module Chapter4
  ( module Data.Display
  , module Chapter4.Syntax
  , module Chapter4.Parser
  , module Chapter4.Eval
  , process
  ) where

import Data.Display
import Chapter4.Syntax
import Chapter4.Parser
import Chapter4.Eval

process :: String -> IO ()
process line = case parseExpr line of
  Left  err  -> print err
  Right expr -> case eval expr of
    Left  err  -> display err
    Right term -> display term
