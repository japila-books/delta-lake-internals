# DeltaSqlAstBuilder

`DeltaSqlAstBuilder` is a command builder for the Delta SQL statements (described in [DeltaSqlBase.g4]({{ delta.github }}/core/src/main/antlr4/io/delta/sql/parser/DeltaSqlBase.g4) ANTLR grammar).

`DeltaSqlParser` is used by [DeltaSqlParser](DeltaSqlParser.md#builder).

SQL Statement | Logical Command
--------------|----------
 <span id="visitAddTableConstraint"> [ALTER TABLE ADD CONSTRAINT](index.md#ALTER-TABLE-ADD-CONSTRAINT) | [AlterTableAddConstraint](../check-constraints/AlterTableAddConstraint.md)
 <span id="visitDropTableConstraint"> [ALTER TABLE DROP CONSTRAINT](index.md#ALTER-TABLE-DROP-CONSTRAINT) | [AlterTableDropConstraint](../check-constraints/AlterTableDropConstraint.md)
 <span id="visitAlterTableDropFeature"> [ALTER TABLE DROP FEATURE](index.md#ALTER-TABLE-DROP-FEATURE) | [AlterTableDropFeature](../commands/alter/AlterTableDropFeature.md)
 [CONVERT TO DELTA](index.md#CONVERT-TO-DELTA) | [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md)
 <span id="visitDescribeDeltaDetail"> [DESCRIBE DETAIL](index.md#DESCRIBE-DETAIL) | [DescribeDeltaDetailCommand](../commands/describe-detail/DescribeDeltaDetailCommand.md)
 <span id="visitDescribeDeltaHistory"> [DESCRIBE HISTORY](index.md#describe-history) | [DescribeDeltaHistoryCommand](../commands/describe-history/DescribeDeltaHistoryCommand.md)
 <span id="visitGenerate"> [GENERATE](index.md#GENERATE) | [DeltaGenerateCommand](../commands/generate/DeltaGenerateCommand.md)
 <span id="visitOptimizeTable"> [OPTIMIZE](index.md#OPTIMIZE) | [OptimizeTableCommand](../commands/optimize/OptimizeTableCommand.md)
 <span id="visitRestore"> [RESTORE](index.md#RESTORE) | [RestoreTableStatement](../commands/restore/RestoreTableStatement.md)
 <span id="visitVacuumTable"> [VACUUM](index.md#VACUUM) | [VacuumTableCommand](../commands/vacuum/VacuumTableCommand.md)

## <span id="maybeTimeTravelChild"> maybeTimeTravelChild

```scala
maybeTimeTravelChild(
  ctx: TemporalClauseContext,
  child: LogicalPlan): LogicalPlan
```

`maybeTimeTravelChild` creates a [TimeTravel](../commands/restore/TimeTravel.md) (with `sql` ID).

`maybeTimeTravelChild` is used when:

* `DeltaSqlAstBuilder` is requested to [parse RESTORE command](#visitRestore)

## visitClone { #visitClone }

```scala
visitClone(
  ctx: CloneContext): LogicalPlan
```

`visitClone` creates a [CloneTableStatement](../commands/clone/CloneTableStatement.md) logical operator.

## visitClusterBy { #visitClusterBy }

```scala
visitClusterBy(
  ctx: ClusterByContext): LogicalPlan
```

`visitClusterBy` creates a [ClusterByPlan](../liquid-clustering/ClusterByPlan.md) (with a [ClusterBySpec](../liquid-clustering/ClusterBySpec.md)) for `CLUSTER BY` clause.

```sql
CLUSTER BY (interleave, [interleave]*)
```

`interleave`s are the column names to cluster by.

!!! note
    `CLUSTER BY` is similar to `ZORDER BY` syntax-wise.

## visitDescribeDeltaHistory { #visitDescribeDeltaHistory }

```scala
visitDescribeDeltaHistory(
  ctx: DescribeDeltaHistoryContext): LogicalPlan
```

`visitDescribeDeltaHistory` creates a [DescribeDeltaHistory](../commands/describe-history/DescribeDeltaHistory.md) logical operator for the following SQL statement:

```antlr
(DESC | DESCRIBE) HISTORY (path | table)
  (LIMIT limit)?
```

## visitReorgTable { #visitReorgTable }

```scala
visitReorgTable(
  ctx: ReorgTableContext): AnyRef
```

`visitReorgTable` creates a [DeltaReorgTable](../commands/reorg/DeltaReorgTable.md) logical operator.
