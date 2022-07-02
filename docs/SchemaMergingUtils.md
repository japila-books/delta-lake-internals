# SchemaMergingUtils

## <span id="checkColumnNameDuplication"> Asserting No Column Name Duplication

```scala
checkColumnNameDuplication(
  schema: StructType,
  colType: String): Unit
```

`checkColumnNameDuplication` [explodes the nested field names](#explodeNestedFieldNames) in the given schema (`StructType`) and throws a `DeltaAnalysisException` if there are duplicates.

??? note "Possible performance improvement"
    I think it's possible to make `checkColumnNameDuplication` faster as it currently seems to do more than is really required to check for column duplication.

    A schema is a tree so a duplication is when there are two nodes of the same name (lowercase) at any given level. If there is no duplicates at the highest level, there's no need to check duplicates down the tree.

??? note "colType"
    The name of `colType` input argument is misleading and does not really say what it is for. It is used only for an error message to describe the operation that led to column duplication.

`checkColumnNameDuplication` is used when:

* `DeltaLog` is requested to [upgrade the protocol](DeltaLog.md#upgradeProtocol)
* `OptimisticTransactionImpl` is requested to [verify a new metadata](OptimisticTransactionImpl.md#verifyNewMetadata)
* [AlterTableAddColumnsDeltaCommand](commands/alter/AlterTableAddColumnsDeltaCommand.md) and [AlterTableReplaceColumnsDeltaCommand](commands/alter/AlterTableReplaceColumnsDeltaCommand.md) are executed
* `SchemaMergingUtils` utility is used to [mergeSchemas](#mergeSchemas)

### <span id="checkColumnNameDuplication-demo"> Demo

```scala
import org.apache.spark.sql.delta.schema.SchemaMergingUtils
import org.apache.spark.sql.types._
val duplicatedCol = StructField("duplicatedCol", StringType)
val schema = (new StructType)
  .add(duplicatedCol)
  .add(duplicatedCol)
```

```scala
SchemaMergingUtils.checkColumnNameDuplication(schema, colType = "in the demo")
```

```text
org.apache.spark.sql.AnalysisException: Found duplicate column(s) in the demo: duplicatedcol
  at org.apache.spark.sql.delta.DeltaAnalysisException$.apply(DeltaSharedExceptions.scala:57)
  at org.apache.spark.sql.delta.schema.SchemaMergingUtils$.checkColumnNameDuplication(SchemaMergingUtils.scala:117)
  ... 49 elided
```

## <span id="explodeNestedFieldNames"> explodeNestedFieldNames

```scala
explodeNestedFieldNames(
  schema: StructType): Seq[String]
```

`explodeNestedFieldNames` [explodes](#explode) the given schema into a collection of column names (name parts separated by `.`).

`explodeNestedFieldNames` is used when:

* `SchemaMergingUtils` utility is used to [checkColumnNameDuplication](#checkColumnNameDuplication)
* `SchemaUtils` utility is used to [normalizeColumnNames](SchemaUtils.md#normalizeColumnNames) and [checkSchemaFieldNames](SchemaUtils.md#checkSchemaFieldNames)

### <span id="explodeNestedFieldNames-demo"> Demo

```scala
import org.apache.spark.sql.types._
val m = MapType(keyType = LongType, valueType = StringType)
val s = (new StructType)
  .add(StructField("id", LongType))
  .add(StructField("name", StringType))
val a = ArrayType(elementType = (new StructType)
  .add(StructField("id", LongType))
  .add(StructField("name", StringType)))
val schema = (new StructType)
  .add(StructField("l", LongType))
  .add(StructField("s", s))
  .add(StructField("a", a))
  .add(StructField("m", m))
```

```scala
import org.apache.spark.sql.delta.schema.SchemaMergingUtils
val colNames = SchemaMergingUtils.explodeNestedFieldNames(schema)
```

```scala
colNames.foreach(println)
```

```text
l
s
s.id
s.name
a
a.element.id
a.element.name
m
```

## <span id="explode"> Exploding Schema

```scala
explode(
  schema: StructType): Seq[(Seq[String], StructField)]
```

`explode` explodes the given schema (`StructType`) into a collection of pairs of column name parts and the associated  `StructField`. The nested fields (`StructType`s, `ArrayType`s and `MapType`s) are flattened out.

`explode` is used when:

* `DeltaColumnMappingBase` is requested to [getPhysicalNameFieldMap](column-mapping/DeltaColumnMappingBase.md#getPhysicalNameFieldMap)
* `SchemaMergingUtils` utility is used to [explodeNestedFieldNames](#explodeNestedFieldNames)

### <span id="explode-demo"> Demo

!!! todo "FIXME"
    Move the examples to Delta Lake (as unit tests).

#### <span id="explode-demo-MapType"> MapType

```scala
import org.apache.spark.sql.delta.schema.SchemaMergingUtils
import org.apache.spark.sql.types._

val m = MapType(keyType = LongType, valueType = StringType)
val schemaWithMap = (new StructType).add(StructField("m", m))
val r = SchemaMergingUtils.explode(schemaWithMap)
r.foreach(println)
```

```text
(List(m),StructField(m,MapType(LongType,StringType,true),true))
```

```scala
r.map { case (ns, f) => s"${ns.mkString} -> ${f.dataType.sql}" }.foreach(println)
```

```text
m -> MAP<BIGINT, STRING>
```

#### <span id="explode-demo-ArrayType"> ArrayType

```scala
import org.apache.spark.sql.delta.schema.SchemaMergingUtils
import org.apache.spark.sql.types._

val idName = (new StructType)
  .add(StructField("id", LongType))
  .add(StructField("name", StringType))
val a = ArrayType(elementType = idName)
val schemaWithArray = (new StructType).add(StructField("a", a))
val r = SchemaMergingUtils.explode(schemaWithArray)
r.foreach(println)
```

```text
(List(a),StructField(a,ArrayType(StructType(StructField(id,LongType,true), StructField(name,StringType,true)),true),true))
(List(a, element, id),StructField(id,LongType,true))
(List(a, element, name),StructField(name,StringType,true))
```

```scala
r.map { case (ns, f) => s"${ns.mkString} -> ${f.dataType.sql}" }.foreach(println)
```

```text
a -> ARRAY<STRUCT<`id`: BIGINT, `name`: STRING>>
aelementid -> BIGINT
aelementname -> STRING
```

#### <span id="explode-demo-StructType"> StructType

```scala
import org.apache.spark.sql.delta.schema.SchemaMergingUtils
import org.apache.spark.sql.types._

val s = (new StructType)
  .add(StructField("id", LongType))
  .add(StructField("name", StringType))
val schemaWithStructType = (new StructType).add(StructField("s", s))
val r = SchemaMergingUtils.explode(schemaWithStructType)
r.foreach(println)
```

```text
(List(s),StructField(s,StructType(StructField(id,LongType,true), StructField(name,StringType,true)),true))
(List(s, id),StructField(id,LongType,true))
(List(s, name),StructField(name,StringType,true))
```

```scala
r.map { case (ns, f) => s"${ns.mkString} -> ${f.dataType.sql}" }.foreach(println)
```

```text
s -> STRUCT<`id`: BIGINT, `name`: STRING>
sid -> BIGINT
sname -> STRING
```

#### <span id="explode-demo-StructType"> Complex Schema

```scala
import org.apache.spark.sql.types._
val m = MapType(keyType = LongType, valueType = StringType)
val s = (new StructType)
  .add(StructField("id", LongType))
  .add(StructField("name", StringType))
val a = ArrayType(elementType = (new StructType)
  .add(StructField("id", LongType))
  .add(StructField("name", StringType)))
val schema = (new StructType)
  .add(StructField("l", LongType))
  .add(StructField("s", s))
  .add(StructField("a", a))
  .add(StructField("m", m))
```

```scala
import org.apache.spark.sql.delta.schema.SchemaMergingUtils
val r = SchemaMergingUtils.explode(schema)
```

```scala
r.foreach(println)
```

```text
(List(l),StructField(l,LongType,true))
(List(s),StructField(s,StructType(StructField(id,LongType,true), StructField(name,StringType,true)),true))
(List(s, id),StructField(id,LongType,true))
(List(s, name),StructField(name,StringType,true))
(List(a),StructField(a,ArrayType(StructType(StructField(id,LongType,true), StructField(name,StringType,true)),true),true))
(List(a, element, id),StructField(id,LongType,true))
(List(a, element, name),StructField(name,StringType,true))
(List(m),StructField(m,MapType(LongType,StringType,true),true))
```

```scala
r.map { case (ns, f) => s"${ns.mkString} -> ${f.dataType.sql}" }.foreach(println)
```

```text
l -> BIGINT
s -> STRUCT<`id`: BIGINT, `name`: STRING>
sid -> BIGINT
sname -> STRING
a -> ARRAY<STRUCT<`id`: BIGINT, `name`: STRING>>
aelementid -> BIGINT
aelementname -> STRING
m -> MAP<BIGINT, STRING>
```
