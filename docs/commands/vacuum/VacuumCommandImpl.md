# VacuumCommandImpl

`VacuumCommandImpl` is a [DeltaCommand](../DeltaCommand.md).

!!! note
    `VacuumCommandImpl` is a Scala trait just to let Databricks provide a commercial version of vacuum command.

## <span id="delete"> delete

```scala
delete(
  diff: Dataset[String],
  spark: SparkSession,
  basePath: String,
  hadoopConf: Broadcast[SerializableConfiguration],
  parallel: Boolean): Long
```

`delete`...FIXME

`delete` is used when:

* `VacuumCommand` is requested to [gc](VacuumCommand.md#gc)
