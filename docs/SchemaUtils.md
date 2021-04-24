# SchemaUtils Utility

## <span id="mergeSchemas"> mergeSchemas

```scala
mergeSchemas(
  tableSchema: StructType,
  dataSchema: StructType,
  allowImplicitConversions: Boolean = false): StructType
```

`mergeSchemas`...FIXME

`mergeSchemas` is used when:

* [PreprocessTableMerge](PreprocessTableMerge.md) logical resolution rule is executed
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed
* `ImplicitMetadataOperation` is requested to [update metadata](ImplicitMetadataOperation.md#updateMetadata)
