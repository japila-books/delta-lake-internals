# DeltaOptimizeBuilder

`DeltaOptimizeBuilder` is a builder interface for constructing and executing [OPTIMIZE](commands/optimize/index.md) command.

`DeltaOptimizeBuilder` is [created](#apply) using [DeltaTable.optimize](DeltaTable.md#optimize) operator.

In the end, `DeltaOptimizeBuilder` is supposed to be executed to take action using the following operators:

* [executeCompaction](#executeCompaction)
* [executeZOrderBy](#executeZOrderBy)

## io.delta.tables Package

`DeltaTableBuilder` belongs to `io.delta.tables` package.

```scala
import io.delta.tables.DeltaTableBuilder
```

## Demo

```scala
import io.delta.tables.DeltaTable
DeltaTable.forName("part_delta")
  .optimize()
  .where("p = 0")
  .executeZOrderBy("x", "y)
  .show(truncate = false)
```

## Operators

### <span id="executeCompaction"> executeCompaction

```scala
executeCompaction(): DataFrame
```

`executeCompaction` [executes](#execute) this `DeltaOptimizeBuilder` (with no `zOrderBy` attributes).

### <span id="executeZOrderBy"> executeZOrderBy

```scala
executeZOrderBy(
  columns: String *): DataFrame
```

`executeZOrderBy` [executes](#execute) this `DeltaOptimizeBuilder` (with the given `columns` as `zOrderBy` attributes).

### <span id="where"><span id="partitionFilter"> where

```scala
where(
  partitionFilter: String): DeltaOptimizeBuilder
```

`where` registers a `partitionFilter` and returns this `DeltaOptimizeBuilder`.

## Creating Instance

`DeltaOptimizeBuilder` takes the following to be created:

* <span id="sparkSession"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="tableIdentifier"> Table Identifier

`DeltaOptimizeBuilder` is created using [apply](#apply) factory method.

## Creating DeltaOptimizeBuilder { #apply }

```scala
apply(
  sparkSession: SparkSession,
  tableIdentifier: String): DeltaOptimizeBuilder
```

`apply` creates a [DeltaOptimizeBuilder](#creating-instance).

!!! note "A private method"
    `apply` is a private method and can only be executed using [DeltaTable.optimize](DeltaTable.md#optimize) operator.

`apply` is used when:

* `DeltaTable` is requested to [optimize](DeltaTable.md#optimize)

## Executing { #execute }

```scala
execute(
  zOrderBy: Seq[UnresolvedAttribute]): DataFrame
```

`execute` creates an [OptimizeTableCommand](commands/optimize/OptimizeTableCommand.md) (with [tableId](commands/optimize/OptimizeTableCommand.md#tableId), the [partitionFilter](#partitionFilter) and the given `zOrderBy` attributes) and executes it (while creating a `DataFrame`).

---

`execute` is used when:

* `DeltaOptimizeBuilder` is requested to [executeCompaction](#executeCompaction) and [executeZOrderBy](#executeZOrderBy)
