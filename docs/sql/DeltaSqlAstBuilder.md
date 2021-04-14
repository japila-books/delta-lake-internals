# DeltaSqlAstBuilder

`DeltaSqlAstBuilder` is a command builder for the Delta SQL statements (described in [DeltaSqlBase.g4]({{ delta.github }}/src/main/antlr4/io/delta/sql/parser/DeltaSqlBase.g4) ANTLR grammar).

`DeltaSqlParser` is used by [DeltaSqlParser](DeltaSqlParser.md#builder).

SQL Statement | Logical Command
-------------|----------
 [ALTER TABLE ADD CONSTRAINT](index.md#ALTER-TABLE-ADD-CONSTRAINT) | [AlterTableAddConstraintStatement](../AlterTableAddConstraintStatement.md)
 [ALTER TABLE DROP CONSTRAINT](index.md#ALTER-TABLE-DROP-CONSTRAINT) | [AlterTableDropConstraintStatement](../AlterTableDropConstraintStatement.md)
 [CONVERT TO DELTA](index.md#CONVERT-TO-DELTA) | [ConvertToDeltaCommand](../commands/ConvertToDeltaCommand.md)
 [DESCRIBE DETAIL](index.md#DESCRIBE-DETAIL) | [DescribeDeltaDetailCommand](../commands/DescribeDeltaDetailCommand.md)
 [DESCRIBE HISTORY](index.md#DESCRIBE-HISTORY) | [DescribeDeltaHistoryCommand](../commands/DescribeDeltaHistoryCommand.md)
 [GENERATE](index.md#GENERATE) | [DeltaGenerateCommand](../commands/DeltaGenerateCommand.md)
 [VACUUM](index.md#VACUUM) | [VacuumTableCommand](../commands/vacuum/VacuumTableCommand.md)
