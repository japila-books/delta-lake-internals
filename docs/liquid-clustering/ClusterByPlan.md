---
title: ClusterByPlan
---

# ClusterByPlan Leaf Logical Operator

`ClusterByPlan` is a `LeafNode` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafNode)).

`ClusterByPlan` is used to create a [ClusterByParserUtils](ClusterByParserUtils.md).

!!! note "To be removed"
    [They say the following]({{ delta.github }}/spark/src/main/scala/org/apache/spark/sql/delta/skipping/clustering/temp/ClusterBySpec.scala#L74-L75):

    > This class will be removed when we integrate with OSS Spark's CLUSTER BY implementation.
    >
    > See https://github.com/apache/spark/pull/42577

## Creating Instance

`ClusterByPlan` takes the following to be created:

* <span id="clusterBySpec"> [ClusterBySpec](ClusterBySpec.md)
* <span id="startIndex"> Start Index
* <span id="stopIndex"> Stop Index
* <span id="parenStartIndex"> `parenStartIndex`
* <span id="parenStopIndex"> `parenStopIndex`
* <span id="ctx"> Antlr's `ParserRuleContext`

`ClusterByPlan` is created when:

* `DeltaSqlAstBuilder` is requested to [parse CLUSTER BY clause](../sql/DeltaSqlAstBuilder.md#visitClusterBy)
