# ColumnWithDefaultExprUtils

## <span id="IDENTITY_MIN_WRITER_VERSION"> IDENTITY_MIN_WRITER_VERSION

`ColumnWithDefaultExprUtils` uses `6` as the [minimum version of a writer](Protocol.md#minWriterVersion) for writing to `IDENTITY` columns.

`IDENTITY_MIN_WRITER_VERSION` is used when:

* `ColumnWithDefaultExprUtils` is used to [satisfyProtocol](#satisfyProtocol)
* `Protocol` utility is used to [determine the required minimum protocol](Protocol.md#requiredMinimumProtocol)

## <span id="columnHasDefaultExpr"> columnHasDefaultExpr

```scala
columnHasDefaultExpr(
  protocol: Protocol,
  col: StructField): Boolean
```

`columnHasDefaultExpr` is an alias of [GeneratedColumn.isGeneratedColumn](generated-columns/GeneratedColumn.md#isGeneratedColumn).

`columnHasDefaultExpr` is used when:

* `DeltaAnalysis` logical resolution rule is requested to `resolveQueryColumnsByName`

## <span id="hasIdentityColumn"> hasIdentityColumn

```scala
hasIdentityColumn(
  schema: StructType): Boolean
```

`hasIdentityColumn` returns `true` if the given `StructType` ([Spark SQL]({{ book.spark_sql }}/types/StructType)) contains an [IDENTITY column](#isIdentityColumn).

`hasIdentityColumn` is used when:

* `Protocol` utility is used for the [required minimum protocol](Protocol.md#requiredMinimumProtocol)

## <span id="isIdentityColumn"> isIdentityColumn

```scala
isIdentityColumn(
  field: StructField): Boolean
```

`isIdentityColumn` uses the `Metadata` (of the given `StructField`) to check the existence of [delta.identity.start](DeltaSourceUtils.md#IDENTITY_INFO_START), [delta.identity.step](DeltaSourceUtils.md#IDENTITY_INFO_STEP) and [delta.identity.allowExplicitInsert](DeltaSourceUtils.md#IDENTITY_INFO_ALLOW_EXPLICIT_INSERT) metadata keys.

!!! note "IDENTITY column"
    **IDENTITY column** is a column with [delta.identity.start](DeltaSourceUtils.md#IDENTITY_INFO_START), [delta.identity.step](DeltaSourceUtils.md#IDENTITY_INFO_STEP) and [delta.identity.allowExplicitInsert](DeltaSourceUtils.md#IDENTITY_INFO_ALLOW_EXPLICIT_INSERT) metadata.

`isIdentityColumn` is used when:

* `ColumnWithDefaultExprUtils` is used to [hasIdentityColumn](#hasIdentityColumn) and [removeDefaultExpressions](#removeDefaultExpressions)

## <span id="removeDefaultExpressions"> removeDefaultExpressions

```scala
removeDefaultExpressions(
  schema: StructType,
  keepGeneratedColumns: Boolean = false): StructType
```

`removeDefaultExpressions`...FIXME

`removeDefaultExpressions` is used when:

* `DeltaLog` is requested to [create a BaseRelation](DeltaLog.md#createRelation) and [createDataFrame](DeltaLog.md#createDataFrame)
* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](OptimisticTransactionImpl.md#updateMetadataInternal)
* `DeltaTableV2` is requested for the [tableSchema](DeltaTableV2.md#tableSchema)
* `DeltaDataSource` is requested for the [sourceSchema](DeltaDataSource.md#sourceSchema)
* `DeltaSourceBase` is requested for the [schema](DeltaSource.md#schema)
