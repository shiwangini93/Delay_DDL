# undo_drop:

**Introduction:**

The **undo_drop**  is a collection of functions designed to facilitate the management of schema changes within your database environment. It serves the critical purpose of sharing proposed DROP schema changes with all stakeholders, including Database Administrators (DBAs), Site Reliability Engineers (SREs), and Developers (Devs), before these changes are officially committed to the database. Furthermore, it empowers them with the authority to proactively prevent and halt any unintended or unwanted DROP actions.

**Getting Started:**

To utilize this , you must follow these steps:

1. **Scripts Inclusion**: Add both the provided scripts to your database environment.
2. **Monitoring Configuration**: In the **undo** script, you will find a sample shell script file named `monitor.sh`. This script can be configured to run as a cron job (every minute) or using any other monitoring tool in your database environment. You are encouraged to replace the placeholder email address (`my_email@gmail.com`) with your own.
3. **Procedure Compilation**: The script `ddl_killer.sql` contains a procedure that is essential for performing the DDL (Data Definition Language) kill operations. This procedure should be compiled within your database.

**How It Operates:**

Upon successful compilation and the configuration of the monitoring script (`monitor.sh`) to run at regular intervals, the **undo_drop** tool functions as follows:

1. **Monitoring Drop Statements**: This will continuously monitors for any DROP statements related to schema changes within your database( I usually schedule for every minute).

2. **Idle Timer**: When a DROP statement is identified, a timer is initiated, allowing a 10-minute idle period before the statement's execution.

3. **Email Notification**: During this idle period, an email notification is dispatched to all stakeholders, providing essential information about the impending DROP query. This email includes details such as the query to be executed, the user initiating the query, process ID (PID), IP address, and other pertinent information.

4. **Decision-Making**: Stakeholders can then review the email and assess whether the DROP query aligns with expectations. If the query appears correct and intentional, stakeholders can simply ignore the notification and proceed with their tasks.

5. **Mitigating Mistakes**: In the event that the DROP query is determined to be erroneous or accidental, stakeholders have the opportunity to intervene promptly. Rather than manually identifying the PID of the query in a hurried scenario, they can invoke the `avoid_ddl()` procedure. This procedure is designed to automatically locate the PID of the DROP statement and terminate it, thereby preventing any potential damage.

**Note:** In cases where multiple DROP queries are executed in parallel, the `avoid_ddl()` procedure will terminate the one that commenced first. For additional DROP queries, each one must be managed separately by invoking the procedure again or terminating them manually.

The **undo_drop** tool serves as a proactive safety net, enabling effective communication and oversight of critical schema changes while allowing for timely intervention in the event of unexpected or undesirable actions. It promotes greater control and security in your database environment.
