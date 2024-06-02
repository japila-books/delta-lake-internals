# DomainMetadata

`DomainMetadata` is an [Action](Action.md) that represents a [named domain](#domain) with some [configuration](#configuration) (a JSON-encoded metadata).

`DomainMetadata` is part of [CurrentTransactionInfo](CurrentTransactionInfo.md#domainMetadata).

## Creating Instance

`DomainMetadata` takes the following to be created:

* <span id="domain"> Domain Name
* <span id="configuration"> Configuration
* <span id="removed"> `removed` flag

`DomainMetadata` is created when:

* `JsonMetadataDomain` is requested to [toDomainMetadata](JsonMetadataDomain.md#toDomainMetadata)

## SingleAction Representation { #wrap }

??? note "Action"

    ```scala
    wrap: SingleAction
    ```

    `wrap` is part of the [Action](Action.md#wrap) abstraction.

`wrap` creates a [SingleAction](SingleAction.md) with the [domainMetadata](SingleAction.md#domainmetadata) being this `DomainMetadata`.
