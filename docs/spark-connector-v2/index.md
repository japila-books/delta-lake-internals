---
title: Kernel-Based Spark Connector
subtitle: Spark Connector V2
---

# Kernel-Based Spark Connector V2

**Kernel-Based Spark Connector** is a Spark SQL extension (based on [Connector API]({{ book.spark_sql }}/connector)) to read and write delta tables using [Delta Kernel API](../kernel/index.md).

Kernel-Based Spark Connector (aka _Spark Connector V2_) is supposed to replace the [Spark Connector V1](../spark-connector/index.md) and become an integration layer of Delta Lake with Spark SQL, with as many features "push down to the bottom" (i.e., [Delta Kernel API](../kernel/index.md)).
