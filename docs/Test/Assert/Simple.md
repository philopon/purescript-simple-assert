# Module Documentation

## Module Test.Assert.Simple

### Types

    type Assertion e = Eff (err :: Exception | e) Unit


### Values

    (@=?) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e

    (@?=) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e

    assertBool :: forall e. String -> Boolean -> Assertion e

    assertEqual :: forall e a. (Eq a, Show a) => a -> a -> Assertion e

    assertFailure :: forall e. String -> Assertion e

    assertString :: forall e. String -> Assertion e

    assertSuccess :: forall e. Assertion e

    assertThrows :: forall e a. (Error -> Boolean) -> Eff (err :: Exception | e) a -> Assertion e



