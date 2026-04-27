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

* `AbstractDeltaCatalog` is requested to [stageCreate](AbstractDeltaCatalog.md#stageCreate), [stageCreateOrReplace](AbstractDeltaCatalog.md#stageCreateOrReplace), and [stageReplace](AbstractDeltaCatalog.md#stageReplace)

### CreationMode { #operation }

`StagedDeltaTableV2` is given a `CreationMode` when [created](#creating-instance).

TableCreationModes | AbstractDeltaCatalog's Operation
-|-
 `Create` | [stageCreate](AbstractDeltaCatalog.md#stageCreate)
 `CreateOrReplace` | [stageCreateOrReplace](AbstractDeltaCatalog.md#stageCreateOrReplace)
 `Replace` | [stageReplace](AbstractDeltaCatalog.md#stageReplace)

## commitStagedChanges { #commitStagedChanges }

??? note "StagedTable"

    ```scala
    commitStagedChanges(): Unit
    ```

    `commitStagedChanges` is part of the `StagedTable` ([Spark SQL]({{ book.spark_sql }}/connector/StagedTable/#commitStagedChanges)) abstraction.

`commitStagedChanges` [getTablePropsAndWriteOptions](AbstractDeltaCatalog.md#getTablePropsAndWriteOptions) from this [properties](#properties).

`commitStagedChanges`...FIXME

`commitStagedChanges` [expandTableProps](AbstractDeltaCatalog.md#expandTableProps).

When in [Unity Catalog execution mode](AbstractDeltaCatalog.md#isUnityCatalog), `commitStagedChanges` [translateUCTableIdProperty](AbstractDeltaCatalog.md#translateUCTableIdProperty).

In the end, `commitStagedChanges` [createDeltaTable](AbstractDeltaCatalog.md#createDeltaTable).

## Creating WriteBuilder { #newWriteBuilder }

??? note "SupportsWrite"

    ```scala
    newWriteBuilder(
      info: LogicalWriteInfo): WriteBuilder
    ```

    `newWriteBuilder` is part of the `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite/#newWriteBuilder)) abstraction.

`newWriteBuilder` creates a [DeltaV1WriteBuilder](DeltaV1WriteBuilder.md) (with the `options` of the given `LogicalWriteInfo`).
