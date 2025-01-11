# IdentityColumn

## getIdentityInfo { #getIdentityInfo }

```scala
getIdentityInfo(
  field: StructField): IdentityInfo
```

`getIdentityInfo`...FIXME

---

`getIdentityInfo` is used when:

* `IdentityColumn` is requested to [copySchemaWithMergedHighWaterMarks](#copySchemaWithMergedHighWaterMarks), [createIdentityColumnGenerationExpr](#createIdentityColumnGenerationExpr), [syncIdentity](#syncIdentity), [updateSchema](#updateSchema), [updateToValidHighWaterMark](#updateToValidHighWaterMark)
* `MergeIntoCommandBase` is requested to [checkIdentityColumnHighWaterMarks](../commands/merge/MergeIntoCommandBase.md#checkIdentityColumnHighWaterMarks)
