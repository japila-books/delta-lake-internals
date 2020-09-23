# DeltaSqlAstBuilder

`DeltaSqlAstBuilder` is a command builder for the Delta SQL statements (described in [DeltaSqlBase.g4](https://github.com/delta-io/delta/blob/v0.7.0/src/main/antlr4/io/delta/sql/parser/DeltaSqlBase.g4) ANTLR grammar).

`DeltaSqlParser` is used by [DeltaSqlParser](DeltaSqlParser.md#builder).

SQL Statement | Logical Command
-------------|----------
 [CONVERT TO DELTA](index.md#CONVERT-TO-DELTA) | [ConvertToDeltaCommand](../ConvertToDeltaCommand.md)
 [DESCRIBE DETAIL](index.md#DESCRIBE-DETAIL) | [DescribeDeltaDetailCommand](../DescribeDeltaDetailCommand.md)
 [DESCRIBE HISTORY](index.md#DESCRIBE-HISTORY) | [DescribeDeltaHistoryCommand](../DescribeDeltaHistoryCommand.md)
 [GENERATE](index.md#GENERATE) | [DeltaGenerateCommand](../DeltaGenerateCommand.md)
 [VACUUM](index.md#VACUUM) | [VacuumTableCommand](../VacuumTableCommand.md)
