# Lab 2: Verify Shared Amazon EFS NFS Staging

## Introduction

Verify your assigned staging filesystem. The source directory is `DATA_PUMP_DIR_NFS`; the target directory is `ZDM_EFS_DIR`. This lab uses NFSv4. Complete these checks before starting migration.

Estimated Time: 15 minutes

### Objectives

Confirm the EC2 mount, match target attachment metadata, and verify that a file written by ADB-S can be read on EC2.

## Task 1: Check the Source Mount

Before migration, run the provided mount helper from **EC2 Session Manager as `ssm-user`**. If continuing in the `oracle` login shell from Lab 1, use `exit` once to return to `ssm-user`; check `whoami` before proceeding.

```bash
sudo /data/oracle/lab/bin/mount-efs.sh
```

Switch to **`oracle`**:

```bash
sudo -iu oracle
```

Load the source and assigned lab environments:

```bash
source "$HOME/env/source19c.env"
source /data/oracle/lab/config/lab-env.sh
```

The helper uses the assigned configuration. Do not run it to repair storage during an active migration; escalate instead. Continue at the EC2 shell as **`oracle`**:

```bash
echo "$EFS_DNS"
echo "$EFS_IP"
echo "$EFS_MOUNT_POINT"
```

Check the filesystem mounted at that path:

```bash
findmnt -T "$EFS_MOUNT_POINT" -o TARGET,SOURCE,FSTYPE,OPTIONS
df -hT "$EFS_MOUNT_POINT"
```

Check write access for `oracle`:

```bash
test -w "$EFS_MOUNT_POINT" && echo "PASS: staging writable"
```

Confirm NFS/NFS4, the assigned EFS source, and the expected mount path. A local root filesystem is not an EFS mount. Stop if any check fails.

![Lab 101 assigned EFS hostname, mount and writable status](./images/efs-mount.png)

Example: Lab 101 uses `/data/oracle/efs`. Use your generated environment values, not the screenshot's filesystem ID or IP. These checks do not require recreating the mount.

```bash
source "$HOME/env/adbs.env"
export EFS_NAME="EFS${RESOURCE_LAB_ID:-$LAB_ID}"
```

Print the assigned EFS and target details:

```bash
printf 'Lab ID: %s\nTarget alias: %s\nEFS name: %s\nEFS ID: %s\nEFS DNS: %s\nEFS IP: %s\nMount: %s\n' \
  "$LAB_ID" "$TARGET_ALIAS" "$EFS_NAME" "$EFS_ID" \
  "$EFS_DNS" "$EFS_IP" "$EFS_MOUNT_POINT"
```

![Lab 101 EFS assignment and target alias](./images/efs-assignment.png)

Test write access using `oracle-write-test`. If `oracle-write-test` already exists, stop before running this test.

```bash
touch "$EFS_MOUNT_POINT/oracle-write-test"
ls -l "$EFS_MOUNT_POINT/oracle-write-test"
```

![Oracle creates, lists and removes an EFS write-test file](./images/efs-source-write-test.png)

Remove the write-test file you just created:

```bash
rm -f "$EFS_MOUNT_POINT/oracle-write-test"
```

## Task 2: Check the Target Attachment

At the shell, use the generated SQL alias; enter the password at the prompt:

```bash
source "$HOME/env/adbs.env"
"$ORACLE_HOME/bin/tnsping" "$TARGET_ALIAS"
```

Connect to the target as ADMIN and enter the supplied password at the prompt:

```bash
sqlplus -L admin@"$TARGET_ALIAS"
```

At `SQL>`:

```sql
SET LINESIZE 220
SET PAGESIZE 100
COLUMN file_system_name FORMAT A15
COLUMN file_system_location FORMAT A75
COLUMN directory_name FORMAT A20
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS db_name,
       SYS_CONTEXT('USERENV','SERVICE_NAME') AS service_name,
       SYS_CONTEXT('USERENV','CURRENT_USER') AS current_user FROM dual;
```

Check the attached filesystem and database directory at **target `SQL>`**:

```sql
SELECT file_system_name, file_system_location, directory_name,
       directory_path, nfs_version
FROM dba_cloud_file_systems WHERE directory_name='ZDM_EFS_DIR';
SELECT directory_name, directory_path FROM dba_directories
WHERE directory_name='ZDM_EFS_DIR';
```

Match the location against your assigned EFS hostname and export path, and confirm NFS version 4. Metadata alone is not an I/O test.

![Target attachment referencing the assigned EFS and ZDM_EFS_DIR with NFS version 4](./images/target-efs-attachment.png)

The example's attachment name is `ZDM_EFS`; the AWS resource name is `EFS101`. Compare the filesystem location and directory, rather than requiring those two names to be identical.

Return to the **`oracle` shell**:

```sql
EXIT
```

## Task 3: Validate a Target Write from EC2

Before starting migration, connect to the target as ADMIN from the **`oracle` EC2 shell**:

```bash
source "$HOME/env/adbs.env"
sqlplus -L admin@"$TARGET_ALIAS"
```

At **target `SQL>`**, write `participant_validation.txt`. This replaces that test file if it already exists; use it only for the workshop validation. Use the existing provisioned `ZDM_EFS_DIR`.

```sql
DECLARE
  f UTL_FILE.FILE_TYPE;
BEGIN
  f := UTL_FILE.FOPEN('ZDM_EFS_DIR', 'participant_validation.txt', 'w');
  UTL_FILE.PUT_LINE(f, 'EFS attachment validated from ADB-S');
  UTL_FILE.FCLOSE(f);
EXCEPTION WHEN OTHERS THEN
  IF UTL_FILE.IS_OPEN(f) THEN UTL_FILE.FCLOSE(f); END IF;
  RAISE;
END;
/
```

Require `PL/SQL procedure successfully completed`, then confirm the file exists:

```sql
SELECT object_name, bytes FROM DBMS_CLOUD.LIST_FILES('ZDM_EFS_DIR')
WHERE object_name = 'participant_validation.txt';
```

Return to the EC2 shell:

```sql
EXIT
```

First, the target ADB-S write completes:

![ADB-S UTL_FILE write to participant_validation.txt completes successfully](./images/efs-target-write-proof.png)

In the **`oracle` EC2 shell**, go to the EFS mount:

```bash
cd /data/oracle/efs
```

Read the file written by ADB-S:

```bash
cat participant_validation.txt
```

Expect `EFS attachment validated from ADB-S`. Leave the file in place.

![EC2 reads EFS attachment validated from ADB-S from the shared file](./images/efs-source-read-proof.png)

Stop if the write or read fails or hangs; do not start migration or repeat blocked I/O calls.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
