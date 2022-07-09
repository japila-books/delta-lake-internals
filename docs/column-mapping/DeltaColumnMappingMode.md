# DeltaColumnMappingMode

`DeltaColumnMappingMode` is an [abstraction](#contract) of the [column mapping modes](#implementations) in [Column Mapping](index.md).

## Contract

### <span id="name"> Name

```scala
name: String
```

Human-friendly name of this `DeltaColumnMappingMode` (for error reporting)

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

This mode [requires a new protocol](DeltaColumnMappingBase.md#requiresNewProtocol)

### <span id="NameMapping"> NameMapping

[Name](#name): `name`

`NameMapping` is the only [allowed mapping mode change](DeltaColumnMappingBase.md#allowMappingModeChange) (from [NoMapping](#NoMapping))

This mode [requires a new protocol](DeltaColumnMappingBase.md#requiresNewProtocol)

`NameMapping` is among the [supportedModes](DeltaColumnMappingBase.md#supportedModes)

`NameMapping` is used when:

* `DeltaColumnMappingBase` is requested for the [column mapping metadata](DeltaColumnMappingBase.md#getColumnMappingMetadata), [tryFixMetadata](DeltaColumnMappingBase.md#tryFixMetadata), [getPhysicalNameFieldMap](DeltaColumnMappingBase.md#getPhysicalNameFieldMap)

### <span id="NoMapping"> NoMapping

No column mapping and the display name of a column is the only valid identifier to read and write data.

[Name](#name): `none`

This mode does not [require a new protocol](DeltaColumnMappingBase.md#requiresNewProtocol)

`NoMapping` is among the [supportedModes](DeltaColumnMappingBase.md#supportedModes)

## <span id="apply"> Creating DeltaColumnMappingMode

```scala
apply(
  name: String): DeltaColumnMappingMode
```

`apply` returns the [DeltaColumnMappingMode](#implementations) for the given `name` (if defined) or [throws a ColumnMappingUnsupportedException](../DeltaErrors.md#unsupportedColumnMappingMode):

```text
The column mapping mode `[mode]` is not supported for this Delta version.
Please upgrade if you want to use this mode.
```

`apply` is used when:

* `DeltaConfigsBase` is requested to build [delta.columnMapping.mode](../DeltaConfigs.md#COLUMN_MAPPING_MODE) configuration property
