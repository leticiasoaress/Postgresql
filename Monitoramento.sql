--- Verificar ultimo analyze e vacuum
SELECT *
FROM pg_stat_all_tables 
WHERE relname = ''

--- Verificar query de acordo com PID
SELECT pid, 
       usename, 
       pg_blocking_pids(pid) AS blocked_by, 
       query AS blocked_query
FROM pg_stat_activity
WHERE pid IN (75852)

--- Analyze na tabela
ANALYZE schema.table

--- Validar tamanho tabela
SELECT 
   schemaname AS table_schema,
   relname AS table_name,
   pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
   pg_size_pretty(pg_relation_size(relid)) AS data_size,
   pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS external_size
FROM pg_catalog.pg_statio_user_tables
WHERE relname = ''

--- Validar queries em execução
SELECT
    pid,
    datname,
    usename,
    application_name,
    pg_catalog.to_char(backend_start, 'YYYY-MM-DD HH24:MI:SS TZ') AS backend_start,
    state,
	pg_catalog.to_char(state_change, 'YYYY-MM-DD HH24:MI:SS TZ') AS state_change,
    pg_catalog.pg_blocking_pids(pid) AS blocking_pids,
    query
FROM pg_catalog.pg_stat_activity
WHERE datname = (SELECT datname FROM pg_catalog.pg_database WHERE oid = 0)ORDER BY pid

---- Obter oid
SELECT datname, oid FROM pg_catalog.pg_database