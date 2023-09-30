# ReaderWriterFeature

`ReaderWriterFeature` is a marker extension of the [WriterFeature](WriterFeature.md) abstraction for [reader-writer table features](#implementations).

`ReaderWriterFeature`s require that the [minimum reader version](#minReaderVersion) is `3`.

## Implementations

* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md)
* `TimestampNTZTableFeature`

??? note "Sealed Abstract Class"
    `ReaderWriterFeature` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).

## Creating Instance

`ReaderWriterFeature` takes the following to be created:

* <span id="name"> [name](TableFeature.md#name)

!!! note "Abstract Class"
    `ReaderWriterFeature` is an abstract class and cannot be created directly. It is created indirectly for the [concrete CLASSs](#implementations).

## Minimum Reader Version { #minReaderVersion }

??? note "TableFeature"

    ```scala
    minReaderVersion: Int
    ```

    `minReaderVersion` is part of the [TableFeature](TableFeature.md#minReaderVersion) abstraction.

`minReaderVersion` is `3`.
