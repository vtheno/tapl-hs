module Chapter7.BuiltinFuncs where

import Data.Map (Map)
import qualified Data.Map as Map

import Chapter7.Identifier
import Chapter7.Syntax

builtinFuncs :: Map Name Term
builtinFuncs = Map.fromList $
  [ ("id",  cId)
  , ("tru", cTru)
  , ("fls", cFls)
  , ("tst", cTst)
  , ("and", cAnd)
  , ("or",  cOr)
  , ("pir", cPir)
  , ("fst", cFst)
  , ("snd", cSnd)
  , ("zro", cZro)
  , ("one", cOne)
  , ("scc", cScc)
  , ("zro?", cIsZro)
  ]

-------------------------------------------------------------------------------
-- Indentify
-------------------------------------------------------------------------------

-- Church id ... λx.x (λ.0)
cId :: Term
cId = "x" +> (0 <+ 1)

cIdn :: Name -> Term
cIdn n = n +> (0 <+ 1)

-------------------------------------------------------------------------------
-- Boolean
-------------------------------------------------------------------------------

-- Church true ... λt.λf.t (λ.λ.1)
cTru :: Term
cTru = "t" +> "f" +> (1 <+ 2)

-- Church false ... λt.λf.f (λ.λ.0)
cFls :: Term
cFls = "t" +> "f" +> (0 <+ 2)

-- Church if ... λl.λm.λn.l m n (λ.λ.λ.2 0 1)
cTst :: Term
cTst = "l" +> "m" +> "n" +> (2 <+ 3) <+> (1 <+ 3) <+> (0 <+ 3)

-- Church and ... λb.λc.b c fls (λ.λ.1 0 2↑fls)
cAnd :: Term
cAnd = "b" +> "c" +> (1 <+ 2) <+> (0 <+ 2) <+> (2 -^ cFls)

-- Church or  ... λb.λc.b c tru (λ.λ.1 0 ２↑tru)
cOr :: Term
cOr = "b" +> "c" +> (1 <+ 2) <+> (2 -^ cTru) <+> (0 <+ 2)

-------------------------------------------------------------------------------
-- Pair
-------------------------------------------------------------------------------

-- Church pair ... λf.λs.λb.b f s (λ.λ.λ.0 2 1)
cPir :: Term
cPir = "f" +> "s" +> "b" +> (0 <+ 3) <+> (2 <+ 3) <+> (1 <+ 3)

-- Church fst  ... λp.p tru (λ.0 1↑tru)
cFst :: Term
cFst = "p" +> (0 <+ 1) <+> (1 -^ cTru)

-- Church snd  ... λp.p fls (λ.0 1↑fls)
cSnd :: Term
cSnd = "p" +> (0 <+ 1) <+> (1 -^ cFls)

-------------------------------------------------------------------------------
-- Number
-------------------------------------------------------------------------------
-- Church zero ... λs.λz.z (λ.λ.0)
cZro :: Term
cZro = "s" +> "z" +> (0 <+ 2)

-- Church zero ... λs.λz.s z (λ.λ.1 0)
cOne :: Term
cOne = "s" +> "z" +> (1 <+ 2) <+> (0 <+ 2)

-- Church succ ... λn.λs.λz.s (n s z) (λ.λ.λ.1 (2 1 0))
cScc :: Term
cScc = "n" +> "s" +> "z" +> (1 <+ 3) <+> ((2 <+ 3) <+> (1 <+ 3) <+> (0 <+ 3))

-- Church isZero ... λm.m (λx.fls) tru (λ.0 (λ.2↑fls) 1↑tru)
cIsZro :: Term
cIsZro = "m" +> (0 <+ 1) <+> ("x" +> 2 -^ cFls) <+> (1 -^ cTru)
