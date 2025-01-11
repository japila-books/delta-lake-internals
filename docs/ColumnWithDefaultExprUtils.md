# ColumnWithDefaultExprUtils

!!! danger "IDENTITY Columns feature is unsupported yet"
    [Protocol.requiredMinimumProtocol](Protocol.md#requiredMinimumProtocol) throws an `AnalysisException` when a delta table uses [identity columns](#hasIdentityColumn):

    ```text
    IDENTITY column is not supported
    ```

## IDENTITY_MIN_WRITER_VERSION { #IDENTITY_MIN_WRITER_VERSION }

`ColumnWithDefaultExprUtils` uses `6` as the [minimum version of a writer](Protocol.md#minWriterVersion) for writing to `IDENTITY` columns.

`IDENTITY_MIN_WRITER_VERSION` is used when:

* `ColumnWithDefaultExprUtils` is used to [satisfyProtocol](#satisfyProtocol)
* `Protocol` utility is used to [determine the required minimum protocol](Protocol.md#requiredMinimumProtocol)

## columnHasDefaultExpr { #columnHasDefaultExpr }

```scala
columnHasDefaultExpr(
  protocol: Protocol,
  col: StructField): Boolean
```

`columnHasDefaultExpr` is an alias of [GeneratedColumn.isGeneratedColumn](generated-columns/GeneratedColumn.md#isGeneratedColumn).

`columnHasDefaultExpr` is used when:

* `DeltaAnalysis` logical resolution rule is requested to `resolveQueryColumnsByName`

## hasIdentityColumn { #hasIdentityColumn }

```scala
hasIdentityColumn(
  schema: StructType): Boolean
```

`hasIdentityColumn` returns `true` if the given `StructType` ([Spark SQL]({{ book.spark_sql }}/types/StructType)) contains an [IDENTITY column](#isIdentityColumn).

`hasIdentityColumn` is used when:

* `Protocol` utility is used for the [required minimum protocol](Protocol.md#requiredMinimumProtocol)

## isIdentityColumn { #isIdentityColumn }

```scala
isIdentityColumn(
  field: StructField): Boolean
```

`isIdentityColumn` is used to find out whether a `StructField` is an [identity column](identity-columns/index.md) or not.

`isIdentityColumn` uses the `Metadata` (of the given `StructField`) to check the existence of the following metadata keys:

* [delta.identity.start](spark-connector/DeltaSourceUtils.md#IDENTITY_INFO_START)
* [delta.identity.step](spark-connector/DeltaSourceUtils.md#IDENTITY_INFO_STEP)
* [delta.identity.allowExplicitInsert](spark-connector/DeltaSourceUtils.md#IDENTITY_INFO_ALLOW_EXPLICIT_INSERT)

---

`isIdentityColumn` is used when:

* `ColumnWithDefaultExprUtils` is used to [addDefaultExprsOrReturnConstraints](#addDefaultExprsOrReturnConstraints), [columnHasDefaultExpr](#columnHasDefaultExpr), [hasIdentityColumn](#hasIdentityColumn) and [removeDefaultExpressions](#removeDefaultExpressions)
* `IdentityColumn` is requested to [blockExplicitIdentityColumnInsert](identity-columns/IdentityColumn.md#blockExplicitIdentityColumnInsert), [getIdentityColumns](identity-columns/IdentityColumn.md#getIdentityColumns), [syncIdentity](identity-columns/IdentityColumn.md#syncIdentity), [updateSchema](identity-columns/IdentityColumn.md#updateSchema), [updateToValidHighWaterMark](identity-columns/IdentityColumn.md#updateToValidHighWaterMark)
* `DeltaCatalog` is requested to [alterTable](DeltaCatalog.md#alterTable) and [createDeltaTable](DeltaCatalog.md#createDeltaTable)
* `MergeIntoCommandBase` is requested to [checkIdentityColumnHighWaterMarks](commands/merge/MergeIntoCommandBase.md#checkIdentityColumnHighWaterMarks)
* `WriteIntoDelta` is requested to [writeAndReturnCommitData](commands/WriteIntoDelta.md#writeAndReturnCommitData)

## Remove Default Expressions from Table Schema { #removeDefaultExpressions }

```scala
removeDefaultExpressions(
  schema: StructType,
  keepGeneratedColumns: Boolean = false,
  keepIdentityColumns: Boolean = false): StructType
```

`removeDefaultExpressions`...FIXME

---

`removeDefaultExpressions` is used when:

* `DeltaTableUtils` is requested to [removeInternalWriterMetadata](DeltaTableUtils.md#removeInternalWriterMetadata)
* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](OptimisticTransactionImpl.md#updateMetadataInternal)

## tableHasDefaultExpr { #tableHasDefaultExpr }

```scala
tableHasDefaultExpr(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`tableHasDefaultExpr` [enforcesGeneratedColumns](generated-columns/GeneratedColumn.md#enforcesGeneratedColumns).

---

`tableHasDefaultExpr` is used when:

* `TransactionalWrite` is requested to [normalizeData](TransactionalWrite.md#normalizeData)
