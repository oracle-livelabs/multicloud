# Lab 3: Review and Evaluate the Online ZDM Migration

## Introduction

Use the fleet-generated response file; do not rebuild it from the earlier offline example. Evaluation checks readiness but does not perform the full export/import or prove end-to-end replication.

Estimated Time: 20 minutes

### Objectives

Verify the migration scope, distinguish SQL and ZDM authentication, and complete evaluation.

## Task 1: Review the Working Configuration

Run as `oracle` at the EC2 shell:

```bash
source "$HOME/env/source19c.env"
source /etc/profile.d/zdm26.sh
source /data/oracle/lab/config/lab-env.sh
export ZDMCLI="$ZDM_HOME/bin/zdmcli"
export ZDM_SOURCE_SSH_KEY="$HOME/.ssh/zdm_source_ed25519"
/data/oracle/lab/bin/validate-zdm-response.sh
grep -E '^(MIGRATION_METHOD|DATA_TRANSFER_MEDIUM|INCLUDEOBJECTS-1|GOLDENGATEHUB_(SOURCE|TARGET)DEPLOYMENTNAME|TARGETDATABASE_CONNECTIONDETAILS_SERVICENAME)=' "$ZDM_RESPONSE_FILE"
```

Required settings include:

- `MIGRATION_METHOD=ONLINE_LOGICAL` and `DATA_TRANSFER_MEDIUM=NFS`.
- Only `FINANCE.ACCOUNTS` included in TABLE mode.
- Source `SYSTEM` and `GGADMIN`; target `ADMIN` and `GGADMIN`; hub `oggadmin`.
- Case-sensitive `Local` for both deployment names.
- Source host reachable from the GoldenGate container, not container-local `127.0.0.1`.
- Target ZDM wallet alias on port 1522, not the fully qualified service string substituted into the alias field.
- Source `DATA_PUMP_DIR_NFS`, target `ZDM_EFS_DIR`, assigned EFS hostname, and retained shared storage.
- Approved lag, DDL, performance, and dump-retention settings unchanged.

The validator compares the generated file with the approved template after assignment substitutions. Do not add tablespace remapping, change usernames, or loosen TLS settings to bypass a failure.

## Task 2: Confirm Target Preparation

The instructor must provision the target FINANCE owner and required quota/privileges and prepare GoldenGate accounts on both databases. The target ACCOUNTS table should not already exist for a fresh migration. A reused target must be reviewed by the instructor; participants must not drop an existing table to force a rerun.

The target TLS wallet is already installed for ZDM. Do not create source/target credential wallets from the obsolete offline guide. ZDM prompts for credentials at runtime; SQL*Plus uses the password-authenticated alias from `adbs.env`.

## Task 3: Run Evaluation

```bash
"$ZDMCLI" migrate database \
  -sourcesid "$ORACLE_SID" \
  -sourcenode "$(hostname -f)" \
  -srcauth zdmauth \
  -srcarg1 user:ec2-user \
  -srcarg2 "identity_file:$ZDM_SOURCE_SSH_KEY" \
  -srcarg3 sudo_location:/usr/bin/sudo \
  -rsp "$ZDM_RESPONSE_FILE" \
  -eval
```

Enter the prompted passwords for source SYSTEM, source GGADMIN, target ADMIN, target GGADMIN, and hub oggadmin. Do not put them on command lines, in screenshots, or in the response file.

Record the returned evaluation ID, then query it:

```bash
read -rp "Evaluation job ID: " EVAL_JOB_ID
"$ZDMCLI" query job -jobid "$EVAL_JOB_ID"
```

Proceed only when this job reports `SUCCEEDED`. Review CPAT findings and the excluded-objects file: ACCOUNTS must not be excluded from the required migration/replication scope. Save the actual result-log path from the output.

For failures, report the first failed phase and the corresponding log error. Do not skip validation or submit repeated migration jobs.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 28, 2026
