= Demo: Observing Transaction Retries

Enable `ALL` logging level for ROOT:OptimisticTransaction.md#logging[org.apache.spark.sql.delta.OptimisticTransaction] logger. You'll be looking for the following DEBUG message in the logs:

```
Attempting to commit version [version] with 13 actions with Serializable isolation level
```

Start with <<Debugging-Delta-Lake-Using-IntelliJ-IDEA.md#, Debugging Delta Lake Using IntelliJ IDEA>> and place the following line breakpoints in `OptimisticTransactionImpl`:

. In `OptimisticTransactionImpl.doCommit` when a transaction is about to `deltaLog.store.write` (line 388)

. In `OptimisticTransactionImpl.doCommit` when a transaction is about to `checkAndRetry` after a `FileAlreadyExistsException` (line 433)

. In `OptimisticTransactionImpl.checkAndRetry` when a transaction calculates `nextAttemptVersion` (line 453)

In order to interfere with a transaction about to be committed, you will use ROOT:WriteIntoDelta.md[WriteIntoDelta] action (it is simple and does the work).

Run the command (copy and paste the ROOT:WriteIntoDelta.md#demo[demo code] to `spark-shell` using paste mode). You should see the following messages in the logs:

```
scala> writeCmd.run(spark)
DeltaLog: DELTA: Updating the Delta table's state
OptimisticTransaction: Attempting to commit version 6 with 13 actions with Serializable isolation level
```

That's when you "commit" another transaction (to simulate two competing transactional writes). Simply create a delta file for the transaction. The commit version in the message above is `6` so the name of the delta file should be `00000000000000000006.json`:

```
$ touch /tmp/delta/t1/_delta_log/00000000000000000006.json
```

`F9` in IntelliJ IDEA to resume the `WriteIntoDelta` command. It should stop at `checkAndRetry` due to `FileAlreadyExistsException`. Press `F9` twice to resume.

You should see the following messages in the logs:

```
OptimisticTransaction: No logical conflicts with deltas [6, 7), retrying.
OptimisticTransaction: Attempting to commit version 7 with 13 actions with Serializable isolation level
```

_Rinse and repeat._ You know the drill already. Happy debugging!
