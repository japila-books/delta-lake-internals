# ManualListingFileManifest

`ManualListingFileManifest` is a [FileManifest](FileManifest.md).

## <span id="getFiles"> getFiles

```scala
getFiles: Iterator[SerializableFileStatus]
```

`getFiles` is part of the [FileManifest](FileManifest.md#getFiles) abstraction.

`getFiles`...FIXME

## <span id="close"> close

```scala
close
```

`close` is part of the `Closeable` ([Java]({{ java.api }}/java/io/Closeable.html)) abstraction.

`close`...FIXME

## <span id="list"> HDFS FileStatus List Dataset

```scala
list: Dataset[SerializableFileStatus]
```

`list` creates a [HDFS FileStatus dataset](#doList) and marks it to be cached (once an action is executed).

!!! note "Scala lazy value"
    `list` is a Scala lazy value and is initialized once when first accessed. Once computed it stays unchanged.

`list` is used when:

* `ManualListingFileManifest` is requested to [getFiles](#getFiles) and [close](#close)

### <span id="doList"> doList

```scala
doList(): Dataset[SerializableFileStatus]
```

`doList`...FIXME

`doList` is used when:

* `ManualListingFileManifest` is requested for [file status dataset](#list)
