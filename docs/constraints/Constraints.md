# Constraints Utility

## <span id="getAll"> Extracting Constraints from Table Metadata

```scala
getAll(
  metadata: Metadata,
  spark: SparkSession): Seq[Constraint]
```

`getAll` extracts [Constraint](Constraint.md)s from the given [metadata](#getCheckConstraints) and the associated [schema](Invariants.md#getFromSchema).

`getAll` is used when:

* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles)

## <span id="getCheckConstraints"> Extracting Check Constraints from Table Metadata

```scala
getCheckConstraints(
  metadata: Metadata,
  spark: SparkSession): Seq[Constraint]
```

`getCheckConstraints` extracts [Check](Constraint.md#Check) constraints from the `delta.constraints.`-keyed entries in the [configuration](../Metadata.md#configuration) of the given [Metadata](../Metadata.md):

* The name is the key without the `delta.constraints.` prefix
* The expression is the value parsed

`getCheckConstraints` is used when:

* `Protocol` utility is used to [requiredMinimumProtocol](../Protocol.md#requiredMinimumProtocol)
* `Constraints` utility is used to [getAll](#getAll)
