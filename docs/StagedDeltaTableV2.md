# StagedDeltaTableV2

`StagedDeltaTableV2` is a `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/)) that `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite/)).

## Creating Instance

`StagedDeltaTableV2` takes the following to be created:

* <span id="ident"> Identifier
* <span id="schema"> Schema
* <span id="partitions"> Partitions (`Array[Transform]`)
* <span id="properties"> Properties
* [Operation](#operation)

`StagedDeltaTableV2` is created when:

* `DeltaCatalog` is requested to [stageReplace](DeltaCatalog.md#stageReplace), [stageCreateOrReplace](DeltaCatalog.md#stageCreateOrReplace) or [stageCreate](DeltaCatalog.md#stageCreate)

### <span id="operation"> CreationMode

`StagedDeltaTableV2` is given a `CreationMode` when [created](#creating-instance):

* `Create` when [stageCreate](DeltaCatalog.md#stageCreate)
* `CreateOrReplace` when [stageCreateOrReplace](DeltaCatalog.md#stageCreateOrReplace)
* `Replace` when [stageReplace](DeltaCatalog.md#stageReplace)

## <span id="commitStagedChanges"> commitStagedChanges

```scala
commitStagedChanges(): Unit
```

`commitStagedChanges` is part of the `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/#commitStagedChanges)) abstraction.

---

`commitStagedChanges`...FIXME

## <span id="abortStagedChanges"> abortStagedChanges

```scala
abortStagedChanges(): Unit
```

`abortStagedChanges` is part of the `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/#abortStagedChanges)) abstraction.

---

`abortStagedChanges` does nothing.

## <span id="newWriteBuilder"> Creating WriteBuilder

```scala
newWriteBuilder(
  info: LogicalWriteInfo): V1WriteBuilder
```

`newWriteBuilder`...FIXME

`newWriteBuilder` is part of the `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite/#newWriteBuilder)) abstraction.
