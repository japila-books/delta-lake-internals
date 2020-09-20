# DeltaMergeInto Logical Command

**DeltaMergeInto** is a logical command (Spark SQL's [Command](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/Command/)).

## Creating Instance

`DeltaMergeInto` takes the following to be created:

* <span id="target"> Target `LogicalPlan`
* <span id="source"> Source `LogicalPlan`
* <span id="condition"> Condition Expression
* <span id="matchedClauses"> Matched Clauses (`Seq[DeltaMergeIntoMatchedClause]`)
* <span id="notMatchedClause"> Optional Non-Matched Clause (`Option[DeltaMergeIntoInsertClause]`)
* <span id="migratedSchema"> Optional Migrated Schema (default: `undefined`)

`DeltaMergeInto` is created (using [apply](#apply) and [resolveReferences](#resolveReferences) utilities) when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute)
* [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule is executed

## Utilities

### <span id="apply"> apply

```scala
apply(
  target: LogicalPlan,
  source: LogicalPlan,
  condition: Expression,
  whenClauses: Seq[DeltaMergeIntoClause]): DeltaMergeInto
```

`apply`...FIXME

`apply` is used when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute) (when [mergePlan](DeltaMergeBuilder.md#mergePlan))
* [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command)

### <span id="resolveReferences"> resolveReferences

```scala
resolveReferences(
  merge: DeltaMergeInto,
  conf: SQLConf)(
  resolveExpr: (Expression, LogicalPlan) => Expression): DeltaMergeInto
```

`resolveReferences`...FIXME

`resolveReferences` is used when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute)
* [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command)
