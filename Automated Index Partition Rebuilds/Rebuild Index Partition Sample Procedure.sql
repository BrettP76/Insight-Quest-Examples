CREATE PROCEDURE BI.spREBUILD_INDEX_PARTITION_TRANSACTIONLOG
AS
BEGIN

DECLARE @Partition1 as int, @Partition2 as int, @SQLString1 as NVARCHAR(MAX), @SQLString2 as nvarchar(max)

SET @Partition1 = 

(SELECT
	max(rg.Partition_Number)
FROM sys.pdw_nodes_column_store_row_groups rg
INNER JOIN sys.pdw_nodes_tables pt
ON rg.object_id = pt.object_id AND rg.pdw_node_id = pt.pdw_node_id AND pt.distribution_id = rg.distribution_id
INNER JOIN sys.pdw_table_mappings tm
ON pt.name = tm.physical_name
INNER JOIN sys.tables t
ON tm.object_id = t.object_id
INNER JOIN sys.schemas s
ON t.schema_id = s.schema_id
WHERE 
t.name IN('TRANSACTION_LOG') AND s.name = 'BI')

SET @Partition2 = @Partition1 -1

SET @SQLString1 = N'ALTER INDEX ALL ON [BI].[TRANSACTION_LOG] REBUILD PARTITION = ' + CAST(@Partition1 as nvarchar(3)) + ' WITH (DATA_COMPRESSION = COLUMNSTORE)';

SET @SQLString2 = N'ALTER INDEX ALL ON [BI].[TRANSACTION_LOG] REBUILD PARTITION = ' + CAST(@Partition2 as nvarchar(3)) + ' WITH (DATA_COMPRESSION = COLUMNSTORE)';

EXECUTE sp_executesql @SQLString1;

EXECUTE sp_executesql @SQLString2;

END