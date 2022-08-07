# Generated Columns

**Generated Columns** are [generation expressions](#generation-expression) that can produce column values at [write time](../TransactionalWrite.md#writeFiles) (unless provided by a query).

Generated Columns can be defined using the following high-level operator:

* [DeltaColumnBuilder.generatedAlwaysAs](../DeltaColumnBuilder.md#generatedAlwaysAs)

!!! note "SQL Not Supported"
    SQL support is not available yet and tracked as [#1100](https://github.com/delta-io/delta/issues/1100).

Generated Columns are stored in the [table metadata](../Metadata.md#schema).

A column is a generated column only if the [Minimum Writer Version](../Protocol.md#minWriterVersion) is at least [4](../Protocol.md#requiredMinimumProtocol-generated-columns) and the column metadata contains [generation expressions](#delta.generationExpression).

Generated Columns is a new feature in Delta Lake 1.0.0.

## Generation Expression

**Generation Expression** is a SQL expression to generate values.

Generation Expression is attached to a column using [delta.generationExpression](#delta.generationExpression) metadata key.

## <span id="MIN_WRITER_VERSION"><span id="minWriterVersion"><span id="Protocol"> Protocol

Generated columns require the [Minimum Writer Version](../Protocol.md#minWriterVersion) (of a [delta table](../Protocol.md)) to be at least [4](../Protocol.md#requiredMinimumProtocol-generated-columns).

## <span id="GENERATION_EXPRESSION_METADATA_KEY"><span id="delta.generationExpression"> delta.generationExpression

Generated Columns feature uses the `delta.generationExpression` key in the `Metadata` of a `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField)) to mark a column as generated.

## Demo

[Generated Columns](../demo/generated-columns.md)
