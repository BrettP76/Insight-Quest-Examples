SELECT
  pc1.pdw_node_id as [Node ID]
--  pc1.cntr_value as Curr_Mem_KB,
--  pc1.cntr_value/1024.0 as Curr_Mem_MB,
,  (pc1.cntr_value/1048576.0) as Curr_Mem_GB
--  pc2.cntr_value as Max_Mem_KB,
--  pc2.cntr_value/1024.0 as Max_Mem_MB,
,  (pc2.cntr_value/1048576.0) as Max_Mem_GB
,  (pc1.cntr_value * 100.0)/pc2.cntr_value AS [Memory_Utilization_Percent]
,  CAST(DATEADD(HOUR,-4,CURRENT_TIMESTAMP) AS date) AS [MemoryDate]
FROM
-- pc1: current memory
sys.dm_pdw_nodes_os_performance_counters AS pc1
-- pc2: total memory allowed for this SQL instance
INNER JOIN sys.dm_pdw_nodes_os_performance_counters AS pc2
	ON pc1.object_name = pc2.object_name AND pc1.pdw_node_id = pc2.pdw_node_id
INNER JOIN (SELECT DISTINCT PDW_NODE_ID FROM SYS.PDW_DISTRIBUTIONS) AS D
	ON pc1.pdw_node_id = D.pdw_node_id
WHERE
pc1.counter_name = 'Total Server Memory (KB)'
AND pc2.counter_name = 'Target Server Memory (KB)'