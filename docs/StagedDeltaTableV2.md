# StagedDeltaTableV2

`StagedDeltaTableV2` is a `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/)) and a `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite/)).

## Creating Instance

`StagedDeltaTableV2` takes the following to be created:

* <span id="ident"> Identifier
* <span id="schema"> Schema
* <span id="partitions"> Partitions (`Array[Transform]`)
* <span id="properties"> Properties
* <span id="operation"> Operation (one of `Create`, `CreateOrReplace`, `Replace`)

`StagedDeltaTableV2` is created when `DeltaCatalog` is requested to [stageReplace](DeltaCatalog.md#stageReplace), [stageCreateOrReplace](DeltaCatalog.md#stageCreateOrReplace) or [stageCreate](DeltaCatalog.md#stageCreate).

## <span id="commitStagedChanges"> commitStagedChanges

```scala
commitStagedChanges(): Unit
```

`commitStagedChanges`...FIXME

`commitStagedChanges` is part of the `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/#commitStagedChanges)) abstraction.

## <span id="abortStagedChanges"> abortStagedChanges

```scala
abortStagedChanges(): Unit
```

`abortStagedChanges` does nothing.

`abortStagedChanges` is part of the `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/#abortStagedChanges)) abstraction.

## <span id="newWriteBuilder"> Creating WriteBuilder

```scala
newWriteBuilder(
  info: LogicalWriteInfo): V1WriteBuilder
```

`newWriteBuilder`...FIXME

`newWriteBuilder` is part of the `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite/#newWriteBuilder)) abstraction.
