# DeletionVectorSet

## Creating Instance

`DeletionVectorSet` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="target"> Target `DataFrame`
* <span id="targetDeltaLog"> [DeltaLog](../DeltaLog.md) of the delta table
* <span id="deltaTxn"> [OptimisticTransaction](../OptimisticTransaction.md)

`DeletionVectorSet` is created when:

* `DeletionVectorBitmapGenerator` is requested to [build deletion vectors](DeletionVectorBitmapGenerator.md#buildDeletionVectors)

## Building Deletion Vectors { #computeResult }

```scala
computeResult(): Seq[DeletionVectorResult]
```

??? note "Very Spark SQL-dependent"
    `computeResult` is very Spark SQL-dependent using the following high-level operators for its job:

    * `Dataset.groupBy`
    * `Dataset.mapPartitions`
    * `Dataset.select`
    * `Dataset.collect`

`computeResult` groups records in the given [target DataFrame](#target) by `filePath` and `deletionVectorId` columns to execute [aggColumns](#aggColumns) aggregation.

`computeResult` selects the [outputColumns](#outputColumns).

In the end, `computeResult` [bitmapStorageMapper](#bitmapStorageMapper) (on every partition) and `collect`s the result.

---

`computeResult` is used when:

* `DeletionVectorBitmapGenerator` is requested to [build the deletion vectors](DeletionVectorBitmapGenerator.md#buildDeletionVectors)

### bitmapStorageMapper { #bitmapStorageMapper }

```scala
bitmapStorageMapper(): Iterator[DeletionVectorData] => Iterator[DeletionVectorResult]
```

??? note "Dataset.mapPartitions"
    `bitmapStorageMapper` is executed on every partition using `Dataset.mapPartitions` operator.

`bitmapStorageMapper` [getRandomPrefixLength](#getRandomPrefixLength) (from the [metadata](../OptimisticTransactionImpl.md#metadata) of this [OptimisticTransaction](#deltaTxn)).

In the end, `bitmapStorageMapper` [createMapperToStoreDeletionVectors](DeletionVectorWriter.md#createMapperToStoreDeletionVectors) (for the [data directory](../DeltaLog.md#dataPath) of this [target delta table](#targetDeltaLog)).

### getRandomPrefixLength { #getRandomPrefixLength }

```scala
getRandomPrefixLength(
  metadata: Metadata): Int
```

`getRandomPrefixLength`...FIXME
