DeltaSQLConf -- spark.databricks.delta Configuration Properties
===============================================================

The following table contains ``spark.databricks.delta.``-prefixed configuration properties.

.. tabularcolumns:: |||p{40pt}|
.. csv-table:: spark.databricks.delta Configuration Properties
   :header: "Name", "Default", "Description"

   **timeTravel.resolveOnIdentifier.enabled**, ``true``, **(internal)** When enabled (``true``) considers patterns as ``@v123`` in identifiers as :doc:`time travel </time-travel>` nodes.
