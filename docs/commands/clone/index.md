# SHALLOW CLONE

`CREATE TABLE` and `REPLACE TABLE` support `SHALLOW CLONE` clause.

```antlr
cloneTableHeader SHALLOW CLONE source temporalClause?
  (TBLPROPERTIES tableProps)?
  (LOCATION location)?
```

`SHALLOW CLONE` is a [CloneTableStatement](CloneTableStatement.md) in a logical query plan.
