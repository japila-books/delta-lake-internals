---
title: Commits
subtitle: v4.1.0 → v4.2.0
---

# Managed Table-Related Commits

[v4.1.0 → v4.2.0](https://github.com/delta-io/delta/compare/v4.1.0...v4.2.0)

## Core Managed Table Features

- ~~[`bd1e4a2dc`](https://github.com/delta-io/delta/commit/bd1e4a2dc) [Spark] Block maintenance operations on catalog managed tables (#6087)~~
- [`f328807d3`](https://github.com/delta-io/delta/commit/f328807d3) [Spark] Block metadata changes on UC-managed tables (#6243)
- [`7a426aea1`](https://github.com/delta-io/delta/commit/7a426aea1) [Spark] Send table schema to UC server when creating managed tables (#6204)
- [`7a6ccca82`](https://github.com/delta-io/delta/commit/7a6ccca82) [Kernel] Finalize UC table creation inside Kernel commit path (#6448)
- [`441d74845`](https://github.com/delta-io/delta/commit/441d74845) [Kernel] Add vacuumProtocolCheck to UC-managed table creation (#6127)
- [`fa642d656`](https://github.com/delta-io/delta/commit/fa642d656) [Flink] Support Catalog-Managed Table with UC (#6188)

## UC Commit Metrics

- [`0f1a087ac`](https://github.com/delta-io/delta/commit/0f1a087ac) [UC Commit Metrics] Add skeleton transport wiring and smoke tests (#6155)
- [`9f7986737`](https://github.com/delta-io/delta/commit/9f7986737) [UC Commit Metrics] Add full payload construction and schema tests (#6156)
- [`caffa7b9a`](https://github.com/delta-io/delta/commit/caffa7b9a) [UC Commit Metrics] Add feature flag and async dispatch (#6333)
- [`c298da24f`](https://github.com/delta-io/delta/commit/c298da24f) [UC Commit Metrics] Use full-table histogram from snapshot (#6518)

## Other UC-related

- [`9db8e1fa3`](https://github.com/delta-io/delta/commit/9db8e1fa3) [Spark] Upgrade OSS Unity Catalog dependency 0.4.0 → 0.4.1 (#6510)
- [`abb450a13`](https://github.com/delta-io/delta/commit/abb450a13) [Spark] `translatesDeprecatedUcTableIdOnManagedCreate` for CTAS test (#6511)
- [`45e53892e`](https://github.com/delta-io/delta/commit/45e53892e) [UniForm] Commit with UniForm metadata atomically for UCCommitCoordinatorClient (#6486)
- [`33848ca8e`](https://github.com/delta-io/delta/commit/33848ca8e) Track kernel usage in UC client telemetry (#6163)
- [`537a56a02`](https://github.com/delta-io/delta/commit/537a56a02) Gate UC tests behind UC Spark version checks (#6446)
- [`34bbe6514`](https://github.com/delta-io/delta/commit/34bbe6514) [UniForm] Deprecate Delta UniForm for HMS managed tables (#6187)
- [`18019e54d`](https://github.com/delta-io/delta/commit/18019e54d) [CI] Fix flaky DeltaRetentionWithCatalogOwnedBatch1Suite test (#6348)
- [`5a153a69c`](https://github.com/delta-io/delta/commit/5a153a69c) [DSv1] Pass streaming DataSource options into DeltaLog snapshot for UC external tables (#5981)
- [`dfe59f691`](https://github.com/delta-io/delta/commit/dfe59f691) Fix typo in catalog managed tests (#6207)
