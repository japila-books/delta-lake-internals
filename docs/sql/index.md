# Delta SQL

Delta Lake registers custom SQL statements (using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md) that injects [DeltaSqlParser](DeltaSqlParser.md) with [DeltaSqlAstBuilder](DeltaSqlAstBuilder.md)).

The SQL statements support table identifiers of the format `` delta.`path` `` (with backticks), e.g. `` delta.`/tmp/delta/t1` `` while `path` is between single quotes, e.g. `'/tmp/delta/t1'`.

The SQL statements can also refer to tables that are registered in a catalog (_metastore_).

## ALTER TABLE ADD CONSTRAINT { #ALTER-TABLE-ADD-CONSTRAINT }

```text
ALTER TABLE table
ADD CONSTRAINT name
CHECK (expr+)
```

Creates an [AlterTableAddConstraint](../check-constraints/AlterTableAddConstraint.md)

## ALTER TABLE DROP CONSTRAINT { #ALTER-TABLE-DROP-CONSTRAINT }

```text
ALTER TABLE table
DROP CONSTRAINT (IF EXISTS)? name
```

Creates a [AlterTableDropConstraint](../check-constraints/AlterTableDropConstraint.md)

## ALTER TABLE DROP FEATURE { #ALTER-TABLE-DROP-FEATURE }

```text
ALTER TABLE table
DROP FEATURE featureName (TRUNCATE HISTORY)?
```

Creates a [AlterTableDropFeature](../commands/alter/AlterTableDropFeature.md) logical operator

## CLONE { #clone }

```antlr
cloneTableHeader SHALLOW CLONE source temporalClause?
  (TBLPROPERTIES tableProps)?
  (LOCATION location)?

cloneTableHeader
    : createTableHeader
    | replaceTableHeader
    ;

createTableHeader
    : CREATE TABLE (IF NOT EXISTS)? table
    ;

replaceTableHeader
    : (CREATE OR)? REPLACE TABLE table
    ;

temporalClause
    : FOR? (SYSTEM_VERSION | VERSION) AS OF version=(INTEGER_VALUE | STRING)
    | FOR? (SYSTEM_TIME | TIMESTAMP) AS OF timestamp=STRING
    ;
```

Creates a [CloneTableStatement](../commands/clone/CloneTableStatement.md)

## CONVERT TO DELTA { #CONVERT-TO-DELTA }

```text
CONVERT TO DELTA table
  (NO STATISTICS)?
  (PARTITIONED BY (colTypeList))?
```

Creates a [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md)

## DESCRIBE DETAIL { #DESCRIBE-DETAIL }

```text
(DESC | DESCRIBE) DETAIL (path | table)
```

Executes [DescribeDeltaDetailCommand](../commands/describe-detail/DescribeDeltaDetailCommand.md)

## DESCRIBE HISTORY

```text
(DESC | DESCRIBE) HISTORY (path | table)
  (LIMIT limit)?
```

Creates a [DescribeDeltaHistory](../commands/describe-history/DescribeDeltaHistory.md)

## GENERATE { #GENERATE }

```text
GENERATE modeName FOR TABLE table
```

Executes [DeltaGenerateCommand](../commands/generate/DeltaGenerateCommand.md)

## OPTIMIZE { #OPTIMIZE }

```text
OPTIMIZE (path | table)
  (WHERE partitionPredicate)?
  (zorderSpec)?

zorderSpec
    : ZORDER BY '(' interleave (, interleave)* ')'
    | ZORDER BY interleave (, interleave)*
    ;
```

Executes [OptimizeTableCommand](../commands/optimize/OptimizeTableCommand.md) on a delta table (identified by a directory `path` or a `table` name)

Parsed by [DeltaSqlAstBuilder](DeltaSqlAstBuilder.md#visitOptimizeTable) that creates an [OptimizeTableCommand](../commands/optimize/OptimizeTableCommand.md)

## RESTORE { #RESTORE }

```text
RESTORE TABLE? table
TO? temporalClause

temporalClause
    : FOR? (SYSTEM_VERSION | VERSION) AS OF version
    | FOR? (SYSTEM_TIME | TIMESTAMP) AS OF timestamp
    ;
```

Creates a [RestoreTableStatement](../commands/restore/RestoreTableStatement.md)

## VACUUM { #VACUUM }

```text
VACUUM (path | table)
  (RETAIN number HOURS)? (DRY RUN)?
```

Executes [VacuumTableCommand](../commands/vacuum/VacuumTableCommand.md)
