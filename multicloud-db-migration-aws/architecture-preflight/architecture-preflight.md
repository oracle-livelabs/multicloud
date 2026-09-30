# Lab 1: Confirm the Migration Architecture and Preflight Checks

## Introduction

The source database and ZDM run on the assigned EC2 host. GoldenGate runs in the lab's Podman container. Data Pump performs the initial load using EFS; GoldenGate keeps the target synchronized afterward.

Estimated Time: 15 minutes

### Objectives

Identify your assigned resources, verify source access, and confirm readiness before migration.

## Task 1: Load Your Assigned Environment

Open your assigned EC2 Session Manager session. At the **Linux shell**, use the instructor-approved access to the `oracle` user:

```bash
sudo -iu oracle
source "$HOME/env/source19c.env"
source /etc/profile.d/zdm26.sh
source /data/oracle/lab/config/lab-env.sh
export ZDMCLI="$ZDM_HOME/bin/zdmcli"
printf 'Lab=%s\nRegion=%s\nSource=%s\nTarget=%s\nEFS=%s\n' \
  "$LAB_ID" "$AWS_REGION" "$SOURCE_PRIVATE_IP" "$TARGET_HOST" "$EFS_DNS"
test -x "$ZDMCLI" && test -r "$ZDM_RESPONSE_FILE"
/data/oracle/lab/bin/validate-zdm-response.sh
```

Stop if a value is blank, the Lab ID is wrong, or validation fails. A missing validator means provisioning is incomplete. Do not source CloudShell provisioning environments on EC2.

## Task 2: Verify Source SSH

Run as `oracle`. The key belongs to this instance; it is not downloaded from another participant:

```bash
export ZDM_SOURCE_SSH_KEY="$HOME/.ssh/zdm_source_ed25519"
test -s "$ZDM_SOURCE_SSH_KEY" && echo "PASS: key exists"
ssh -i "$ZDM_SOURCE_SSH_KEY" -o BatchMode=yes \
  -o StrictHostKeyChecking=yes "ec2-user@$(hostname -f)" \
  'whoami; sudo -n -iu oracle whoami'
```

Expect `ec2-user`, then `oracle`. If the key or verified host-key entry is missing, ask the instructor to repair provisioning. Do not disable host-key checks or copy private keys.

## Task 3: Verify the Source Database

At the shell:

```bash
sqlplus / as sysdba
```

At `SQL>` (do not paste shell commands here):

```sql
SELECT name, open_mode, log_mode, cdb FROM v$database;
SHOW PARAMETER enable_goldengate_replication
SELECT username, account_status FROM dba_users WHERE username='GGADMIN';
SELECT COUNT(*) AS source_baseline FROM finance.accounts;
EXIT
```

Expect the source open read/write, archive logging enabled for capture, replication enabled, and GGADMIN open. Record the count. This source is not the old `SRCPDB1` prototype; do not switch containers blindly.

## Task 4: Check Network and Service Readiness

```bash
getent hosts "$TARGET_HOST"
getent hosts "$EFS_DNS"
nc -vz -w 5 "$TARGET_HOST" 1521
nc -vz -w 5 "$TARGET_HOST" 1522
nc -vz -w 5 "$EFS_DNS" 2049
"$ZDM_HOME/bin/zdmservice" status
```

The instructor must confirm GoldenGate's case-sensitive `Local` deployment is running, ZDM can reach its endpoint, and the container can reach source and target listeners. These checks are also exercised during ZDM evaluation.

For this workshop, provisioning aligns EC2, the EFS mount target, and ODB network with the selected supported AZ ID. AZ letter names are account-specific. Placement alone does not prove routing, security-group, or DNS correctness. EC2 connectivity does not prove ADB-to-EFS connectivity; Lab 2 tests the latter.

Participants must not alter IAM, routes, security groups, database memory, or container configuration. Escalate failed checks before migration.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 28, 2026
