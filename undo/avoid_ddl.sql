CREATE OR REPLACE PROCEDURE public.avoid_ddl()
LANGUAGE plpgsql
AS $procedure$
DECLARE
    kill_pid bigint;
    query_run varchar;
    query_next varchar;
BEGIN
    SELECT pid, query INTO kill_pid, query_run
    FROM pg_stat_activity
    WHERE query NOT ILIKE ('%pg_stat_activity%')
        AND query NOT ILIKE ('%pg_catalog%')
        AND query LIKE '%drop%'
    LIMIT 1;
    
    query_next := (SELECT query FROM pg_stat_activity WHERE pid = kill_pid);
    
    WHILE (kill_pid IS NOT NULL AND query_run = query_next)
    LOOP
        PERFORM pg_terminate_backend(pid)
        FROM pg_stat_activity
        WHERE pid IN (
            SELECT pid
            FROM pg_catalog.pg_stat_activity
            WHERE query = query_next
        );

        SELECT pid, query INTO kill_pid, query_next
        FROM pg_stat_activity
        WHERE query NOT ILIKE ('%pg_stat_activity%')
            AND query NOT ILIKE ('%pg_catalog%')
            AND query LIKE '%drop%'
        LIMIT 1;
    END LOOP;
END;
$procedure$
;

