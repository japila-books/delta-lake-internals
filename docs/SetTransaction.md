# SetTransaction

`SetTransaction` is an [Action](Action.md) defined by the following properties:

* <span id="appId"> Application ID (i.e. streaming query ID)
* <span id="version"> Version (i.e. micro-batch ID)
* <span id="lastUpdated"> Last Updated (optional) (i.e. milliseconds since the epoch)

`SetTransaction` is created when:

* `DeltaSink` is requested to [add a streaming micro-batch](delta/DeltaSink.md#addBatch) (for `STREAMING UPDATE` operation idempotence at query restart)

## Demo

```scala
val path = "/tmp/delta/users"

import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, path)

import org.apache.spark.sql.delta.actions.SetTransaction
assert(deltaLog.snapshot.setTransactions.isInstanceOf[Seq[SetTransaction]])

deltaLog.snapshot.setTransactions
```
