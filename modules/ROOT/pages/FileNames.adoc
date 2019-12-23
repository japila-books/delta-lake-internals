= FileNames Utility

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| checkpointPrefix
a| [[checkpointPrefix]] Creates a Hadoop `Path` for a file name with a given `version`:

```
[version][%020d].checkpoint
```

E.g. `00000000000000000005.checkpoint`

| isCheckpointFile
a| [[isCheckpointFile]]

| isDeltaFile
a| [[isDeltaFile]]

|===

== [[deltaFile]] Creating Hadoop Path To Delta File -- `deltaFile` Utility

[source, scala]
----
deltaFile(
  path: Path,
  version: Long): Path
----

`deltaFile` creates a Hadoop `Path` to a file of the format `[version][%020d].json` in the `path` directory, e.g. `00000000000000000001.json`.

NOTE: `deltaFile` is used when...FIXME
