module Main where

import Debug.Trace
import Test.Mocha
import Test.Assert.Simple
import Control.Monad.Eff.Exception

main = do
  describe "@=?" $ do
    it "success" $ 2 @=? 1 + 1
    it "failure" $ 3 @=? 1 + 1

  describe "@?=" $ do
    it "success" $ 1 + 1 @=? 2
    it "failure" $ 1 + 1 @=? 3

  describe "assertBool" $ do
    it "success" $ assertBool "test of assertBool" true
    it "failure" $ assertBool "test of assertBool" false

  describe "assertEqual" $ do
    it "success" $ assertEqual 4 (2 + 2)
    it "failure" $ assertEqual 3 (2 + 2)

  describe "primitives" $ do
    it "success" assertSuccess
    it "failure" $ assertFailure "always failure"

  describe "assertString" $ do
    it "success" $ assertString ""
    it "failure" $ assertString "failure string"

  describe "assertThrows" $ do
    it "not threw -> failure"        $ assertThrows (const false) (return unit)
    it "threw expected -> success"   $ assertThrows (\e -> message e == "test") (throwException (error "test"))
    it "threw unexpected -> failure" $ assertThrows (\e -> message e == "test") (throwException (error "unexpected"))
