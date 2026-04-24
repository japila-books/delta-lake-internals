---
title: Version Checksums
---

# Version Checksum Files

**Version Checksum Files** are auxiliary files that delta writers can optionally emit with every commit, which contain important information about the state of the table as of that version.

Version Checksums can be used to validate the integrity of a delta table.

[RecordChecksum](RecordChecksum.md) abstraction is used to [writeChecksumFile](RecordChecksum.md#writeChecksumFile).

!!! note "Delta Transaction Log Protocol Specification"
    Version Checksums feature is described in [Version Checksum File]({{ delta.github }}/PROTOCOL.md#version-checksum-file) in [Delta Transaction Log Protocol]({{ delta.github }}/PROTOCOL.md) specification.
