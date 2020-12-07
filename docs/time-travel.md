# Time Travel

Delta Lake supports **time travelling** which is loading a Delta table at a given version or timestamp (defined by [path](DeltaOptions.md#path), [versionAsOf](DeltaOptions.md#versionAsOf) or [timestampAsOf](DeltaOptions.md#timestampAsOf) options).

Time travel is described using [DeltaTimeTravelSpec](DeltaTimeTravelSpec.md).
