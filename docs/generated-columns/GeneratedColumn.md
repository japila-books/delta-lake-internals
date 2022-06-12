# GeneratedColumn Utility

`GeneratedColumn` is a utility for [Generated Columns](index.md).

```scala
import org.apache.spark.sql.delta.GeneratedColumn
```

## <span id="isGeneratedColumn"> isGeneratedColumn

```scala
isGeneratedColumn(
  protocol: Protocol,
  field: StructField): Boolean
isGeneratedColumn(
  field: StructField): Boolean
```

`isGeneratedColumn` returns `true` when the following all hold:

1. [satisfyGeneratedColumnProtocol](#satisfyGeneratedColumnProtocol)
1. The metadata of the given `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField)) contains (a binding for) the [delta.generationExpression](../DeltaSourceUtils.md#GENERATION_EXPRESSION_METADATA_KEY) key.

`isGeneratedColumn` is used when:

* `ColumnWithDefaultExprUtils` utility is used to [removeDefaultExpressions](../ColumnWithDefaultExprUtils.md#removeDefaultExpressions) and [columnHasDefaultExpr](../ColumnWithDefaultExprUtils.md#columnHasDefaultExpr)
* `GeneratedColumn` utility is used to [hasGeneratedColumns](#hasGeneratedColumns), [getGeneratedColumns](#getGeneratedColumns), [enforcesGeneratedColumns](#enforcesGeneratedColumns) and [validateGeneratedColumns](#validateGeneratedColumns)

## <span id="getGeneratedColumns"> getGeneratedColumns

```scala
getGeneratedColumns(
  snapshot: Snapshot): Seq[StructField]
```

`getGeneratedColumns` [satisfyGeneratedColumnProtocol](#satisfyGeneratedColumnProtocol) (with the [protocol](../Snapshot.md#protocol) of the given [Snapshot](../Snapshot.md)) and returns [generated columns](#isGeneratedColumn) (based on the [schema](../Metadata.md#schema) of the [Metadata](../Snapshot.md#metadata) of the given [Snapshot](../Snapshot.md)).

`getGeneratedColumns` is used when:

* [PreprocessTableUpdate](../PreprocessTableUpdate.md) logical resolution rule is executed (and [toCommand](../PreprocessTableUpdate.md#toCommand))

## <span id="enforcesGeneratedColumns"> enforcesGeneratedColumns

```scala
enforcesGeneratedColumns(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`enforcesGeneratedColumns` is `true` when the following all hold:

* [satisfyGeneratedColumnProtocol](#satisfyGeneratedColumnProtocol) with the [Protocol](../Protocol.md)
* There is at least one [generated column](#isGeneratedColumn) in the [schema](../Metadata.md#schema) of the [Metadata](../Metadata.md)

`enforcesGeneratedColumns` is used when:

* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles) (and [normalizeData](../TransactionalWrite.md#normalizeData))

## <span id="satisfyGeneratedColumnProtocol"> satisfyGeneratedColumnProtocol

```scala
satisfyGeneratedColumnProtocol(
  protocol: Protocol): Boolean
```

`satisfyGeneratedColumnProtocol` is `true` when the [minWriterVersion](../Protocol.md#minWriterVersion) of the given [Protocol](../Protocol.md) is at least `4`.

`satisfyGeneratedColumnProtocol` is used when:

* `ColumnWithDefaultExprUtils` utility is used to [satisfyProtocol](../ColumnWithDefaultExprUtils.md#satisfyProtocol)
* `GeneratedColumn` utility is used to [isGeneratedColumn](#isGeneratedColumn), [getGeneratedColumns](#getGeneratedColumns), [enforcesGeneratedColumns](#enforcesGeneratedColumns) and [generatePartitionFilters](#generatePartitionFilters)
* [AlterTableChangeColumnDeltaCommand](../commands/alter/AlterTableChangeColumnDeltaCommand.md) is executed
* `ImplicitMetadataOperation` is requested to [mergeSchema](../ImplicitMetadataOperation.md#mergeSchema)

## <span id="addGeneratedColumnsOrReturnConstraints"> addGeneratedColumnsOrReturnConstraints

```scala
addGeneratedColumnsOrReturnConstraints(
  deltaLog: DeltaLog,
  queryExecution: QueryExecution,
  schema: StructType,
  df: DataFrame): (DataFrame, Seq[Constraint])
```

`addGeneratedColumnsOrReturnConstraints` returns a `DataFrame` with generated columns (missing in the schema) and constraints for generated columns (existing in the schema).

`addGeneratedColumnsOrReturnConstraints` finds [generated columns](#getGenerationExpressionStr) (among the top-level columns in the given schema ([StructType]({{ book.spark_sql }}/types/StructType))).

For every generated column, `addGeneratedColumnsOrReturnConstraints` creates a [Check](../constraints/Constraints.md#Check) constraint with the following:

* `Generated Column` name
* `EqualNullSafe` expression that compares the generated column expression with the value provided by the user

In the end, `addGeneratedColumnsOrReturnConstraints` uses `select` operator on the given `DataFrame`.

`addGeneratedColumnsOrReturnConstraints` is used when:

* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles) (and [normalizeData](../TransactionalWrite.md#normalizeData))

## <span id="hasGeneratedColumns"> hasGeneratedColumns

```scala
hasGeneratedColumns(
  schema: StructType): Boolean
```

`hasGeneratedColumns` returns `true` if any of the top-level columns in the given `StructType` ([Spark SQL]({{ book.spark_sql }}/types/StructType)) is a [generated column](#isGeneratedColumn).

`hasGeneratedColumns` is used when:

* `OptimisticTransactionImpl` is requested to [verifyNewMetadata](../OptimisticTransactionImpl.md#verifyNewMetadata)
* `Protocol` is requested to [requiredMinimumProtocol](../Protocol.md#requiredMinimumProtocol)
* [AlterTableChangeColumnDeltaCommand](../commands/alter/AlterTableChangeColumnDeltaCommand.md) is executed

## <span id="validateGeneratedColumns"> validateGeneratedColumns

```scala
validateGeneratedColumns(
  spark: SparkSession,
  schema: StructType): Unit
```

`validateGeneratedColumns`...FIXME

`validateGeneratedColumns` is used when:

* `OptimisticTransactionImpl` is requested to [verify a new metadata](../OptimisticTransactionImpl.md#verifyNewMetadata)
