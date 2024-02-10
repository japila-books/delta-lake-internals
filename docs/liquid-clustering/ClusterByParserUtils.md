# ClusterByParserUtils

`ClusterByParserUtils` is used to parse [ClusterByPlan](ClusterByPlan.md).

!!! note
    `ClusterByParserUtils` is slated to be removed when `CLUSTER BY` clause is supported natively in Apache Spark (likely in [4.0.0](https://issues.apache.org/jira/browse/SPARK-44886)).

## Creating Instance

`ClusterByParserUtils` takes the following to be created:

* <span id="clusterByPlan"> [ClusterByPlan](ClusterByPlan.md)
* <span id="delegate"> `ParserInterface` ([Spark SQL]({{ book.spark_sql }}/sql/ParserInterface))

`ClusterByParserUtils` is created when:

* `DeltaSqlParser` is requested to [parse a ClusterByPlan](../sql/DeltaSqlParser.md#parsePlan)
