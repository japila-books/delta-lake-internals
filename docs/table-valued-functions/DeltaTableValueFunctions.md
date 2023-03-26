# DeltaTableValueFunctions

## <span id="CDC_NAME_BASED"><span id="CDC_PATH_BASED"> supportedFnNames { #supportedFnNames }

`DeltaTableValueFunctions` defines the following table-valued functions:

* [table_changes](#table_changes) (_table changes by name_)
* [table_changes_by_path](#table_changes_by_path)

## <span id="getTableValueFunctionInjection"> getTableValueFunctionInjection

```scala
type TableFunctionDescription =
    (FunctionIdentifier, ExpressionInfo, TableFunctionRegistry.TableFunctionBuilder)
getTableValueFunctionInjection(
    fnName: String): TableFunctionDescription
```

`getTableValueFunctionInjection`...FIXME

---

`getTableValueFunctionInjection` is used when:

* [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md) is requested to register extensions (incl. table-valued functions)

## <span id="resolveChangesTableValueFunctions"> resolveChangesTableValueFunctions

```scala
resolveChangesTableValueFunctions(
  session: SparkSession,
  fnName: String,
  args: Seq[Expression]): LogicalPlan
```

`resolveChangesTableValueFunctions` extracts the following values of the CDF options (from the given `args` expressions):

* `startingVersion` or `startingTimestamp`
* `endingVersion` or `endingTimestamp`

`resolveChangesTableValueFunctions` defines the following option:

Option | Value
-------|------
 [readChangeFeed](../DeltaDataSource.md#CDC_ENABLED_KEY) | `true`

For [table_changes](#CDC_NAME_BASED), `resolveChangesTableValueFunctions` requests the `SessionCatalog` ([Spark SQL]({{ book.spark_sql }}/SessionCatalog)) for the table metadata.

`resolveChangesTableValueFunctions` creates a [DeltaTableV2](../DeltaTableV2.md) for the table path (from the `SessionCatalog` or given explicitly for [table_changes_by_path](#CDC_PATH_BASED)) and the CDF options.

`resolveChangesTableValueFunctions` requests the `DeltaTableV2` for a [BaseRelation](../DeltaTableV2.md#toBaseRelation) to create a `LogicalRelation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation)).

!!! note "Non-Streaming LogicalRelation"
    `resolveChangesTableValueFunctions` creates a non-streaming `LogicalRelation`.

---

`resolveChangesTableValueFunctions` is used when:

* [DeltaAnalysis](../DeltaAnalysis.md) logical resolution rule is executed (to resolve [DeltaTableValueFunction](DeltaTableValueFunction.md) logical operators)
