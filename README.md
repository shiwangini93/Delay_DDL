undo_drop is a set of functions whose purpose is to share the DROP schema changes with all stackholders(DBAs/SREs/Devs) before actually committing it to DB. Also, give them authority to kill it proactively in order to avoid unwanted drops.

Getting Started :

The script uses event trigger to delay(idle 10 minutes) execution of drop statements of schema changes. You need to add both scripts under `function` to your database.
`undo` has a sample shell script file(monitor.sh) which can be used as a cron(every minute) or any other monitoring to your database. You can specify your email address instead of my_email@gmal.com in this script. ddl_killer.sql has a proc to perform ddl kill. You can compile it in your db.

How it works :

Considering you compiled all *.sql scripts and scheduled monitor.sh as a cron(in this case) for every minute with your email address. Once you schedule, it will keep start monitoring any running drop statements in your database. Once it finds one, timer starts for 10 minutes. You will receive an email with the information about the drop query which is going to execute in next 10 minutes, user(running the query),pid,ip and other important details. You see the query and all looks as expected....cool. You can simply ignore it and continue with your work.

Another case, you see the query and found it's wrongly typed/mistake drop statement and it should stop immediatly. Well ..fortunately, now you have time to run to database and stop it . It's quite clear that in such a moment of hurry nobody has time to check pid of dropping query and kill it manually. Now, you can call `call avoid_ddl () ;`. The proc will itself take care of finding pid of dropping statement and kill that to avoid any possible damage. 

Note: In case of more than one drop query execution in parallel, `avoid_ddl()` will only kill the one which started first. You need to kill seconds/another one separatly or call `avoid_ddl()` once again to kill the second one.
