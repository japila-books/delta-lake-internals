# ClusterBySpec

!!! note "To be removed"
    [They say the following]({{ delta.github }}/spark/src/main/scala/org/apache/spark/sql/delta/skipping/clustering/temp/ClusterBySpec.scala#L35-L36):

    > This class will be removed when we integrate with OSS Spark's CLUSTER BY implementation.
    >
    > See https://github.com/apache/spark/pull/42577

## Creating Instance

`ClusterBySpec` takes the following to be created:

* <span id="columnNames"> Column names (`NamedReference`s)

`ClusterBySpec` is created when:

* `DeltaCatalog` is requested to [convertTransforms](../DeltaCatalog.md#convertTransforms)
* `ClusterBySpec` is requested to [apply](#apply) and [fromProperty](#fromProperty)
* `DeltaSqlAstBuilder` is requested to [parse CLUSTER BY clause](../sql/DeltaSqlAstBuilder.md#visitClusterBy)

## Creating ClusterBySpec { #apply }

```scala
apply[_: ClassTag](
  columnNames: Seq[Seq[String]]): ClusterBySpec
```

`apply` creates a [ClusterBySpec](#creating-instance) for the given `columnNames` (converted to `FieldReference`s).

!!! note "No usage found"

## (Re)Creating ClusterBySpec from Table Property { #fromProperty }

```scala
fromProperty(
  columns: String): ClusterBySpec
```

`fromProperty` creates a [ClusterBySpec](#creating-instance) for the given `columns` (being a JSON-ified `ClusterBySpec`).

!!! note
    `fromProperty` does the opposite to [toProperty](#toProperty).

---

`fromProperty` is used when:

* `ClusteredTableUtilsBase` is requested for a [ClusterBySpec](ClusteredTableUtilsBase.md#getClusterBySpecOptional)

## Converting ClusterBySpec to Table Property { #toProperty }

```scala
toProperty(
  clusterBySpec: ClusterBySpec): (String, String)
```

`toProperty` gives a pair of [clusteringColumns](ClusteredTableUtilsBase.md#clusteringColumns) and the given `ClusterBySpec` (in JSON format).

!!! note
    `toProperty` does the opposite to [fromProperty](#fromProperty).

---

`toProperty` is used when:

* `ClusteredTableUtilsBase` is requested to [getClusteringColumnsAsProperty](ClusteredTableUtilsBase.md#getClusteringColumnsAsProperty)
