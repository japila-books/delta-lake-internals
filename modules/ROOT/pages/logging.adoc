= Logging

Delta Lake uses http://logging.apache.org/log4j[log4j] for logging (as does Apache Spark itself).

== [[levels]] Logging Levels

The valid logging levels are http://logging.apache.org/log4j/2.x/log4j-api/apidocs/index.html[log4j's Levels] (from most specific to least):

* `OFF` (most specific, no logging)
* `FATAL` (most specific, little data)
* `ERROR`
* `WARN`
* `INFO`
* `DEBUG`
* `TRACE` (least specific, a lot of data)
* `ALL` (least specific, all data)

== [[log4j-properties]] conf/log4j.properties

You can set up the default logging for Delta applications in `conf/log4j.properties` of the Spark installation. Use Spark's `conf/log4j.properties.template` as a starting point.

== [[sbt]] sbt

When running a Delta application from within sbt using `run` task, you can use the following `build.sbt` to configure logging levels:

[source, scala]
----
fork in run := true
javaOptions in run ++= Seq(
  "-Dlog4j.debug=true",
  "-Dlog4j.configuration=log4j.properties")
outputStrategy := Some(StdoutOutput)
----

With the above configuration `log4j.properties` file should be on CLASSPATH which can be in `src/main/resources` directory (that is included in CLASSPATH by default).

When `run` starts, you should see the following output in sbt:

```
[spark-activator]> run
[info] Running StreamingApp
log4j: Trying to find [log4j.properties] using context classloader sun.misc.Launcher$AppClassLoader@1b6d3586.
log4j: Using URL [file:.../classes/log4j.properties] for automatic log4j configuration.
log4j: Reading configuration from URL file:.../classes/log4j.properties
```
