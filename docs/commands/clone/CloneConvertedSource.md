# CloneConvertedSource

`CloneConvertedSource` is an [extension](#contract) of the [CloneSource](CloneSource.md) abstraction for [convertible non-delta table sources](#implementations) to clone from.

## Contract

### convertTargetTable { #convertTargetTable }

```scala
convertTargetTable: ConvertTargetTable
```

Used when:

* `CloneConvertedSource` is requested for the [data path](#dataPath), [schema](#schema), [metadata](#metadata), [allFiles](#allFiles), [close](#close)

## Implementations

* `CloneIcebergSource`
* [CloneParquetSource](CloneParquetSource.md)

## Creating Instance

`CloneConvertedSource` takes the following to be created:

* <span id="spark"> `SparkSession`

!!! note "Abstract Class"
    `CloneConvertedSource` is an abstract class and cannot be created directly. It is created indirectly for the [concrete CloneConvertedSources](#implementations).
