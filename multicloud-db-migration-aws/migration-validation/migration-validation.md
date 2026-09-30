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

Supply prompted credentials and record the new migration ID:

```bash
read -rp "Migration job ID: " MIGRATION_JOB_ID
"$ZDMCLI" query job -jobid "$MIGRATION_JOB_ID"
```

## Task 2: Monitor Initial Load and Replication

Repeat the query periodically, not the migration submission. Expect these milestones in order:

1. Source, target, GoldenGate hub, and Data Pump validation.
2. GoldenGate source preparation and Extract creation.
3. Data Pump export to EFS, shared-storage transfer phase, and target import.
4. Replicat creation/start and lag monitoring.
5. Job `PAUSED` after `ZDM_MONITOR_GG_LAG` completes.

The paused state is intentional. Extract and Replicat should be running at this checkpoint. Check their reported state and heartbeat lag. Zero throughput can mean an idle source; it does not by itself indicate failure.

Use the result-log path printed by the job query:

```bash
read -rp "Exact result log path from query output: " JOB_LOG
tail -80 "$JOB_LOG"
find "$EFS_MOUNT_POINT" -maxdepth 1 -type f -name "ZDM_${MIGRATION_JOB_ID}_*" -ls
```

If import remains STARTED, inspect the current log and Data Pump evidence before concluding it is stuck. Persistent dump-file I/O waits together with a stalled target NFS probe warrant instructor investigation; they are not proof of a ZDM product bug. Do not detach EFS, delete dumps/trails, kill sessions, or recreate GoldenGate.

For a FAILED job, have the instructor correct the recorded cause before resuming that job. Do not restart the entire migration.

## Task 3: Demonstrate INSERT, UPDATE, and DELETE Replication

Only do this while paused after lag monitoring, before cutover. Use an otherwise idle lab source. Never write directly to the target during this demonstration.

Open a source SQL*Plus session as FINANCE:

```bash
sqlplus -L finance@"$SOURCE_ALIAS"
```

Check `DESC accounts` first. The supplied schema has ACCOUNT_ID, ACCOUNT_NUMBER, ACCOUNT_TYPE, BALANCE, OPENED_DATE, and STATUS. Stop if yours differs. Use the same test ID in both sessions. The block refuses to overwrite an existing row.

```sql
SET SERVEROUTPUT ON
DEFINE demo_id = 900000001
SELECT COUNT(*) AS baseline_count FROM accounts;
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM accounts WHERE account_id=&demo_id;
  IF n <> 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Test ID already exists; choose another unused ID');
  END IF;
  INSERT INTO accounts
    (account_id, account_number, account_type, balance, opened_date, status)
  VALUES
    (&demo_id, 'ACC-ZDM-DEMO', 'SAVINGS', 100, TRUNC(SYSDATE), 'ACTIVE');
  COMMIT;
END;
/
SELECT account_id, balance, status FROM accounts WHERE account_id=&demo_id;
SELECT COUNT(*) AS after_insert FROM accounts;
```

In a **second shell**, load the target environment and connect; enter the password at the prompt:

```bash
source "$HOME/env/adbs.env"
sqlplus -L finance@"$TARGET_ALIAS"
```

At the target SQL prompt, define the same ID and repeat these queries until the row arrives:

```sql
DEFINE demo_id = 900000001
SELECT account_id, balance, status FROM accounts WHERE account_id=&demo_id;
SELECT COUNT(*) AS target_count FROM accounts;
```

Expected: balance 100 and baseline + 1 rows, assuming no other writes. GoldenGate is asynchronous; do not expect an instantaneous result.

Back in the **source SQL session**, update only the demonstration row:

```sql
UPDATE accounts SET balance=125
WHERE account_id=&demo_id AND account_number='ACC-ZDM-DEMO';
COMMIT;
```

Expect one row updated. On target, repeat the row query until balance is 125. Then delete only that test row on the source:

```sql
DELETE FROM accounts
WHERE account_id=&demo_id AND account_number='ACC-ZDM-DEMO';
COMMIT;
SELECT COUNT(*) AS restored_count FROM accounts;
```

Expect one row deleted. On target, verify the row disappears and the count returns to baseline. Keep evidence of all three stages. Counts alone do not establish full data equality.

## Task 4: Controlled Cutover

Obtain instructor approval. Stop all source application writes and finish or roll back outstanding transactions. Do not stop the database/listener or GoldenGate manually. In this table-only lab, stop the DML demonstration and any workload generator.

From the `oracle` shell, drain replication with a second pause:

```bash
"$ZDMCLI" resume job -jobid "$MIGRATION_JOB_ID" \
  -pauseafter ZDM_PREPARE_SWITCHOVER_APP
"$ZDMCLI" query job -jobid "$MIGRATION_JOB_ID"
```

Wait for PAUSED at the requested phase. Then advance to the switchover checkpoint:

```bash
"$ZDMCLI" resume job -jobid "$MIGRATION_JOB_ID" \
  -pauseafter ZDM_SWITCHOVER_APP
"$ZDMCLI" query job -jobid "$MIGRATION_JOB_ID"
```

Wait for that pause and compare source/target results while source writes remain stopped:

```sql
SELECT COUNT(*) AS row_count, SUM(balance) AS total_balance,
       MIN(account_id) AS min_id, MAX(account_id) AS max_id
FROM accounts;
```

Also check the demonstration row is absent and have the instructor confirm object validity and any application sequence requirements. Aggregate agreement is a lab check, not a substitute for a full production reconciliation.

Continue to the post-switchover checkpoint:

```bash
"$ZDMCLI" resume job -jobid "$MIGRATION_JOB_ID" \
  -pauseafter ZDM_POST_SWITCHOVER_TGT
"$ZDMCLI" query job -jobid "$MIGRATION_JOB_ID"
```

After this checkpoint succeeds, the instructor may redirect and enable the application on the target. ZDM does not invent or change your application's connection configuration. Keep source writes disabled; cleanup is not a rollback mechanism.

Finally allow remaining cleanup:

```bash
"$ZDMCLI" resume job -jobid "$MIGRATION_JOB_ID"
"$ZDMCLI" query job -jobid "$MIGRATION_JOB_ID"
```

Wait for SUCCEEDED. Do not assume completion from one successful phase. The pause sequence follows the [ZDM 26.1 application switchover procedure](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/migrating-with-zero-downtime-migration.html); consult the guide for excluded objects or application-specific requirements.

## Task 5: Retain Evidence

Record Lab ID, evaluation/migration job IDs, start/end times, phase statuses, sanitized response file, CPAT/excluded-object reports, Data Pump logs, replication metrics, and source/target validation results. Obtain paths from your job rather than copying prototype paths.

Do not upload passwords, private SSH keys, wallet contents, or unsanitized environment files. Participants do not delete shared infrastructure or rerun fleet provisioning.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 28, 2026
