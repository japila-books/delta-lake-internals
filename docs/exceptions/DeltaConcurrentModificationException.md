# DeltaConcurrentModificationException

`DeltaConcurrentModificationException` is an extension of the `ConcurrentModificationException` ([Java]({{ java.api }}/java.base/java/util/ConcurrentModificationException.html)) abstraction for [commit conflict exceptions](#implementations).

!!! note
    There are two `DeltaConcurrentModificationException` abstractions in two different packages:

    * `io.delta.exceptions`
    * `org.apache.spark.sql.delta` (obsolete since 1.0.0)

## Implementations

* [ConcurrentAppendException](ConcurrentAppendException.md)
* [ConcurrentDeleteDeleteException](ConcurrentDeleteDeleteException.md)
* [ConcurrentDeleteReadException](ConcurrentDeleteReadException.md)
* [ConcurrentTransactionException](ConcurrentTransactionException.md)
* [ConcurrentWriteException](ConcurrentWriteException.md)
* [MetadataChangedException](MetadataChangedException.md)
* [ProtocolChangedException](ProtocolChangedException.md)

## Creating Instance

`DeltaConcurrentModificationException` takes the following to be created:

* <span id="message"> Error Message

??? note "Abstract Class"
    `DeltaConcurrentModificationException` is an abstract class and cannot be created directly. It is created indirectly for the [concrete DeltaConcurrentModificationExceptions](#implementations).
