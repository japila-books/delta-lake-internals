# DeltaColumnMappingMode

`DeltaColumnMappingMode` is an [abstraction](#contract) of the available [column mapping modes](#implementations) in [Column Mapping](index.md).

## Contract

### <span id="name"> Name

```scala
name: String
```

Human-friendly name of this `DeltaColumnMappingMode` used in error reporting

Used when:

* `DeltaErrors` utility is used to create a [DeltaColumnMappingUnsupportedException](../DeltaErrors.md#convertToDeltaWithColumnMappingNotSupported) and a `ColumnMappingException` (for [missingColumnId](../DeltaErrors.md#missingColumnId), [missingPhysicalName](../DeltaErrors.md#missingPhysicalName), [duplicatedColumnId](../DeltaErrors.md#duplicatedColumnId), [duplicatedPhysicalName](../DeltaErrors.md#duplicatedPhysicalName))
* `DeltaColumnMappingBase` is requested to [verifyAndUpdateMetadataChange](DeltaColumnMappingBase.md#verifyAndUpdateMetadataChange), [getColumnMappingMetadata](DeltaColumnMappingBase.md#getColumnMappingMetadata) and [createPhysicalSchema](DeltaColumnMappingBase.md#createPhysicalSchema)

## Implementations

??? note "Sealed Trait"
    `DeltaColumnMappingMode` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#sealed).

### <span id="IdMapping"> IdMapping

This mode uses the column ID as the identifier of a column.

[Name](#name): `id`

Used for tables converted from Apache Iceberg.

This mode does [require a new protocol](DeltaColumnMappingBase.md#requiresNewProtocol)

### <span id="NameMapping"> NameMapping

[Name](#name): `name`

This mode does [require a new protocol](DeltaColumnMappingBase.md#requiresNewProtocol)

### <span id="NoMapping"> NoMapping

No column mapping and the display name of a column is the only valid identifier to read and write data.

[Name](#name): `none`

This mode does not [require a new protocol](DeltaColumnMappingBase.md#requiresNewProtocol)
