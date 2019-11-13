Time Travel
===========

:doc:`path </options>` option may optionally specify **time travel**.

The format is defined per the following regular expressions:

* ``.*@(\\d{17})$$`` (`TIMESTAMP_URI_FOR_TIME_TRAVEL`), e.g. ``@(yyyyMMddHHmmssSSS)``

* ``.*@[vV](\d+)$`` (`VERSION_URI_FOR_TIME_TRAVEL`), e.g. ``@v123``

``DeltaTimeTravelSpec`` describes a time travel node:

* ``timestamp`` or ``version``

* Optional ``creationSource``
