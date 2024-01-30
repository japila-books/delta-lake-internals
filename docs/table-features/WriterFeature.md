---
title: WriterFeature
---

# WriterFeature &mdash; Writer-Only Table Features

`WriterFeature` is an extension of the [TableFeature](TableFeature.md) abstraction for [writer-only table features](#implementations).

`WriterFeature` has the following properties:

TableFeature | Value
-------------|------
 [minReaderVersion](TableFeature.md#minReaderVersion) | `0`
 [minWriterVersion](TableFeature.md#minWriterVersion) | `7`

## Implementations

* `AllowColumnDefaultsTableFeature`
* [ClusteringTableFeature](../liquid-clustering/ClusteringTableFeature.md)
* [DomainMetadataTableFeature](DomainMetadataTableFeature.md)
* `IcebergCompatV1TableFeature`
* `IcebergCompatV2TableFeature`
* [ReaderWriterFeature](ReaderWriterFeature.md)
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md)

??? note "Sealed Abstract Class"
    `WriterFeature` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).

## Creating Instance

`WriterFeature` takes the following to be created:

* [name](TableFeature.md#name)

!!! note "Abstract Class"
    `WriterFeature` is an abstract class and cannot be created directly. It is created indirectly for the [concrete WriterFeatures](#implementations).
