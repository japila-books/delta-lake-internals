# Generated Columns

**Generated Columns** is a feature of Delta Lake that allows delta tables to define columns with [generation expressions](#generation-expression) that produce column values at write time (unless provided by a query).

Generated Columns can only be defined using [DeltaColumnBuilder.generatedAlwaysAs](../DeltaColumnBuilder.md#generatedAlwaysAs) operator.

!!! note "SQL Not Supported"
    SQL support is not available yet and tracked as [#1100](https://github.com/delta-io/delta/issues/1100).

Generated Columns are stored in the [table metadata](../Metadata.md#schema).

A table uses generated columns when all the following hold:

1. [minWriterVersion](#minWriterVersion) is at least `4`
1. Columns contain [generation expressions](#delta.generationExpression)

Generated Columns is a new feature in Delta Lake 1.0.0.

## Generation Expression

**Generation Expression** is a SQL expression to generate values.

Generation Expression is attached to a column using [delta.generationExpression](#delta.generationExpression) metadata key.

## <span id="MIN_WRITER_VERSION"><span id="minWriterVersion"> minWriterVersion

Generated columns require the [minWriterVersion](../Protocol.md#minWriterVersion) (of a [delta table](../Protocol.md)) to be at least `4`.

## <span id="GENERATION_EXPRESSION_METADATA_KEY"><span id="delta.generationExpression"> delta.generationExpression

Generated Columns feature uses the `delta.generationExpression` key in the `Metadata` of a `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField)) to mark a column as generated.

## Demo

[Generated Columns](../demo/generated-columns.md)
