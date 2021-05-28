# JoinedRowProcessor

`JoinedRowProcessor` is...FIXME

## Creating Instance

`JoinedRowProcessor` takes the following to be created:

* <span id="targetRowHasNoMatch"> `targetRowHasNoMatch` Expression
* <span id="sourceRowHasNoMatch"> `sourceRowHasNoMatch` Expression
* <span id="matchedCondition1"> Optional `matchedCondition1` Expression
* <span id="matchedOutput1"> Optional `matchedOutput1` Expressions
* <span id="matchedCondition2"> Optional `matchedCondition2` Expression
* <span id="matchedOutput2"> Optional `matchedOutput2` Expressions
* <span id="notMatchedCondition"> Optional `notMatchedCondition` Expression
* <span id="notMatchedOutput"> Optional `notMatchedOutput` Expressions
* <span id="noopCopyOutput"> Optional `noopCopyOutput` Expression
* <span id="deleteRowOutput"> `deleteRowOutput` Expressions
* <span id="joinedAttributes"> `joinedAttributes` Attributes
* <span id="joinedRowEncoder"> `joinedRowEncoder` ExpressionEncoder
* <span id="outputRowEncoder"> `outputRowEncoder` ExpressionEncoder

`JoinedRowProcessor` is created when `MergeIntoCommand` is requested to [writeAllChanges](MergeIntoCommand.md#writeAllChanges).

## <span id="processPartition"> Processing Partition

```scala
processPartition(
  rowIterator: Iterator[Row]): Iterator[Row]
```

`processPartition`...FIXME

`processPartition` is used when `MergeIntoCommand` is requested to [writeAllChanges](MergeIntoCommand.md#writeAllChanges).
