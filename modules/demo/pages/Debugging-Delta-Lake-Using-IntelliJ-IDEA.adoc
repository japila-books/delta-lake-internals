= Demo: Debugging Delta Lake Using IntelliJ IDEA

Import Delta Lake's https://github.com/delta-io/delta[sources] to IntelliJ IDEA.

Configure a new Remote debug configuration in IntelliJ IDEA (e.g. Run > Debug > Edit Configurations...) and simply give it a name and save.

TIP: Use `Option+Ctrl+D` to access Debug menu.

.Remote JVM Configuration
image::demo-remote-jvm.png[align="center"]

Run `spark-shell` as follows to enable remote JVM for debugging.

[source]
----
$ export SPARK_SUBMIT_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
$ spark-shell \
  --packages io.delta:delta-core_2.12:0.7.0 \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.databricks.delta.snapshotPartitions=1
----
