-- ddl killer

CREATE OR REPLACE PROCEDURE public.avoid_ddl()
 LANGUAGE plpgsql
AS $procedure$
declare

kill_pid bigint;
begin
	
	kill_pid := (select pid  from pg_stat_activity where  query != '<IDLE>' and query NOT ILIKE ('%pg_stat_activity%') and query not ilike ('%pg_catalog%') and query like '%drop%');
	while(kill_pid is not null )
	loop 
			
	perform pg_terminate_backend(pid) 
    from pg_stat_activity
    where pid = kill_pid;

    kill_pid := (select pid  from pg_stat_activity where  query != '<IDLE>' and query NOT ILIKE ('%pg_stat_activity%') and query not ilike ('%pg_catalog%') and query like '%drop%');
		
	end loop ;
	
end ; $procedure$
;