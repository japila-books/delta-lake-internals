# LIMIT Pushdown

As part of [Data Skipping](../data-skipping/index.md), Delta Lake 2.2 supports **LIMIT pushdown** optimization to [scan only the files up to the limit](../data-skipping/DataSkippingReaderBase.md#pruneFilesByLimit).

Delta Lake uses [file-level row counts](../data-skipping/UsesMetadataFields.md#numRecords) to find the necessary number of data files for scanning.
