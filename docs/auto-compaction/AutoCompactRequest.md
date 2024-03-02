# AutoCompactRequest

## Creating Instance

`AutoCompactRequest` takes the following to be created:

* <span id="shouldCompact"> `shouldCompact` flag
* <span id="allowedPartitions"> Allowed partitions
* <span id="targetPartitionsPredicate"> Target Partitions Predicate (`Expression`s)

`AutoCompactRequest` is created when:

* `AutoCompactRequest` is requested to [noopRequest](#noopRequest)
* `AutoCompactUtils` is requested to [prepareAutoCompactRequest](AutoCompactUtils.md#prepareAutoCompactRequest)
