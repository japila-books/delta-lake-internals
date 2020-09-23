# Delta SQL

Delta Lake registers custom SQL commands (using [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md)).

The SQL commands support `table` of the format `` delta.`path` `` (with backticks), e.g. `` delta.`/tmp/delta/t1` `` while `path` is between single quotes, e.g. `'/tmp/delta/t1'`.

## <span id="CONVERT-TO-DELTA"> CONVERT TO DELTA

```text
CONVERT TO DELTA table
  (PARTITIONED BY '(' colTypeList ')')?
```

Runs a [ConvertToDeltaCommand](ConvertToDeltaCommand.md)

## <span id="DESCRIBE-DETAIL"> DESCRIBE DETAIL

```text
(DESC | DESCRIBE) DETAIL (path | table)
```

Runs a [DescribeDeltaDetailCommand](DescribeDeltaDetailCommand.md)

## <span id="DESCRIBE-HISTORY"> DESCRIBE HISTORY

```text
(DESC | DESCRIBE) HISTORY (path | table)
  (LIMIT limit)?
```

Runs a [DescribeDeltaHistoryCommand](DescribeDeltaHistoryCommand.md)

## <span id="GENERATE"> GENERATE

```text
GENERATE modeName FOR TABLE table
```

Runs a [DeltaGenerateCommand](DeltaGenerateCommand.md)

## <span id="VACUUM"> VACUUM

```text
VACUUM (path | table)
  (RETAIN number HOURS)? (DRY RUN)?
```

Runs a [VacuumTableCommand](VacuumTableCommand.md)
