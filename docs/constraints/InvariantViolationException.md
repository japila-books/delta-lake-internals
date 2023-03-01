# InvariantViolationException

`InvariantViolationException` is a `RuntimeException` ([Java]({{ java.api }}/java/lang/RuntimeException.html)) that is reported when data does not match the rules of a table (using [Constraint](Constraint.md)s).

## Creating Instance

`InvariantViolationException` takes the following to be created:

* <span id="message"> Error Message

`InvariantViolationException` is created when:

* `DeltaErrors` utility is used to [notNullColumnMissingException](../DeltaErrors.md#notNullColumnMissingException)
* `InvariantViolationException` utility is used to [apply](#apply)

## <span id="apply"> Creating InvariantViolationException

`apply` creates a [InvariantViolationException](#creating-instance) for the given [constraint](Constraint.md): [Check](#apply-Check) or [NotNull](#apply-NotNull).

### <span id="apply-Check"> Check

```scala
apply(
  constraint: Constraints.Check,
  values: Map[String, Any]): InvariantViolationException
```

[Check](Constraint.md#Check)

```text
CHECK constraint [name] [sql] violated by row with values:
 - [column] : [value]
```

### <span id="apply-NotNull"> NotNull

```scala
apply(
  constraint: Constraints.NotNull): InvariantViolationException
```

[NotNull](Constraint.md#NotNull)

```text
NOT NULL constraint violated for column: [name]
```

### <span id="apply-usage"> Usage

`apply` is used when:

* `CheckDeltaInvariant` is used to [eval](CheckDeltaInvariant.md#eval) (and [assertRule](CheckDeltaInvariant.md#assertRule))
