# drop monitor

#!/bin/sh

val=$(psql -t -U channa -d alert_on_drop -c "SELECT count(1)
FROM pg_stat_activity
where  query != '<IDLE>' AND
 query NOT ILIKE ('%pg_stat_activity%') and query not ilike ('%pg_catalog%') and query like '%drop%'
; " );


if [ $val -gt 0 ]; then

psql  -U channa -d alert_on_drop -c "SELECT pid, age(clock_timestamp(), query_start), usename, query ,client_hostname
FROM pg_stat_activity
where  query != '<IDLE>' AND
 query NOT ILIKE ('%pg_stat_activity%') and query not ilike ('%pg_catalog%') and query like '%drop%'
ORDER BY query_start desc; " >drop.txt

mail -s "drop_run" -a drop.txt my_email@gmail.com


fi