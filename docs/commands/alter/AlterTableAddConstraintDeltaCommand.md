# AlterTableAddConstraintDeltaCommand

`AlterTableAddConstraintDeltaCommand` is a transactional [AlterDeltaTableCommand](AlterDeltaTableCommand.md) to register a new CHECK constraint (when [altering a delta table](../../DeltaCatalog.md#alterTable) with [AddConstraint](../../check-constraints/AddConstraint.md) table changes).

`AlterTableAddConstraintDeltaCommand` represents the [ALTER TABLE ADD CONSTRAINT](../../sql/index.md#alter-table-add-constraint) SQL command.

## Creating Instance

`AlterTableAddConstraintDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="name"> Constraint Name
* <span id="exprText"> Constraint SQL Expression (text)

`AlterTableAddConstraintDeltaCommand` is created when:

* `DeltaCatalog` is requested to [alter a delta table](../../DeltaCatalog.md#alterTable) (with [AddConstraint](../../check-constraints/AddConstraint.md) table changes)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

### <span id="run-startTransaction"> Begin Transaction

`run` [starts a transaction](AlterDeltaTableCommand.md#startTransaction).

### <span id="run-updateMetadata"> Update Metadata

`run` creates a new [Metadata](../../Metadata.md) with the [configuration](../../Metadata.md#configuration) altered to include the [name](../../constraints/Constraints.md#checkConstraintPropertyName) and the given [exprText](#exprText).

### <span id="run-checkExisting"> Check Existing Data (Full Scan)

`run` prints out the following INFO message to the logs:

```text
Checking that [exprText] is satisfied for existing data.
This will require a full table scan.
```

`run` creates a `DataFrame` that represents the version of the delta table (based on the [Snapshot](../../OptimisticTransaction.md) and the [AddFile](../../OptimisticTransactionImpl.md#filterFiles)s). `run` counts the records that satisfy the `WHERE` clause:

```text
((NOT [expr]) OR ([expr] IS UNKNOWN))
```

### <span id="run-commit"> Commit Transaction

With no rows violating the check constraint, `run` [commits](../../OptimisticTransactionImpl.md#commit) the transaction with the new [Metadata](#run-updateMetadata) and `ADD CONSTRAINT` operation (with the given [name](#name) and [exprText](#exprText)).

In the end, `run` returns an empty collection.

## AnalysisExceptions

### <span id="__CHAR_VARCHAR_STRING_LENGTH_CHECK__"> Illegal Constraint Name

`run` throws an `AnalysisException` when the name of the table constraint is `__CHAR_VARCHAR_STRING_LENGTH_CHECK__`:

```text
Cannot use '__CHAR_VARCHAR_STRING_LENGTH_CHECK__' as the name of a CHECK constraint.
```

### <span id="run-DELTA_CONSTRAINT_ALREADY_EXISTS"> Constraint Already Exists

`run` throws an `AnalysisException` when the given [name](#name) is already in use (by an existing constraint):

```text
Constraint '[name]' already exists as a CHECK constraint. Please delete the old constraint first.
Old constraint:
[oldExpr]
```

### <span id="run-DELTA_NON_BOOLEAN_CHECK_CONSTRAINT"> Constraint Non-Boolean

`run` throws an `AnalysisException` when the given [exprText](#exprText) does not produce a `BooleanType` value:

```text
CHECK constraint '[name]' ([expr]) should be a boolean expression.
```

### <span id="run-DELTA_NEW_CHECK_CONSTRAINT_VIOLATION"> Constraint Violation

`run` throws an `AnalysisException` when there are rows that violate the new constraint (with the [name](../../DeltaTableV2.md#name) of the delta table and the [exprText](#exprText)):

```text
[num] rows in [name] violate the new CHECK constraint ([exprText])
```

## <span id="RunnableCommand"> RunnableCommand

`AlterTableAddConstraintDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) logical operator.

## <span id="IgnoreCachedData"> IgnoreCachedData

`AlterTableAddConstraintDeltaCommand` is a `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData/)) logical operator.

## Demo

### <span id="demo-create-table"> Create Table

```scala
sql("""
DROP TABLE IF EXISTS delta_demo;
""")
```

```scala
sql("""
CREATE TABLE delta_demo (id INT)
USING delta;
""")
```

### <span id="demo-logging"> Adding Constraint

Enable [logging](#logging) to see the following INFO message in the logs:

```text
Checking that id > 5 is satisfied for existing data.
This will require a full table scan.
```

```scala
sql("""
ALTER TABLE delta_demo
ADD CONSTRAINT demo_check_constraint CHECK (id > 5);
""")
```

### <span id="demo-history"> DESC HISTORY

```scala
sql("""
DESC HISTORY delta_demo;
""")
  .select('version, 'operation, 'operationParameters)
  .show(truncate = false)
```

```text
+-------+--------------+-----------------------------------------------------------------------------+
|version|operation     |operationParameters                                                          |
+-------+--------------+-----------------------------------------------------------------------------+
|1      |ADD CONSTRAINT|{name -> demo_check_constraint, expr -> id > 5}                              |
|0      |CREATE TABLE  |{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|
+-------+--------------+-----------------------------------------------------------------------------+
```

### <span id="demo-check-constraint-violation"> DeltaInvariantViolationException

```scala
sql("""
INSERT INTO delta_demo VALUES 3;
""")
```

```text
DeltaInvariantViolationException: CHECK constraint demo_check_constraint (id > 5) violated by row with values:
 - id : 3
```

### <span id="demo-metadata"> Metadata

[CHECK constraints](../../constraints/Constraint.md#Check) are stored in [Metadata](../../constraints/Constraints.md#getCheckConstraints) of a delta table.

```scala
sql("""
SHOW TBLPROPERTIES delta_demo;
""")
  .where('key startsWith "delta.constraints.")
  .show(truncate = false)
```

```text
+---------------------------------------+------+
|key                                    |value |
+---------------------------------------+------+
|delta.constraints.demo_check_constraint|id > 5|
+---------------------------------------+------+
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.AlterTableAddConstraintDeltaCommand` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.commands.AlterTableAddConstraintDeltaCommand=ALL
```

Refer to [Logging](../../logging.md).
