# DeltaErrors Utility

## <span id="modifyAppendOnlyTableException"> modifyAppendOnlyTableException

```scala
modifyAppendOnlyTableException: Throwable
```

`modifyAppendOnlyTableException` throws an `UnsupportedOperationException`:

```text
This table is configured to only allow appends. If you would like to permit updates or deletes, use 'ALTER TABLE <table_name> SET TBLPROPERTIES (appendOnly=false)'.
```

`modifyAppendOnlyTableException` is used when:

* `DeltaLog` is requested to [assertRemovable](DeltaLog.md#assertRemovable)

## <span id="postCommitHookFailedException"> Reporting Post-Commit Hook Failure

```scala
postCommitHookFailedException(
  failedHook: PostCommitHook,
  failedOnCommitVersion: Long,
  extraErrorMessage: String,
  error: Throwable): Throwable
```

`postCommitHookFailedException` throws a `RuntimeException`:

```text
Committing to the Delta table version [failedOnCommitVersion] succeeded but error while executing post-commit hook [failedHook]: [extraErrorMessage]
```

`postCommitHookFailedException` is used when:

* `GenerateSymlinkManifestImpl` is requested to [handleError](GenerateSymlinkManifest.md#handleError)
