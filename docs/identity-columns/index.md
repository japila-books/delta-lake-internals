# Identity Columns

**Identity Columns** is a new feature in Delta Lake 3.3.0 that allows assigning unique values for each record written out into a table (unless column values are provided explicitly).

Identity Columns feature is enabled by default (using [spark.databricks.delta.identityColumn.enabled](../configuration-properties/index.md#spark.databricks.delta.identityColumn.enabled)).

Identity Columns feature is supported by delta tables that meet one of the following requirements:

* The tables must be on Writer Version 6
* The table must be on Writer Version 7, and a feature name `identityColumns` must exist in the table protocol's `writerFeatures`.

Identity Columns cannot be specified with a generated column expression (or a `DeltaAnalysisException` is reported).

Identity Columns can only be of `LongType`.

IDENTITY column step cannot be 0 (or a `DeltaAnalysisException` is reported).

Internally, identity columns are columns (fields) with the following `Metadata`:

Key | Value
-|-
[delta.identity.allowExplicitInsert](../spark-connector/DeltaSourceUtils.md#IDENTITY_INFO_ALLOW_EXPLICIT_INSERT) | [identityAllowExplicitInsert](../DeltaColumnBuilder.md#identityAllowExplicitInsert)
[delta.identity.start](../spark-connector/DeltaSourceUtils.md#IDENTITY_INFO_START) | [identityStart](../DeltaColumnBuilder.md#identityStart)
[delta.identity.step](../spark-connector/DeltaSourceUtils.md#IDENTITY_INFO_STEP) | [identityStep](../DeltaColumnBuilder.md#identityStep)

[IdentityColumn](IdentityColumn.md) and [ColumnWithDefaultExprUtils](../ColumnWithDefaultExprUtils.md#isIdentityColumn) utilities are used to work with identity columns.

## Learn More

* [Identity Columns]({{ delta.github }}/PROTOCOL.md#identity-columns) in Delta Lake's table protocol specification
