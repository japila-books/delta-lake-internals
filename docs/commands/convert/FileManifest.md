# FileManifest

`FileManifest` is an [abstraction](#contract) of [file manifests](#implementations) for [ConvertToDeltaCommand](ConvertToDeltaCommand.md).

`FileManifest` is `Closeable` ([Java]({{ java.api }}/java.base/java/io/Closeable.html)).

## Contract

### <span id="basePath"> basePath

```scala
basePath: String
```

The base path of a delta table

### <span id="getFiles"> getFiles

```scala
getFiles: Iterator[SerializableFileStatus]
```

The active files of a delta table

Used when:

* `ConvertToDeltaCommand` is requested to [createDeltaActions](ConvertToDeltaCommand.md#createDeltaActions) and [performConvert](ConvertToDeltaCommand.md#performConvert)

## Implementations

* [ManualListingFileManifest](ManualListingFileManifest.md)
* [MetadataLogFileManifest](MetadataLogFileManifest.md)
