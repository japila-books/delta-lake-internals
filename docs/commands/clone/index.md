# SHALLOW CLONE

Delta Lake supports [SHALLOW CLONE](../../sql/DeltaSqlAstBuilder/#visitClone) clause in `CREATE TABLE` and `REPLACE TABLE` statements.

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
    : FOR? (SYSTEM_VERSION | VERSION) AS OF version
    | FOR? (SYSTEM_TIME | TIMESTAMP) AS OF timestamp
    ;
```

`SHALLOW CLONE` becomes a [CloneTableStatement](CloneTableStatement.md) logical operator in a logical query plan that is resolved to a [CreateDeltaTableCommand](../CreateDeltaTableCommand.md).
