# Lab 1: Confirm the Migration Architecture and Preflight Checks

## Introduction

The source database and ZDM run on the assigned EC2 host. GoldenGate runs in the lab's Podman container. Data Pump performs the initial load using EFS; GoldenGate keeps the target synchronized afterward.

Estimated Time: 15 minutes

### Objectives

Identify your assigned resources, verify source access, and confirm readiness before migration.

## Task 1: Load Your Assigned Environment

1. Open your assigned EC2 Session Manager session from the EC2 console, or follow these steps in **AWS CloudShell as `cloudshell-user`**. Replace `YOUR_ASSIGNED_INSTANCE_ID` with the EC2 instance ID provided for your lab. Do not use another participant's instance ID.

    ```bash
    <copy>
    export ASSIGNED_INSTANCE_ID="YOUR_ASSIGNED_INSTANCE_ID"
    </copy>
    ```

2. Start the Session Manager connection in a separate command.

    ```bash
    <copy>
    aws ssm start-session --region us-west-2 --target "$ASSIGNED_INSTANCE_ID"
    </copy>
    ```

    Expect `Starting session with SessionId:` followed by the EC2 shell prompt, usually `sh-4.4$`.

3. Run the remaining commands on **the assigned EC2**, not CloudShell or the runner. At the Linux shell as `ssm-user`, switch to `oracle`.

    ```bash
    <copy>
    sudo -iu oracle
    </copy>
    ```

4. Load the source and assigned lab environments in the **`oracle` shell**.

    ```bash
    <copy>
    source "$HOME/env/source19c.env"
    source /etc/profile.d/zdm26.sh
    source /data/oracle/lab/config/lab-env.sh
    export ZDMCLI="$ZDM_HOME/bin/zdmcli"
    </copy>
    ```

5. Print your lab assignment. Check that the Lab ID and target are the ones assigned to you.

    ```bash
    <copy>
    printf 'Lab=%s\nRegion=%s\nSource=%s\nTarget=%s\nEFS=%s\n' \
      "$LAB_ID" "$AWS_REGION" "$SOURCE_PRIVATE_IP" "$TARGET_HOST" "$EFS_DNS"
    </copy>
    ```

6. Check that the ZDM executable and response file are accessible.

    ```bash
    <copy>
    test -x "$ZDMCLI" && test -r "$ZDM_RESPONSE_FILE"
    </copy>
    ```

7. Validate the generated ZDM response file. Require the final `ZDM_RESPONSE_VALID` marker.

    ```bash
    <copy>
    /data/oracle/lab/bin/validate-zdm-response.sh
    </copy>
    ```

    Stop if a value is blank, the Lab ID is wrong, or validation fails. A missing validator means provisioning is incomplete. Do not source CloudShell provisioning environments on EC2.

8. Confirm the user and Oracle environment.

    ```bash
    <copy>
    printf 'OS_USER=%s\nORACLE_SID=%s\nZDM_HOME=%s\nTARGET_ALIAS=%s\n' \
      "$(whoami)" "$ORACLE_SID" "$ZDM_HOME" "$TARGET_ALIAS"
    </copy>
    ```

    Example from Lab 101: the OS user is `oracle`, the source SID is `SOURCE19C`, and the target alias belongs to the assigned lab. Hostnames, IDs, paths, and addresses in screenshots are examples, not values to copy into another lab.

    ![Lab 101 Oracle user, source SID, ZDM home and target alias](./images/participant-environment.png)

## Task 2: Verify Source SSH

1. Run as `oracle` and confirm that the key belonging to this instance exists.

    ```bash
    <copy>
    export ZDM_SOURCE_SSH_KEY="$HOME/.ssh/zdm_source_ed25519"
    test -s "$ZDM_SOURCE_SSH_KEY" && echo "PASS: key exists"
    </copy>
    ```

2. Test same-host SSH and the switch to `oracle`.

    ```bash
    <copy>
    ssh -i "$ZDM_SOURCE_SSH_KEY" -o BatchMode=yes \
      -o StrictHostKeyChecking=yes "ec2-user@$(hostname -f)" \
      'whoami; sudo -n -iu oracle whoami'
    </copy>
    ```

    Expect `ec2-user`, then `oracle`. If the key or verified host-key entry is missing, ask the instructor to repair provisioning. Do not disable host-key checks or copy private keys.

## Task 3: Verify the Source Database

1. At the **`oracle` shell**, open the source database.

    ```bash
    <copy>
    sqlplus / as sysdba
    </copy>
    ```

2. At `SQL>` (do not paste shell commands here), check the database state.

    ```sql
    <copy>
    SET LINESIZE 220
    SET PAGESIZE 100
    SELECT instance_name, host_name, status, database_status FROM v$instance;
    SELECT name, open_mode, log_mode, cdb, force_logging,
           supplemental_log_data_min FROM v$database;
    </copy>
    ```

3. At **source `SQL>`**, check the replication and memory settings without changing them.

    ```sql
    <copy>
    SHOW PARAMETER enable_goldengate_replication
    SHOW PARAMETER sga_target
    SHOW PARAMETER sga_max_size
    SHOW PARAMETER streams_pool_size
    </copy>
    ```

4. Check the source accounts and record the initial row count.

    ```sql
    <copy>
    SELECT username, account_status FROM dba_users
    WHERE username IN ('SYSTEM','GGADMIN','FINANCE') ORDER BY username;
    SELECT COUNT(*) AS source_baseline FROM finance.accounts;
    </copy>
    ```

5. Return to the **`oracle` shell**.

    ```sql
    <copy>
    EXIT
    </copy>
    ```

6. Verify the results. Expect OPEN/ACTIVE, READ WRITE, ARCHIVELOG, FORCE_LOGGING=YES, supplemental logging enabled, replication enabled, and the listed accounts open. Record the count. Memory queries are read-only diagnostics; do not change parameters or reset passwords.

    Source database state (Lab 101 example):

    ![Source database open and active with archive logging enabled](./images/source-database-ready.png)

    GoldenGate replication setting:

    ![Source enable_goldengate_replication is TRUE](./images/source-replication-enabled.png)

    Account status:

    ![Source FINANCE, GGADMIN and SYSTEM accounts are OPEN](./images/source-accounts-open.png)

## Task 4: Check Network and Service Readiness

1. Run these read-only DNS checks from the **`oracle` EC2 shell**.

    ```bash
    <copy>
    getent hosts "$TARGET_HOST"
    getent hosts "$EFS_DNS"
    </copy>
    ```

2. Check the target database on port 1521. These checks use Bash instead of `nc`, which is not installed on the lab instances.

    ```bash
    <copy>
    timeout 5 bash -c 'exec 3<>/dev/tcp/"$1"/"$2"' _ "$TARGET_HOST" 1521 \
      && echo "PASS: target port 1521 reachable" \
      || echo "FAIL: target port 1521 — check DNS, routing, and security rules"
    </copy>
    ```

3. Check the target database on port 1522.

    ```bash
    <copy>
    timeout 5 bash -c 'exec 3<>/dev/tcp/"$1"/"$2"' _ "$TARGET_HOST" 1522 \
      && echo "PASS: target port 1522 reachable" \
      || echo "FAIL: target port 1522 — check DNS, routing, and security rules"
    </copy>
    ```

4. Check EFS on port 2049.

    ```bash
    <copy>
    timeout 5 bash -c 'exec 3<>/dev/tcp/"$1"/"$2"' _ "$EFS_DNS" 2049 \
      && echo "PASS: EFS port 2049 reachable" \
      || echo "FAIL: EFS port 2049 — check DNS, routing, and security rules"
    </copy>
    ```

    Expect `PASS` from each check before proceeding. These checks verify TCP connectivity only, not database authentication or EFS mount readiness.

5. Check the ZDM service.

    ```bash
    <copy>
    "$ZDM_HOME/bin/zdmservice" status
    </copy>
    ```

    ZDM evaluation in Lab 3 checks the GoldenGate deployment and database connectivity. Stop here if a connectivity or service check fails.

6. Return from the `oracle` login shell to **`ssm-user`** with `exit`. If already `ssm-user`, do not exit the Session Manager session.

    ```bash
    <copy>
    exit
    </copy>
    ```

7. Confirm the current user before checking the rootless Podman container.

    ```bash
    <copy>
    whoami
    </copy>
    ```

8. Run Podman as the container owner, `ec2-user`.

    ```bash
    <copy>
    OGG_UID="$(id -u ec2-user)"
    OGG_RUNTIME="/tmp/xdg-runtime-${OGG_UID}"
    sudo -u ec2-user env \
      HOME=/home/ec2-user \
      XDG_RUNTIME_DIR="$OGG_RUNTIME" \
      podman ps
    </copy>
    ```

    The container owner is `ec2-user`; expect `oggfree` to report `Up`.

    ![GoldenGate oggfree container reports Up](./images/goldengate-container-running.png)

9. Validate the wallet inside GoldenGate from the same **`ssm-user` shell**.

    ```bash
    <copy>
    OGG_UID="$(id -u ec2-user)"
    OGG_RUNTIME="/tmp/xdg-runtime-${OGG_UID}"
    sudo -u ec2-user env \
      HOME=/home/ec2-user \
      XDG_RUNTIME_DIR="$OGG_RUNTIME" \
      podman exec oggfree sh -lc '
        set -e
        ls -l /u02/Deployment/etc/adb
        test -s /u02/Deployment/etc/adb/cwallet.sso
        test -s /u02/Deployment/etc/adb/ewallet.p12
        grep -F "/u02/Deployment/etc/adb" \
          /u02/Deployment/etc/adb/sqlnet.ora
        echo "PASS: GoldenGate wallet is ready"
      '
    </copy>
    ```

    ![GoldenGate wallet files and wallet readiness PASS](./images/goldengate-wallet-ready.png)

10. From **`ssm-user`**, check the GoldenGate endpoint as `ec2-user`.

    ```bash
    <copy>
    sudo -u ec2-user curl -k -sS -o /dev/null \
      -w 'GoldenGate HTTP=%{http_code}\n' \
      https://127.0.0.1:8443/services/v2/config/health
    </copy>
    ```

    `-k` is limited to this localhost diagnostic against the workshop's self-signed certificate; do not use it to relax other connection checks.

    ![Unauthenticated GoldenGate endpoint request returns HTTP 401](./images/goldengate-endpoint-response.png)

    HTTP `200` or `401` demonstrates that the endpoint answered; `401` does not prove authenticated GoldenGate readiness. Use ZDM evaluation as well. Do not rerun provisioning or change container settings.

11. Remain in the **`ssm-user` shell** for Lab 2. EC2 connectivity does not prove ADB-to-EFS connectivity; Lab 2 tests that path. Stop on failed checks rather than changing the provisioned infrastructure.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
