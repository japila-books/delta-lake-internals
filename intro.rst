Introduction
============

`Delta Lake`_ is an open-source storage layer that brings ACID transactions to `Apache Spark`_ and big data workloads.

Delta Lake uses a Hadoop DFS-compliant file system for the underlying storage.

Data Source for Spark SQL and Structured Streaming
--------------------------------------------------

Delta Lake is a data source for Spark SQL and Structured Streaming (see `github <https://github.com/delta-io/delta/blob/v0.4.0/src/main/scala/org/apache/spark/sql/delta/sources/DeltaDataSource.scala#L40-L45>`_).

In that sense, Delta Lake is like ``parquet``, ``kafka`` or any data source that can be used in batch and streaming queries.

As a ``DataSourceRegister``, Delta Lake registers itself as ``delta`` data source.

.. tip::
   Read up on `DataSourceRegister <https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-DataSourceRegister.html>`_ in `The Internals of Spark SQL`_ online book.

.. code-block:: scala
  :linenos:
  :emphasize-lines: 3

  val input = spark
    .read
    .format("delta")
    .load

.. _Delta Lake: https://delta.io/
.. _Apache Spark: https://spark.apache.org/
.. _The Internals of Spark SQL: http://bitly.com/spark-sql-internals
