# AlterDeltaTableCommand

`AlterDeltaTableCommand` is an [extension](#contract) of the [DeltaCommand](../DeltaCommand.md) abstraction for [Delta commands](#implementations) that alter a [DeltaTableV2](#table).

## Contract

### table { #table }

```scala
table: DeltaTableV2
```

[DeltaTableV2](../../DeltaTableV2.md)

Used when:

* `AlterDeltaTableCommand` is requested to [startTransaction](#startTransaction)

## Implementations

* [AlterTableAddColumnsDeltaCommand](AlterTableAddColumnsDeltaCommand.md)
* [AlterTableChangeColumnDeltaCommand](AlterTableChangeColumnDeltaCommand.md)
* [AlterTableClusterByDeltaCommand](AlterTableClusterByDeltaCommand.md)
* [AlterTableConstraintDeltaCommand](AlterTableConstraintDeltaCommand.md)
* [AlterTableDropColumnsDeltaCommand](AlterTableDropColumnsDeltaCommand.md)
* [AlterTableDropFeatureDeltaCommand](AlterTableDropFeatureDeltaCommand.md)
* [AlterTableReplaceColumnsDeltaCommand](AlterTableReplaceColumnsDeltaCommand.md)
* [AlterTableSetLocationDeltaCommand](AlterTableSetLocationDeltaCommand.md)
* [AlterTableSetPropertiesDeltaCommand](AlterTableSetPropertiesDeltaCommand.md)
* [AlterTableUnsetPropertiesDeltaCommand](AlterTableUnsetPropertiesDeltaCommand.md)

## startTransaction { #startTransaction }

```scala
startTransaction(): OptimisticTransaction
```

`startTransaction` simply requests the [DeltaTableV2](#table) for the [DeltaLog](../../DeltaTableV2.md#deltaLog) that in turn is requested to [startTransaction](../../DeltaLog.md#startTransaction).

## Checking Dependent Expressions { #checkDependentExpressions }

```scala
checkDependentExpressions(
  sparkSession: SparkSession,
  columnParts: Seq[String],
  newMetadata: actions.Metadata,
  protocol: Protocol,
  operationName: String): Unit
```

`checkDependentExpressions` skips execution when [spark.databricks.delta.alterTable.changeColumn.checkExpressions](../../configuration-properties/DeltaSQLConf.md#DELTA_ALTER_TABLE_CHANGE_COLUMN_CHECK_EXPRESSIONS) configuration property is disabled (`false`).

`checkDependentExpressions` checks if the column to change (`columnParts`) is referenced by [check constraints](#checkDependentExpressions-check-constraints) or [generated columns](#checkDependentExpressions-generated-columns) (and throws an `AnalysisException` if there are any).

---

`checkDependentExpressions` is used when:

* [AlterTableDropColumnsDeltaCommand](AlterTableDropColumnsDeltaCommand.md) and [AlterTableChangeColumnDeltaCommand](AlterTableChangeColumnDeltaCommand.md) are executed

### Check Constraints { #checkDependentExpressions-check-constraints }

`checkDependentExpressions` [findDependentConstraints](../../constraints/Constraints.md#findDependentConstraints) (with the given`columnParts` and the [newMetadata](../../Metadata.md)) and [throws an AnalysisException if there are any](../../DeltaErrors.md#foundViolatingConstraintsForColumnChange):

```text
Cannot [operationName] column [columnName] because this column is referenced by the following check constraint(s):
    [constraints]
```

### Generated Columns { #checkDependentExpressions-generated-columns }

`checkDependentExpressions` [findDependentGeneratedColumns](../../SchemaUtils.md#findDependentGeneratedColumns) (with the given`columnParts`, the [newMetadata](../../Metadata.md) and [protocol](../../Protocol.md)) and [throws an AnalysisException if there are any](../../DeltaErrors.md#foundViolatingGeneratedColumnsForColumnChange):

```text
Cannot [operationName] column [columnName] because this column is referenced by the following generated column(s):
    [fieldNames]
```
