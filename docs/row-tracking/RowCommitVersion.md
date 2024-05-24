# RowCommitVersion

## row_commit_version { #METADATA_STRUCT_FIELD_NAME }

`RowCommitVersion` object defines `row_commit_version` for...FIXME

## \_metadata.row_commit_version { #QUALIFIED_COLUMN_NAME }

`RowCommitVersion` object defines `_metadata.row_commit_version` for...FIXME

## createMetadataStructField { #createMetadataStructField }

```scala
createMetadataStructField(
  protocol: Protocol,
  metadata: Metadata,
  nullable: Boolean = false): Option[StructField]
```

`createMetadataStructField` creates a [MetadataStructField](MetadataStructField.md) with the [materializedColumnName](MaterializedRowCommitVersion.md#getMaterializedColumnName) (for the given [Protocol](../Protocol.md) and [Metadata](../Metadata.md)).

---

`createMetadataStructField` is used when:

* `RowTracking` is requested to [createMetadataStructFields](RowTracking.md#createMetadataStructFields)
