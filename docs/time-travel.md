# Time Travel

Delta Lake supports **time travelling** which is loading a Delta table at a given version or timestamp (defined by [path](options.md#path), [versionAsOf](options.md#versionAsOf) or [timestampAsOf](options.md#timestampAsOf) options).

Time travel is described using [DeltaTimeTravelSpec](DeltaTimeTravelSpec.md).
