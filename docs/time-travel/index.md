---
hide:
  - toc
---

# Time Travel

Delta Lake supports **Time Travelling** which is loading a Delta table at a given version or timestamp (defined by [path](../spark-connector/options.md#path), [versionAsOf](../spark-connector/options.md#versionAsOf) or [timestampAsOf](../spark-connector/options.md#timestampAsOf) options).

Delta Lake allows `path` option to include [time travel](../DeltaTableUtils.md#extractIfPathContainsTimeTravel) patterns (`@v123` and `@yyyyMMddHHmmssSSS`) unless the internal [spark.databricks.delta.timeTravel.resolveOnIdentifier.enabled](../configuration-properties/DeltaSQLConf.md#timeTravel.resolveOnIdentifier.enabled) configuration property is turned off.

Time Travel cannot be specified for catalog delta tables.

Time travel is described using [DeltaTimeTravelSpec](DeltaTimeTravelSpec.md).

[Demo: Time Travel](../demo/time-travel.md)
