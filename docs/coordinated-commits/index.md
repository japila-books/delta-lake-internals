---
title: Coordinated Commits
---

# Delta Coordinated Commits

**Coordinated Commits** feature introduces a concept of coordinated-commits delta tables.

Coordinated-commits delta tables are managed by a commit coordinator which arbitrates the commits to the tables.

Coordinated commits are enabled for delta tables with [CoordinatedCommitsTableFeature](CoordinatedCommitsTableFeature.md) table feature.

The commit coordinator of a coordinated-commits delta table is configured using [delta.coordinatedCommits.commitCoordinator-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_NAME) table property that [can be looked up in the Metadata of a delta table](../Metadata.md#coordinatedCommitsCoordinatorName).

!!! note "Became Catalog-Managed Tables"
    Coordinated Commits started as part of [[Protocol Change Request] Delta Coordinated Commits]({{ delta.issues }}/2598).
    Eventually, the RFC was rejected in favor of [Catalog-Managed Tables](../catalog-managed-tables/index.md) feature.
