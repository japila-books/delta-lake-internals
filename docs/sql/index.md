# Delta SQL

Delta Lake registers custom SQL statements (using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md) to inject [DeltaSqlParser](DeltaSqlParser.md) with [DeltaSqlAstBuilder](DeltaSqlAstBuilder.md)).

The SQL statements support `table` of the format `` delta.`path` `` (with backticks), e.g. `` delta.`/tmp/delta/t1` `` while `path` is between single quotes, e.g. `'/tmp/delta/t1'`.

The SQL statements can also refer to a table registered in a metastore.

## <span id="ALTER-TABLE-ADD-CONSTRAINT"> ALTER TABLE ADD CONSTRAINT

```text
ALTER TABLE table
ADD CONSTRAINT name constraint
```

Creates a [AlterTableAddConstraintStatement](../constraints/AlterTableAddConstraintStatement.md)

## <span id="ALTER-TABLE-DROP-CONSTRAINT"> ALTER TABLE DROP CONSTRAINT

```text
ALTER TABLE table
DROP CONSTRAINT (IF EXISTS)? name
```

Creates a [AlterTableDropConstraintStatement](../constraints/AlterTableDropConstraintStatement.md)

## <span id="CONVERT-TO-DELTA"> CONVERT TO DELTA

```text
CONVERT TO DELTA table
  (PARTITIONED BY '(' colTypeList ')')?
```

Executes [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md)

## <span id="DESCRIBE-DETAIL"> DESCRIBE DETAIL

```text
(DESC | DESCRIBE) DETAIL (path | table)
```

Executes [DescribeDeltaDetailCommand](../commands/describe-detail/DescribeDeltaDetailCommand.md)

## <span id="DESCRIBE-HISTORY"> DESCRIBE HISTORY

```text
(DESC | DESCRIBE) HISTORY (path | table)
  (LIMIT limit)?
```

Executes [DescribeDeltaHistoryCommand](../commands/describe-history/DescribeDeltaHistoryCommand.md)

## <span id="GENERATE"> GENERATE

```text
GENERATE modeName FOR TABLE table
```

Executes [DeltaGenerateCommand](../commands/generate/DeltaGenerateCommand.md)

## <span id="OPTIMIZE"> OPTIMIZE

```text
OPTIMIZE (path | table)
  (WHERE partitionPredicate)?
```

Executes [OptimizeTableCommand](../commands/optimize/OptimizeTableCommand.md) (on the Delta table identified by a directory path or a table name)

## <span id="VACUUM"> VACUUM

```text
VACUUM (path | table)
  (RETAIN number HOURS)? (DRY RUN)?
```

Executes [VacuumTableCommand](../commands/vacuum/VacuumTableCommand.md)
