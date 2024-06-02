# DomainMetadataUtils

## domainMetadataSupported { #domainMetadataSupported }

```scala
domainMetadataSupported(
  protocol: Protocol): Boolean
```

`domainMetadataSupported` holds true for a delta table (by the given [Protocol](Protocol.md)) with [support](table-features/TableFeatureSupport.md#isFeatureSupported) for [DomainMetadataTableFeature](table-features/DomainMetadataTableFeature.md) table feature.

---

`domainMetadataSupported` is used when:

* `ConflictChecker` is requested to [checkIfDomainMetadataConflict](ConflictChecker.md#checkIfDomainMetadataConflict)
* `DomainMetadataUtils` is requested to [validateDomainMetadataSupportedAndNoDuplicate](#validateDomainMetadataSupportedAndNoDuplicate)

## validateDomainMetadataSupportedAndNoDuplicate { #validateDomainMetadataSupportedAndNoDuplicate }

```scala
validateDomainMetadataSupportedAndNoDuplicate(
  actions: Seq[Action],
  protocol: Protocol): Seq[DomainMetadata]
```

`validateDomainMetadataSupportedAndNoDuplicate`...FIXME

---

`validateDomainMetadataSupportedAndNoDuplicate` is used when:

* `OptimisticTransactionImpl` is requested to [commitImpl](OptimisticTransactionImpl.md#commitImpl)
