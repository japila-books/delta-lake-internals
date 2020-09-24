= [[SchemaUtils]] SchemaUtils Utility

`SchemaUtils` is...FIXME

== [[mergeSchemas]] `mergeSchemas` Utility

[source, scala]
----
mergeSchemas(
  tableSchema: StructType,
  dataSchema: StructType): StructType
----

`mergeSchemas`...FIXME

[NOTE]
====
`mergeSchemas` is used when:

* `ConvertToDeltaCommand` is requested to ConvertToDeltaCommand.md#performConvert[performConvert] and ConvertToDeltaCommand.md#mergeSchemasInParallel[mergeSchemasInParallel]

* `ImplicitMetadataOperation` is requested to ImplicitMetadataOperation.md#updateMetadata[update metadata]
====
