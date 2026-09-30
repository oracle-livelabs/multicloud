# Lab 4: Execute, Monitor, and Validate the Online Migration

## Introduction

Start the evaluated online migration, pause with replication running, demonstrate source DML on the target, and complete a controlled cutover. Use your own job IDs and log paths. No fixed duration or row count is promised.

Estimated Time: 40 minutes

### Objectives

Run Data Pump and GoldenGate through ZDM, verify committed changes, and retain cutover evidence.

## Task 1: Start with a Replication Pause

Run at the EC2 shell as `oracle`, after successful evaluation and NFS validation:

```bash
source "$HOME/env/source19c.env"
source /etc/profile.d/zdm26.sh
source /data/oracle/lab/config/lab-env.sh
export ZDMCLI="$ZDM_HOME/bin/zdmcli"
export ZDM_SOURCE_SSH_KEY="$HOME/.ssh/zdm_source_ed25519"
```

Submit the migration once:

```bash
"$ZDMCLI" migrate database \
  -sourcesid "$ORACLE_SID" \
  -sourcenode "$(hostname -f)" \
  -srcauth zdmauth \
  -srcarg1 user:ec2-user \
  -srcarg2 "identity_file:$ZDM_SOURCE_SSH_KEY" \
  -srcarg3 sudo_location:/usr/bin/sudo \
  -rsp "$ZDM_RESPONSE_FILE" \
  -pauseafter ZDM_MONITOR_GG_LAG
```

![Migration command requests pause after ZDM_MONITOR_GG_LAG](./images/migration-command.png)

Supply prompted credentials and record the new migration ID:

![Migration password prompts followed by scheduled job ID 2](./images/migration-submitted.png)

Query the returned migration job ID. The commands in this page use **2**, matching the Lab 101 example. If your migration ID differs, replace `2` in every job query, resume command, and job-specific filename below. Do not use the evaluation job ID.

```bash
"$ZDMCLI" query job -jobid 2
```

## Task 2: Monitor Initial Load and Replication

Example submission from Lab 101: `-pauseafter ZDM_MONITOR_GG_LAG` requests a later pause. Receiving job ID `2` confirms scheduling, not completion or arrival at the pause. Use your own returned migration job ID.

Repeat this query periodically from the **`oracle` EC2 shell**, not the migration submission:

```bash
"$ZDMCLI" query job -jobid 2
```

Expect these milestones in order:

1. Source, target, GoldenGate hub, and Data Pump validation.
2. GoldenGate source preparation and Extract creation.
3. Data Pump export to EFS, shared-storage transfer phase, and target import.
4. Replicat creation/start and lag monitoring.
5. Job `PAUSED` after `ZDM_MONITOR_GG_LAG` completes.

The paused state is intentional. Extract and Replicat should be running at this checkpoint. Check their reported state and heartbeat lag. Zero throughput can mean an idle source; it does not by itself indicate failure.

Use the result-log path printed by the job query:

```bash
read -rp "Exact result log path from query output: " JOB_LOG
```

Read the latest log entries:

```bash
tail -80 "$JOB_LOG"
```

List this job’s dump files:

```bash
find "$EFS_MOUNT_POINT" -maxdepth 1 -type f -name "ZDM_2_*" -ls
```

If import remains STARTED, inspect the current log and Data Pump evidence before concluding it is stuck.

For a FAILED job, stop and retain the error and result log. Do not skip a failed phase or restart the entire migration.

## Task 3: Demonstrate INSERT, UPDATE, and DELETE Replication

Run only while the migration is paused after lag monitoring, before cutover. Use the three test rows below. Never run this DML on the target.

Load the source environment in the **oracle EC2 shell**:

```bash
source "$HOME/env/source19c.env"
```

Open the source database:

```bash
sqlplus / as sysdba
```

At **source SQL>**, inspect the table structure:

```sql
DESC finance.accounts
```

Check that the demonstration IDs are unused:

```sql
SELECT account_id, account_number, balance, status
FROM finance.accounts
WHERE account_id IN (99000101,99000102,99000103)
ORDER BY account_id;
```

Continue only if this returns `no rows selected`. If any ID exists, stop.

Insert the three demonstration rows:

```sql
INSERT INTO finance.accounts
  (account_id, account_number, account_type, balance, opened_date, status)
VALUES
  (99000101, 'ZDM-ONLINE-101', 'CHECKING', 1001.01, SYSDATE, 'ACTIVE');

INSERT INTO finance.accounts
  (account_id, account_number, account_type, balance, opened_date, status)
VALUES
  (99000102, 'ZDM-ONLINE-102', 'SAVINGS', 1002.02, SYSDATE, 'ACTIVE');

INSERT INTO finance.accounts
  (account_id, account_number, account_type, balance, opened_date, status)
VALUES
  (99000103, 'ZDM-ONLINE-103', 'CREDIT', 1003.03, SYSDATE, 'ACTIVE');
```

Require three successful inserts. If any statement fails, run `ROLLBACK;` and stop. Update the first row:

```sql
UPDATE finance.accounts
SET balance = 7777.77, status = 'ZDM_UPDATED'
WHERE account_id = 99000101;
```

Expect one row updated. Delete the second demonstration row:

```sql
DELETE FROM finance.accounts WHERE account_id = 99000102;
```

Expect one row deleted. Commit the changes:

```sql
COMMIT;
```

Record the committed source results:

```sql
SELECT account_id, account_number, balance, status
FROM finance.accounts
WHERE account_id IN (99000101,99000102,99000103)
ORDER BY account_id;
```

Expect ID `99000101` with balance `7777.77` and status `ZDM_UPDATED`, and ID `99000103` with balance `1003.03` and status `ACTIVE`. ID `99000102` must be absent.

Return to the **oracle shell**:

```sql
EXIT
```

Load the target environment:

```bash
source "$HOME/env/adbs.env"
```

Connect to the target as ADMIN; enter the password at the prompt:

```bash
sqlplus -L ADMIN@"$TARGET_ALIAS"
```

At **target SQL>**, query the same rows:

```sql
SET LINESIZE 220
SELECT account_id, account_number, balance, status
FROM finance.accounts
WHERE account_id IN (99000101,99000102,99000103)
ORDER BY account_id;
```

Repeat this SELECT until it matches the committed source results. Replication is asynchronous. Do not write to the target or rerun the source inserts. Stop if the results do not converge.

Return to the **oracle shell**:

```sql
EXIT
```

## Task 4: Resume the Same Job for Cutover

Stop all source application writes and finish or roll back outstanding transactions **before** resuming. In this lab, stop the DML test and any workload generator. Do not stop the database, listener, or GoldenGate manually.

Load ZDM in the **oracle shell**:

```bash
source /etc/profile.d/zdm26.sh
export ZDMCLI="$ZDM_HOME/bin/zdmcli"
```

Confirm the same migration job is paused at the expected phase:

```bash
"$ZDMCLI" query job -jobid 2
```

After the replication test passes, resume the job once:

```bash
"$ZDMCLI" resume job -jobid 2
```

Repeat this query until the job reports `SUCCEEDED`:

```bash
"$ZDMCLI" query job -jobid 2
```

Do not run `migrate database` again. A resumed job retains its job ID. If disconnected, reconnect, load the environment from Task 1, enter the existing job ID, and query it. Keep source writes stopped after cutover.

## Task 5: Retain Evidence

After the migration reports `SUCCEEDED`, run the provisioned final target validation script from the **`oracle` EC2 shell**:

```bash
source "$HOME/env/adbs.env"
```

Check that the supplied validation script exists:

```bash
test -r /data/oracle/lab/config/validate-zdm-accounts.sql \
  && echo "PASS: validation script exists" \
  || echo "STOP: validation script is missing"
```

If it exists, run the script and enter the target ADMIN password:

```bash
"$ORACLE_HOME/bin/sqlplus" -L ADMIN@"$TARGET_ALIAS" \
  @/data/oracle/lab/config/validate-zdm-accounts.sql
```

If the file is missing, stop; skipped validation is not a pass. Review the table, row count, allocated space, and any SQL errors. This script reports target data; it does not automatically prove source/target equality. Retain the matching DML results from Task 3 as separate evidence.

Save the final report using the same migration job ID recorded in Task 1:

```bash
source /etc/profile.d/zdm26.sh
export ZDMCLI="$ZDM_HOME/bin/zdmcli"
```

Write the final job report to your home directory:

```bash
"$ZDMCLI" query job -jobid 2 \
  | tee "$HOME/zdm-job-2-final.txt"
```

Record Lab ID, evaluation/migration job IDs, start/end times, phase statuses, sanitized response file, CPAT/excluded-object reports, Data Pump logs, replication metrics, and source/target validation results. Obtain paths from your job rather than copying prototype paths.

Do not upload passwords, private SSH keys, wallet contents, or unsanitized environment files. Participants do not delete shared infrastructure or rerun fleet provisioning.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
