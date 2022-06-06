# RestoreTableCommandBase

`RestoreTableCommandBase` is an abstraction of [RestoreTableCommands](#implementations) with pre-defined [output schema](#outputSchema) and metrics.

## <span id="outputSchema"> Output Attributes

```scala
outputSchema: Seq[Attribute]
```

`outputSchema` is a collection of `AttributeReference`s ([Spark SQL]({{ book.spark_sql }}/expressions/AttributeReference)).

Name | Data Type
-----|------
 `table_size_after_restore`  | `LongType`
 `num_of_files_after_restore`  | `LongType`
 `num_removed_files`  | `LongType`
 `num_restored_files`  | `LongType`
 `removed_files_size`  | `LongType`
 `restored_files_size`  | `LongType`

`outputSchema` is used when:

* `RestoreTableCommand` is requested for the [output attributes](RestoreTableCommand.md#output)
