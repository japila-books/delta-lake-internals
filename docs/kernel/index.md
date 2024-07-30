# Delta Kernel

**Delta Kernel** is a Java API (abstractions) for working with delta tables, getting their snapshots and creating scan objects to scan a subset of the data in the tables.

``` text
libraryDependencies += "io.delta" % "delta-kernel-api" % "{{ delta.version }}"
libraryDependencies += "io.delta" % "delta-kernel-defaults" % "{{ delta.version }}"
libraryDependencies += "org.apache.hadoop" % "hadoop-client-api" % "{{ hadoop.version }}"
libraryDependencies += "org.apache.hadoop" % "hadoop-client-runtime" % "{{ hadoop.version }}"
```

[Table.forPath](Table.md#forPath) utility is used to create a delta table. A required [Engine](Engine.md) can be created using [DefaultEngine.create](DefaultEngine.md#create) utility.

```scala
import org.apache.hadoop.conf.Configuration
val hadoopConf = new Configuration(false)

import io.delta.kernel.defaults.engine.DefaultEngine
val engine = DefaultEngine.create(hadoopConf)

val dataPath = "/tmp/delta-table"

import io.delta.kernel.Table
val deltaTable = Table.forPath(engine, dataPath)

assert(deltaTable.getPath(engine) == s"file:${dataPath}")
```
