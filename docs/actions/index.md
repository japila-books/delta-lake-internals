# Actions

**Actions** are the changes to the state of a delta table.

The main abstraction is [Action](Action.md).

Actions can (and in most cases will) increment the version of the delta table.

Actions can be [serialized to JSON format](Action.md#json).
