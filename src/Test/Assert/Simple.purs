module Test.Assert.Simple
  ( Assertion()
  , assertSuccess, assertFailure
  , assertBool
  , assertEqual
  , assertString
  , (@=?), (@?=)
  , assertThrows
  ) where

  import Control.Monad.Eff
  import Control.Monad.Eff.Exception
  import Test.Assert.AssertionError
  import Data.Maybe
  import Data.String
  import Data.Function

  type Assertion e = Eff (err :: Exception | e) Unit

  when :: forall e. Boolean -> Eff e Unit -> Eff e Unit
  when b a = if b then a else return unit

  unless :: forall e. Boolean -> Eff e Unit -> Eff e Unit
  unless b = when (not b)

  assertSuccess :: forall e. Assertion e
  assertSuccess = return unit

  assertFailure :: forall e. String -> Assertion e
  assertFailure msg =
    throwException (toError $ assertionError msg {} Nothing)

  assertBool :: forall e. String -> Boolean -> Assertion e
  assertBool msg b = unless b (assertFailure msg)

  assertEqual :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
  assertEqual expected actual =
  unless (actual == expected) (assertFailure msg)
   where msg = "expected: " ++ show expected ++ "\n but got: " ++ show actual

  assertString :: forall e. String -> Assertion e
  assertString s = unless (null s) (assertFailure s)

  (@=?) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
  (@=?) expected actual = assertEqual expected actual

  (@?=) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
  (@?=) actual expected = assertEqual expected actual

  infix 1 @=?
  infix 1 @?=

  data ThrowsResult a = NotThrows a | Ok | NG Error

  foreign import assertThrowsImpl """
function assertThrowsImpl(r, p, m){
  function assertThrowsImpl_Eff(){
    try {
      return r.notThrows(m());
    } catch(e){
      if(p(e)){
        return r.ok;
      } else {
        return r.ng(e);
      }
    }
  }
  return assertThrowsImpl_Eff;
}""" :: forall e a b. Fn3
        { notThrows :: a -> b
        , ok :: b
        , ng :: Error -> b
        } (Error -> Boolean)
        (Eff (err :: Exception | e) a) 
        (Eff (err :: Exception | e) b) 

  assertThrows :: forall e a. (Error -> Boolean)
               -> (Eff (err :: Exception | e) a) -> Assertion e
  assertThrows p m = do
    r <- runFn3 assertThrowsImpl {notThrows: NotThrows, ok: Ok, ng: NG} p m
    case r of
         NotThrows _ -> assertFailure "error not threw"
         Ok          -> assertSuccess
         NG        e -> assertFailure $ "not expected error is threw: " ++ show e
