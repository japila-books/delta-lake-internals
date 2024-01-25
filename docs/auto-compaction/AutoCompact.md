# AutoCompact

`AutoCompact` is a [AutoCompactBase](AutoCompactBase.md).

??? note "case object"
    `AutoCompact` is a `case object` in Scala which means it is a class that has exactly one instance (itself).
    A `case object` is created lazily when it is referenced, like a `lazy val`.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

`AutoCompact` is [registered](../OptimisticTransactionImpl.md#registerPostCommitHook) when `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles) and there are indeed new files added and it is not [Optimize](../commands/optimize/index.md) command.
