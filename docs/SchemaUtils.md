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

* `ConvertToDeltaCommand` is requested to ConvertToDeltaCommand.adoc#performConvert[performConvert] and ConvertToDeltaCommand.adoc#mergeSchemasInParallel[mergeSchemasInParallel]

* `ImplicitMetadataOperation` is requested to ImplicitMetadataOperation.adoc#updateMetadata[update metadata]
====
