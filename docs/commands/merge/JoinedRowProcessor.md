# JoinedRowProcessor

`JoinedRowProcessor` is used to [process partitions](#processPartition) for `MergeIntoCommand` to [write out merged data](MergeIntoCommand.md#writeAllChanges).

## Creating Instance

`JoinedRowProcessor` takes the following to be created:

* <span id="targetRowHasNoMatch"> `targetRowHasNoMatch` Expression
* <span id="sourceRowHasNoMatch"> `sourceRowHasNoMatch` Expression
* <span id="matchedConditions"> `matchedConditions` Expressions
* <span id="matchedOutputs"> `matchedOutputs` (`Seq[Seq[Seq[Expression]]]`)
* <span id="notMatchedConditions"> `notMatchedConditions` Expressions
* <span id="notMatchedOutputs"> `notMatchedOutputs` (`Seq[Seq[Seq[Expression]]]`)
* <span id="noopCopyOutput"> `noopCopyOutput` Expressions
* <span id="deleteRowOutput"> `deleteRowOutput` Expressions
* <span id="joinedAttributes"> `joinedAttributes` Attributes
* <span id="joinedRowEncoder"> `joinedRowEncoder` (`ExpressionEncoder[Row]`)
* <span id="outputRowEncoder"> `outputRowEncoder` (`ExpressionEncoder[Row]`)

`JoinedRowProcessor` is created when:

* `MergeIntoCommand` is requested to [write out merged data](MergeIntoCommand.md#writeAllChanges)

## <span id="processPartition"> Processing Partition

```scala
processPartition(
  rowIterator: Iterator[Row]): Iterator[Row]
```

`processPartition`...FIXME

`processPartition` is used when:

* `MergeIntoCommand` is requested to [write out merged data](MergeIntoCommand.md#writeAllChanges)
