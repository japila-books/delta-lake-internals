# GeneratedColumn Utility

## <span id="isGeneratedColumn"> isGeneratedColumn

```scala
isGeneratedColumn(
  protocol: Protocol,
  field: StructField): Boolean
isGeneratedColumn(
  field: StructField): Boolean
```

`isGeneratedColumn` is `true` when the metadata of the `StructField` contains [generation expression](DeltaSourceUtils.md#GENERATION_EXPRESSION_METADATA_KEY).

## <span id="getGeneratedColumns"> getGeneratedColumns

```scala
getGeneratedColumns(
  snapshot: Snapshot): Seq[StructField]
```

`getGeneratedColumns`...FIXME

`getGeneratedColumns` is used when:

* [PreprocessTableUpdate](PreprocessTableUpdate.md) logical resolution rule is executed (and [toCommand](PreprocessTableUpdate.md#toCommand))

## <span id="enforcesGeneratedColumns"> enforcesGeneratedColumns

```scala
enforcesGeneratedColumns(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`enforcesGeneratedColumns` is `true` when the following all hold:

* [satisfyGeneratedColumnProtocol](#satisfyGeneratedColumnProtocol) with the [Protocol](Protocol.md)
* There is at least one [generated column](#isGeneratedColumn) in the [schema](Metadata.md#schema) of the [Metadata](Metadata.md)

`enforcesGeneratedColumns` is used when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles) (and [normalizeData](TransactionalWrite.md#normalizeData))

## <span id="removeGenerationExpressions"> removeGenerationExpressions

```scala
removeGenerationExpressions(
  schema: StructType): StructType
```

`removeGenerationExpressions`...FIXME

`removeGenerationExpressions` is used when:

* FIXME

## <span id="satisfyGeneratedColumnProtocol"> satisfyGeneratedColumnProtocol

```scala
satisfyGeneratedColumnProtocol(
  protocol: Protocol): Boolean
```

`satisfyGeneratedColumnProtocol` is `true` when the [minWriterVersion](Protocol.md#minWriterVersion) of the [Protocol](Protocol.md) is at least `4`.

`satisfyGeneratedColumnProtocol` is used when:

* `GeneratedColumn` utility is used to [isGeneratedColumn](#isGeneratedColumn), [getGeneratedColumns](#getGeneratedColumns) and [enforcesGeneratedColumns](#enforcesGeneratedColumns)
* `OptimisticTransactionImpl` is requested to [updateMetadata](OptimisticTransactionImpl.md#updateMetadata)
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)

## <span id="addGeneratedColumnsOrReturnConstraints"> addGeneratedColumnsOrReturnConstraints

```scala
addGeneratedColumnsOrReturnConstraints(
  deltaLog: DeltaLog,
  queryExecution: QueryExecution,
  schema: StructType,
  df: DataFrame): (DataFrame, Seq[Constraint])
```

`addGeneratedColumnsOrReturnConstraints`...FIXME

`addGeneratedColumnsOrReturnConstraints` is used when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles) (and [normalizeData](TransactionalWrite.md#normalizeData))
