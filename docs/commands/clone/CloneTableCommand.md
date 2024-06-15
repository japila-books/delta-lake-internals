# CloneTableCommand

`CloneTableCommand` is a [CloneTableBase](CloneTableBase.md).

## Creating Instance

`CloneTableCommand` takes the following to be created:

* <span id="sourceTable"> Source table to clone
* <span id="targetIdent"> Target table
* <span id="tablePropertyOverrides"> User-Defined Table Properties (to override the source table's properties)
* <span id="targetPath"> Destination Path (of the target table)

`CloneTableCommand` is created when:

* `DeltaAnalysis` is requested to [resolveCloneCommand](../../DeltaAnalysis.md#resolveCloneCommand)

## handleClone { #handleClone }

```scala
handleClone(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  targetDeltaLog: DeltaLog): Seq[Row]
```

`handleClone`...FIXME

---

`handleClone` is used when:

* `CreateDeltaTableCommand` is requested to [handle a transaction commit](../create-table/CreateDeltaTableCommand.md#handleCommit)
