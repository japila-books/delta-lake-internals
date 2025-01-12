# IdentityColumn

## allowExplicitInsert { #allowExplicitInsert }

```scala
allowExplicitInsert(
  field: StructField): Boolean
```

`allowExplicitInsert`...FIXME

---

`allowExplicitInsert` is used when:

* `IdentityColumn` is requested to [blockExplicitIdentityColumnInsert](#blockExplicitIdentityColumnInsert)
* `DeltaCatalog` is requested to [alterTable](../DeltaCatalog.md#alterTable)
* `MergeIntoCommandBase` is requested to [validateIdentityColumnHighWatermarks](../commands/merge/MergeIntoCommandBase.md#validateIdentityColumnHighWatermarks)

## copySchemaWithMergedHighWaterMarks { #copySchemaWithMergedHighWaterMarks }

```scala
copySchemaWithMergedHighWaterMarks(
  deltaLog: DeltaLog,
  schemaToCopy: StructType,
  schemaWithHighWaterMarksToMerge: StructType): StructType
```

`copySchemaWithMergedHighWaterMarks`...FIXME

---

`copySchemaWithMergedHighWaterMarks` is used when:

* `CloneTableBase` is requested to [prepareSourceMetadata](../commands/clone/CloneTableBase.md#prepareSourceMetadata) (for [CreateDeltaTableCommand](../commands/create-table/CreateDeltaTableCommand.md))
* `RestoreTableCommand` is [executed](../commands/restore/RestoreTableCommand.md#run)

## Create Expression to Generate IDENTITY Values { #createIdentityColumnGenerationExpr }

```scala
createIdentityColumnGenerationExpr(
  field: StructField): Expression
```

`createIdentityColumnGenerationExpr` creates a [GenerateIdentityValues](GenerateIdentityValues.md#apply) for the [IdentityInfo](#getIdentityInfo) for the given `StructField`.

---

`createIdentityColumnGenerationExpr` is used when:

* `IdentityColumn` is requested to [createIdentityColumnGenerationExprAsColumn](#createIdentityColumnGenerationExprAsColumn)
* `PreprocessTableMerge` is requested to [resolveImplicitColumns](../PreprocessTableMerge.md#resolveImplicitColumns)

## Create Column to Generate IDENTITY Values { #createIdentityColumnGenerationExprAsColumn }

```scala
createIdentityColumnGenerationExprAsColumn(
  field: StructField): Column
```

`createIdentityColumnGenerationExprAsColumn` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) with a [GenerateIdentityValues](#createIdentityColumnGenerationExpr) expression for the given `StructField`.

---

`createIdentityColumnGenerationExprAsColumn` is used when:

* `ColumnWithDefaultExprUtils` is requested to [addDefaultExprsOrReturnConstraints](../ColumnWithDefaultExprUtils.md#addDefaultExprsOrReturnConstraints)
* `WriteIntoDelta` is requested to [writeAndReturnCommitData](../commands/WriteIntoDelta.md#writeAndReturnCommitData)

## getIdentityColumns { #getIdentityColumns }

```scala
getIdentityColumns(
  schema: StructType): Seq[StructField]
```

`getIdentityColumns`...FIXME

---

`getIdentityColumns` is used when:

* `IdentityColumn` is requested to [blockIdentityColumnUpdate](#blockIdentityColumnUpdate), [copySchemaWithMergedHighWaterMarks](#copySchemaWithMergedHighWaterMarks), [getNumberOfIdentityColumns](#getNumberOfIdentityColumns), [logTableWrite](#logTableWrite)
* [PreprocessTableMerge](../PreprocessTableMerge.md) logical rule is executed

## getIdentityInfo { #getIdentityInfo }

```scala
getIdentityInfo(
  field: StructField): IdentityInfo
```

`getIdentityInfo`...FIXME

---

`getIdentityInfo` is used when:

* `IdentityColumn` is requested to [copySchemaWithMergedHighWaterMarks](#copySchemaWithMergedHighWaterMarks), [createIdentityColumnGenerationExpr](#createIdentityColumnGenerationExpr), [syncIdentity](#syncIdentity), [updateSchema](#updateSchema), [updateToValidHighWaterMark](#updateToValidHighWaterMark)
* `MergeIntoCommandBase` is requested to [checkIdentityColumnHighWaterMarks](../commands/merge/MergeIntoCommandBase.md#checkIdentityColumnHighWaterMarks)

## syncIdentity { #syncIdentity }

```scala
syncIdentity(
  deltaLog: DeltaLog,
  field: StructField,
  df: DataFrame,
  allowLoweringHighWaterMarkForSyncIdentity: Boolean): StructField
```

`syncIdentity`...FIXME

---

`syncIdentity` is used when:

* `AlterTableChangeColumnDeltaCommand` is [executed](../commands/alter/AlterTableChangeColumnDeltaCommand.md#run)

## updateSchema { #updateSchema }

```scala
updateSchema(
  deltaLog: DeltaLog,
  schema: StructType,
  updatedIdentityHighWaterMarks: Seq[(String, Long)]): StructType
```

`updateSchema`...FIXME

---

`updateSchema` is used when:

* `IdentityColumn` is requested to [copySchemaWithMergedHighWaterMarks](#copySchemaWithMergedHighWaterMarks)
* `OptimisticTransactionImpl` is requested to [precommitUpdateSchemaWithIdentityHighWaterMarks](../OptimisticTransactionImpl.md#precommitUpdateSchemaWithIdentityHighWaterMarks)

## updateToValidHighWaterMark { #updateToValidHighWaterMark }

```scala
updateToValidHighWaterMark(
  field: StructField,
  candidateHighWaterMark: Long,
  allowLoweringHighWaterMarkForSyncIdentity: Boolean): (StructField, Seq[String])
```

`updateToValidHighWaterMark`...FIXME

---

`updateToValidHighWaterMark` is used when:

* `IdentityColumn` is requested to [syncIdentity](#syncIdentity) and [updateSchema](#updateSchema)
