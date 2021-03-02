# Delta SQL

Delta Lake registers custom SQL statements (using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md) to inject [DeltaSqlParser](DeltaSqlParser.md) with [DeltaSqlAstBuilder](DeltaSqlAstBuilder.md)).

The SQL statements support `table` of the format `` delta.`path` `` (with backticks), e.g. `` delta.`/tmp/delta/t1` `` while `path` is between single quotes, e.g. `'/tmp/delta/t1'`.

The SQL statements can also refer to a table registered in a metastore.

!!! note
    SQL grammar is described using ANTLR in [DeltaSqlBase.g4]({{ delta.github }}/src/main/antlr4/io/delta/sql/parser/DeltaSqlBase.g4).

## <span id="ALTER-TABLE-ADD-CONSTRAINT"> ALTER TABLE ADD CONSTRAINT

```text
ALTER TABLE table
ADD CONSTRAINT name constraint
```

## <span id="ALTER-TABLE-DROP-CONSTRAINT"> ALTER TABLE DROP CONSTRAINT

```text
ALTER TABLE table
DROP CONSTRAINT (IF EXISTS)? name
```

## <span id="CONVERT-TO-DELTA"> CONVERT TO DELTA

```text
CONVERT TO DELTA table
  (PARTITIONED BY '(' colTypeList ')')?
```

Runs a [ConvertToDeltaCommand](../commands/ConvertToDeltaCommand.md)

## <span id="DESCRIBE-DETAIL"> DESCRIBE DETAIL

```text
(DESC | DESCRIBE) DETAIL (path | table)
```

Runs a [DescribeDeltaDetailCommand](../commands/DescribeDeltaDetailCommand.md)

## <span id="DESCRIBE-HISTORY"> DESCRIBE HISTORY

```text
(DESC | DESCRIBE) HISTORY (path | table)
  (LIMIT limit)?
```

Runs a [DescribeDeltaHistoryCommand](../commands/DescribeDeltaHistoryCommand.md)

## <span id="GENERATE"> GENERATE

```text
GENERATE modeName FOR TABLE table
```

Runs a [DeltaGenerateCommand](../commands/DeltaGenerateCommand.md)

## <span id="VACUUM"> VACUUM

```text
VACUUM (path | table)
  (RETAIN number HOURS)? (DRY RUN)?
```

Runs a [VacuumTableCommand](../commands/VacuumTableCommand.md)
