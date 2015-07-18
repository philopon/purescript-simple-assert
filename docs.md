## Module Test.Assert.Simple

#### `Assertion`

``` purescript
type Assertion e = Eff (err :: EXCEPTION | e) Unit
```

#### `assertSuccess`

``` purescript
assertSuccess :: forall e. Assertion e
```

#### `assertFailure`

``` purescript
assertFailure :: forall e. String -> Assertion e
```

#### `assertBool`

``` purescript
assertBool :: forall e. String -> Boolean -> Assertion e
```

#### `assertEqual`

``` purescript
assertEqual :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
```

#### `assertString`

``` purescript
assertString :: forall e. String -> Assertion e
```

#### `assertIn`

``` purescript
assertIn :: forall e a. (Eq a, Show a) => Array a -> a -> Assertion e
```

#### `(@=?)`

``` purescript
(@=?) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
```

_non-associative / precedence 1_

#### `(@?=)`

``` purescript
(@?=) :: forall e a. (Eq a, Show a) => a -> a -> Assertion e
```

_non-associative / precedence 1_

#### `assertThrows`

``` purescript
assertThrows :: forall e a. (Error -> Boolean) -> Eff (err :: EXCEPTION | e) Unit -> Assertion e
```



