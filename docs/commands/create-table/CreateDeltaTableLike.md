---
title: CreateDeltaTableLike
---

# CreateDeltaTableLike Commands

`CreateDeltaTableLike` is an [abstraction](#contract) of [commands](#implementations) that can create delta tables.

## Contract (Subset)

### allowCatalogManaged { #allowCatalogManaged }

```scala
allowCatalogManaged: Boolean
```

Whether the table is a [catalog-managed table](../../catalog-managed-tables/index.md)

See:

* [CreateDeltaTableCommand](CreateDeltaTableCommand.md#allowCatalogManaged)

Used when:

* `AbstractDeltaCatalog` is requested to [createDeltaTable](../../AbstractDeltaCatalog.md#createDeltaTable)
* `CreateDeltaTableLike` is requested to [cleanupTableDefinition](#cleanupTableDefinition) and [updateCatalog](#updateCatalog)

## Implementations

* [CreateDeltaTableCommand](CreateDeltaTableCommand.md)
