# Lab 2: Verify Shared Amazon EFS NFS Staging

## Introduction

Verify instructor-provisioned staging. The source directory is `DATA_PUMP_DIR_NFS`; the target directory is `ZDM_EFS_DIR`. This lab uses NFSv4. Do not create another EFS, append duplicate fstab entries, or detach a filesystem used by an active job.

Estimated Time: 15 minutes

### Objectives

Confirm the real EC2 mount, match target attachment metadata, and test ADB-to-EFS reads.

## Task 1: Check the Source Mount

Run at the EC2 shell as `oracle`, with Lab 1's environment loaded:

```bash
findmnt -T "$EFS_MOUNT_POINT" -o TARGET,SOURCE,FSTYPE,OPTIONS
df -hT "$EFS_MOUNT_POINT"
test -w "$EFS_MOUNT_POINT" && echo "PASS: staging writable"
```

Confirm NFS/NFS4, the assigned EFS source, and the expected mount path. A local root filesystem is not an EFS mount. Stop if any check fails.

Create a unique probe:

```bash
EFS_PROBE="lab-${LAB_ID}-nfs-check-$(date -u +%Y%m%dT%H%M%SZ).txt"
printf 'Lab %s NFS check\n' "$LAB_ID" > "$EFS_MOUNT_POINT/$EFS_PROBE"
printf 'Target should read: %s\n' "$EFS_PROBE"
```

## Task 2: Check the Target Attachment

At the shell, use the generated SQL alias; enter the password at the prompt:

```bash
source "$HOME/env/adbs.env"
sqlplus -L admin@"$TARGET_ALIAS"
```

At `SQL>`:

```sql
SELECT file_system_name, file_system_location, directory_name
FROM dba_cloud_file_systems WHERE directory_name='ZDM_EFS_DIR';
SELECT directory_name, directory_path FROM dba_directories
WHERE directory_name='ZDM_EFS_DIR';
```

Match the location against your assigned EFS hostname and export path. The instructor configures target-side DNS, network access, ACLs, and attachment with `JSON_OBJECT('nfs_version' VALUE 4)`. Metadata alone is not an I/O test.

## Task 3: Read the Source Probe on the Target

Enter the exact filename from Task 1:

```sql
SET SERVEROUTPUT ON
ACCEPT probe_file CHAR PROMPT 'Source test filename: '
DECLARE
  f UTL_FILE.FILE_TYPE;
  line VARCHAR2(32767);
BEGIN
  f := UTL_FILE.FOPEN('ZDM_EFS_DIR', '&probe_file', 'R');
  UTL_FILE.GET_LINE(f, line);
  UTL_FILE.FCLOSE(f);
  DBMS_OUTPUT.PUT_LINE(line);
EXCEPTION WHEN OTHERS THEN
  IF UTL_FILE.IS_OPEN(f) THEN UTL_FILE.FCLOSE(f); END IF;
  RAISE;
END;
/
EXIT
```

Expected: the same Lab ID and NFS check text. If the call hangs or fails, do not launch more probes or migrations. Record the time, error, and attachment metadata and contact the instructor. Cancelling a client may not immediately clear a blocked database-side I/O call.

After success, remove only your own probe from the original shell:

```bash
test -n "${EFS_PROBE:-}" && rm -i -- "$EFS_MOUNT_POINT/$EFS_PROBE"
```

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 28, 2026
