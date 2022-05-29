# DeltaScan

## <span id="PreparedDeltaFileIndex"> PreparedDeltaFileIndex

`DeltaScan` is used to create a [PreparedDeltaFileIndex](PreparedDeltaFileIndex.md#preparedScan).

## Creating Instance

`DeltaScan` takes the following to be created:

* <span id="version"> Version
* <span id="files"> [AddFile](../AddFile.md)s
* <span id="total"> Total `DataSize`
* <span id="partition"> Partition `DataSize`
* <span id="scanned"> Scanned `DataSize`
* <span id="partitionFilters"> Partition filters (`ExpressionSet`)
* <span id="dataFilters"> Data filters (`ExpressionSet`)
* <span id="unusedFilters"> Unused filters (`ExpressionSet`)
* <span id="projection"> Projection (`AttributeSet`)
* <span id="scanDurationMs"> Scan duration (in millis)
* <span id="dataSkippingType"> `DeltaDataSkippingType`

`DeltaScan` is created when:

* `PartitionFiltering` is requested for the [files to scan](../PartitionFiltering.md#filesForScan)
* `DataSkippingReaderBase` is requested for the [files to scan](DataSkippingReaderBase.md#filesForScan)

## <span id="allFilters"> All Filters

```scala
allFilters: ExpressionSet
```

`allFilters` is a collection of the [partitionFilters](#partitionFilters), the [dataFilters](#dataFilters), and the [unusedFilters](#unusedFilters).

`allFilters` is used when:

* `PreparedDeltaFileIndex` is requested for the [matching data files](PreparedDeltaFileIndex.md#matchingFiles)
