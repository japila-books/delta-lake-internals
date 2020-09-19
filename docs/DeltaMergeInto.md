# DeltaMergeInto Logical Command

**DeltaMergeInto** is a logical command (Spark SQL).

== [[creating-instance]] Creating Instance

DeltaMergeInto takes the following to be created:

* [[target]] Target LogicalPlan
* [[source]] Source LogicalPlan
* [[condition]] Condition Expression
* [[matchedClauses]] Matched Clauses (`Seq[DeltaMergeIntoMatchedClause]`)
* [[notMatchedClause]] Optional Non-Matched Clause (`Option[DeltaMergeIntoInsertClause]`)
* [[migratedSchema]] Optional Migrated Schema (default: `None`)

DeltaMergeInto is created (using <<apply, apply>> and <<resolveReferences, resolveReferences>> utilities) when:

* [DeltaMergeBuilder](DeltaMergeBuilder.md) is executed

* DeltaAnalysis logical resolution rule is requested to DeltaAnalysis.adoc#apply[execute]

== [[utilities]] Utilities

=== [[apply]] apply Factory

[source,scala]
----
apply(
  target: LogicalPlan,
  source: LogicalPlan,
  condition: Expression,
  whenClauses: Seq[DeltaMergeIntoClause]): DeltaMergeInto
----

apply...FIXME

apply is used when:

* [DeltaMergeBuilder](DeltaMergeBuilder.md) is executed (and for the [logical plan for merge operation](DeltaMergeBuilder.md#mergePlan))

* DeltaAnalysis logical resolution rule is requested to DeltaAnalysis.adoc#apply[execute]

=== [[resolveReferences]] resolveReferences

[source,scala]
----
resolveReferences(
  merge: DeltaMergeInto,
  conf: SQLConf)(
  resolveExpr: (Expression, LogicalPlan) => Expression): DeltaMergeInto
----

resolveReferences...FIXME

resolveReferences is used when:

* [DeltaMergeBuilder](DeltaMergeBuilder.md) is executed

* DeltaAnalysis logical resolution rule is requested to DeltaAnalysis.adoc#apply[execute]
