# DeltaScanWithRowTrackingEnabled

`DeltaScanWithRowTrackingEnabled` is a Scala extractor object to [match a scan on a delta table with Row Tracking enabled](#unapply).

??? note "Scala Extractor Object"
    `DeltaScanWithRowTrackingEnabled` is a Scala extractor object (with an [unapply](#unapply) method) to match a pattern and extract data values.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/08-pattern-matching.html#extractor-patterns) and the [Tour of Scala](https://docs.scala-lang.org/tour/extractor-objects.html).

## unapply { #unapply }

```scala
unapply(
  plan: LogicalPlan): Option[LogicalRelation]
```

`unapply` returns the given `LogicalPlan` if it is a `LogicalRelation` over a `HadoopFsRelation` with a [DeltaParquetFileFormat](../DeltaParquetFileFormat.md) with [Row Tracking enabled](RowTracking.md#isEnabled). Otherwise, `unapply` returns `None` (_nothing matches_).

---

`unapply` is used when:

* [GenerateRowIDs](GenerateRowIDs.md) logical rule is executed
