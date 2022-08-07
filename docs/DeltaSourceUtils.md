# DeltaSourceUtils Utility

## <span id="GENERATION_EXPRESSION_METADATA_KEY"><span id="delta.generationExpression"> delta.generationExpression

`DeltaSourceUtils` defines `delta.generationExpression` metadata key for the generation expression of a [generated column](DeltaColumnBuilder.md#generatedAlwaysAs) of a delta table.

---

Used when:

* `DeltaColumnBuilder` is requested to [build a StructField](DeltaColumnBuilder.md#build)
* `ColumnWithDefaultExprUtils` is requested to [removeDefaultExpressions](ColumnWithDefaultExprUtils.md#removeDefaultExpressions)
* [GeneratedColumn](generated-columns/GeneratedColumn.md) utility is used to [isGeneratedColumn](generated-columns/GeneratedColumn.md#isGeneratedColumn) and [getGenerationExpressionStr](generated-columns/GeneratedColumn.md#getGenerationExpressionStr)
* `SchemaUtils` utility is used to [reportDifferences](SchemaUtils.md#reportDifferences)

## <span id="IDENTITY_INFO_ALLOW_EXPLICIT_INSERT"><span id="delta.identity.allowExplicitInsert"> delta.identity.allowExplicitInsert

`DeltaSourceUtils` defines `delta.identity.allowExplicitInsert` metadata key for...FIXME

Used when:

* `ColumnWithDefaultExprUtils` utility is used to [isIdentityColumn](ColumnWithDefaultExprUtils.md#isIdentityColumn) and [removeDefaultExpressions](ColumnWithDefaultExprUtils.md#removeDefaultExpressions)

## <span id="IDENTITY_INFO_START"><span id="delta.identity.start"> delta.identity.start

`DeltaSourceUtils` defines `delta.identity.start` metadata key for...FIXME

Used when:

* `ColumnWithDefaultExprUtils` utility is used to [isIdentityColumn](ColumnWithDefaultExprUtils.md#isIdentityColumn) and [removeDefaultExpressions](ColumnWithDefaultExprUtils.md#removeDefaultExpressions)

## <span id="IDENTITY_INFO_STEP"><span id="delta.identity.step"> delta.identity.step

`DeltaSourceUtils` defines `delta.identity.step` metadata key for...FIXME

Used when:

* `ColumnWithDefaultExprUtils` utility is used to [isIdentityColumn](ColumnWithDefaultExprUtils.md#isIdentityColumn) and [removeDefaultExpressions](ColumnWithDefaultExprUtils.md#removeDefaultExpressions)

## <span id="isDeltaDataSourceName"> isDeltaDataSourceName

```scala
isDeltaDataSourceName(
  name: String): Boolean
```

`isDeltaDataSourceName` returns `true` when the given `name` is `delta` (case-insensitively).

`isDeltaDataSourceName` is used when:

* `DeltaTableUtils` is requested to [isValidPath](DeltaTableUtils.md#isValidPath)
* `DeltaUnsupportedOperationsCheck` is requested to [fail](DeltaUnsupportedOperationsCheck.md#fail) (to throw an `DeltaAnalysisException`)
* `DeltaCatalog` is requested to [createTable](DeltaCatalog.md#createTable), [stageReplace](DeltaCatalog.md#stageReplace), [stageCreateOrReplace](DeltaCatalog.md#stageCreateOrReplace), [stageCreate](DeltaCatalog.md#stageCreate)
* `SupportsPathIdentifier` is requested to `hasDeltaNamespace`
* `ConvertToDeltaCommandBase` is requested to [isPathIdentifier](commands/convert/ConvertToDeltaCommand.md#isPathIdentifier)
* `DeltaCommand` is requested to [isPathIdentifier](commands/DeltaCommand.md#isPathIdentifier)
* `DeltaSourceUtils` is requested to [isDeltaTable](#isDeltaTable)
