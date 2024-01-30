---
title: ClusteredTableUtils
---

# ClusteredTableUtilsBase (ClusteredTableUtils)

## isSupported { #isSupported }

```scala
isSupported(
  protocol: Protocol): Boolean
```

`isSupported` requests the given [Protocol](../Protocol.md) to [isFeatureSupported](../table-features/TableFeatureSupport.md#isFeatureSupported) with [ClusteringTableFeature](ClusteringTableFeature.md).

---

`isSupported` is used when:

* `CreateDeltaTableCommand` is requested to [validatePrerequisitesForClusteredTable](../commands/CreateDeltaTableCommand.md#validatePrerequisitesForClusteredTable)
* `OptimizeExecutor` is requested to [isClusteredTable](../commands/optimize/OptimizeExecutor.md#isClusteredTable)
* [Optimize](../commands/optimize/index.md) command is executed
* `ClusteredTableUtilsBase` is requested to [validatePreviewEnabled](ClusteredTableUtilsBase.md#validatePreviewEnabled)

## validatePreviewEnabled { #validatePreviewEnabled }

```scala
validatePreviewEnabled(
  protocol: Protocol): Unit
validatePreviewEnabled(
  maybeClusterBySpec: Option[ClusterBySpec]): Unit
```

??? warning "Procedure"
    `validatePreviewEnabled` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`validatePreviewEnabled`...FIXME

---

`validatePreviewEnabled` is used when:

* [Optimize](../commands/optimize/index.md) command is executed
* `WriteIntoDelta` command is requested to [write data out (to a delta table)](../commands/WriteIntoDelta.md#write)
* `DeltaCatalog` is requested to [create a delta table](../DeltaCatalog.md#createDeltaTable) (and [validateClusterBySpec](../DeltaCatalog.md#validateClusterBySpec))
