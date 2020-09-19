= DeltaErrors Utility

`DeltaErrors` utility is...FIXME

== [[postCommitHookFailedException]] Reporting Post-Commit Hook Failure (RuntimeException) -- `postCommitHookFailedException` Method

[source, scala]
----
postCommitHookFailedException(
  failedHook: PostCommitHook,
  failedOnCommitVersion: Long,
  extraErrorMessage: String,
  error: Throwable): Throwable
----

`postCommitHookFailedException`...FIXME

NOTE: `postCommitHookFailedException` is used when...FIXME
