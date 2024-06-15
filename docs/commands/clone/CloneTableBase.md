# CloneTableBase

`CloneTableBase` is an [extension](#contract) of the `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command)) abstraction for [CLONE TABLE commands](#implementations).

## Implementations

* [CloneTableCommand](CloneTableCommand.md)

## handleClone { #handleClone }

```scala
handleClone(
  spark: SparkSession,
  txn: OptimisticTransaction,
  destinationTable: DeltaLog,
  hdpConf: Configuration,
  deltaOperation: DeltaOperations.Operation): Seq[Row]
```

`handleClone`...FIXME

---

`handleClone` is used when:

* `CloneTableCommand` is requested to [handleClone](CloneTableCommand.md#handleClone)
