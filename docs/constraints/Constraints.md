# Constraints Utility

## <span id="getAll"> Extracting All Constraints

```scala
getAll(
  metadata: Metadata,
  spark: SparkSession): Seq[Constraint]
```

`getAll` [extracts CHECK constraints](#getCheckConstraints) (from the given [table metadata](../Metadata.md)).

`getAll` [extracts invariants](../column-invariants/Invariants.md#getFromSchema) (from the [schema](../Metadata.md#schema) of the given [table metadata](../Metadata.md)).

In the end, `getAll` returns the CHECK constraints and invariants.

---

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

* `Constraints` utility is used to [extract all constraints](#getAll)
* `Protocol` utility is used to [determine the required minimum protocol](../Protocol.md#requiredMinimumProtocol)
