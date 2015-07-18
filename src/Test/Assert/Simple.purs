module Test.Assert.Simple
  ( Assertion()
  , assertSuccess, assertFailure
  , assertBool
  , assertEqual
  , assertIn
  , assertString
  , (@=?), (@?=)
  , assertThrows
  ) where

import Prelude
import Control.Monad
import Control.Monad.Eff
import Control.Monad.Eff.Unsafe
import Control.Monad.Eff.Exception
import Data.Maybe
import Data.Functor
import Data.String
import Data.Function
import Data.Foldable

type Assertion e = Eff (err :: EXCEPTION | e) Unit

assertSuccess :: forall e. Assertion e
assertSuccess = return unit

assertFailure :: forall e. String -> Assertion e
assertFailure msg =
  throwException (error msg)

assertBool :: forall e. String -> Boolean -> Assertion e
assertBool msg b = unless b (assertFailure msg)

assertEqual :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
assertEqual expected actual =
  unless (actual == expected) (assertFailure msg)
    where msg = "expected: " ++ show expected ++
                " but got: " ++ show actual

assertString :: forall e. String -> Assertion e
assertString s = unless (s == "") (assertFailure s)

assertIn :: forall e a. (Eq a, Show a) => Array a -> a -> Assertion e
assertIn expecteds actual =
  unless (any ((==) actual) expecteds) (assertFailure msg)
    where msg = "expected: " ++ joinWith " | " (show <$> expecteds) ++
                " but got: " ++ show actual

(@=?) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
(@=?) expected actual = assertEqual expected actual

(@?=) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
(@?=) actual expected = assertEqual expected actual

infix 1 @=?
infix 1 @?=

assertThrows :: forall e a. (Error -> Boolean)
             -> Eff (err :: EXCEPTION | e) Unit -> Assertion e
assertThrows p m = do
  r <- unsafeInterleaveEff $ catchException (return <<< Just) (Nothing <$ m)
  case r of
       Nothing -> assertFailure "error not threw"
       Just  e -> if p e
                     then assertSuccess
                     else assertFailure $ "not expected error is threw: " ++ show e
