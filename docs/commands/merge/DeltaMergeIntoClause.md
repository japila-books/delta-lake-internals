# DeltaMergeIntoClause

`DeltaMergeIntoClause` is an [extension](#contract) of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) abstraction for [WHEN clauses](#implementations).

## Contract

### <span id="actions"> Actions

```scala
actions: Seq[Expression]
```

### <span id="condition"> Condition

```scala
condition: Option[Expression]
```

## Implementations

* [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md)
* [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)

??? note "Sealed Trait"
    `DeltaMergeIntoClause` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

## <span id="verifyActions"> Verifing Actions

```scala
verifyActions(): Unit
```

`verifyActions` goes over the [actions](#actions) and makes sure that they are either `UnresolvedStar`s ([Spark SQL]({{ book.spark_sql }}/expressions/UnresolvedStar)) or [DeltaMergeAction](DeltaMergeAction.md)s.

For unsupported actions, `verifyActions` throws an `IllegalArgumentException`:

```text
Unexpected action expression [action] in [this]
```

`verifyActions` is used when:

* `DeltaMergeInto` is [created](DeltaMergeInto.md#creating-instance)
