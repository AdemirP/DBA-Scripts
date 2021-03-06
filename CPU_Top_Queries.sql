--Utilizando as DMVs e DMFs da categoria sys.dm_exec, podemos listar informa??es
--detalhadas sobre as conex?es existentes em uma inst?ncia de SQL Server, inclusive
--quais as queries que cada Login est? executando no momento
SELECT
	ES.session_id,
	ES.cpu_time,
	ES.total_scheduled_time,
	ES.total_elapsed_time,
	ES.last_request_start_time,
	ES.last_request_end_time,
	ES.[host_name],
	ES.[program_name],
	ES.client_interface_name,
	ES.login_name,
	EC.net_transport,
	ES.nt_domain,
	ES.nt_user_name,
	EC.client_net_address,
	EC.local_net_address,
	(SELECT [Text] FROM master.sys.dm_exec_sql_text(EC.most_recent_sql_handle )) as sqlscript,
	UPPER(ES.[Status]) AS [Status],
	(SELECT DB_NAME([dbid]) FROM master.sys.dm_exec_sql_text(EC.most_recent_sql_handle )) as databasename,
	(SELECT OBJECT_ID([objectid]) FROM master.sys.dm_exec_sql_text(EC.most_recent_sql_handle )) as objectname
FROM
	sys.dm_exec_sessions ES
INNER JOIN 
	sys.dm_exec_connections EC
ON 
	EC.session_id = ES.session_id
--WHERE
--	UPPER(ES.[Status]) = 'RUNNING'
ORDER BY
	ES.cpu_time DESC