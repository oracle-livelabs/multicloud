# Lab 1: Confirm the Migration Architecture and Preflight Checks

## Introduction

The source Oracle database and Zero Downtime Migration (ZDM) run on your assigned EC2 instance. Oracle GoldenGate runs in a Podman container on that instance. Data Pump copies the initial data through shared Amazon EFS storage, and GoldenGate captures ongoing changes to keep the target Autonomous Database synchronized.

Run the preflight script once and confirm the final success summary. The detailed output sections are optional reference material for understanding the checks or investigating a failure.

Estimated Time: 15 minutes

### Objectives

Connect to your assigned EC2 instance, run the automated checks as `oracle`, and understand the results before starting migration.

## Task 1: Connect to SSM Session Manager

1. Confirm that the AWS Console Region is **US West (Oregon), us-west-2**.

2. Open **EC2 → Instances**. Copy the **EC2 Instance ID** from your reservation information into the search field. Select the checkbox beside the matching instance, then choose **Connect**. Use your assigned instance ID; Lab 101 below is an example.

    ![Filter by the assigned EC2 instance ID, select its checkbox, and choose Connect](./images/ec2-select-assigned-instance.png)

    On the connection page, choose **SSM Session Manager** and then **Connect**. In the newer console layout, this option appears under **In web browser → Maximum security — IAM authentication — SSM Session Manager**. Do not select EC2 Instance Connect.

3. The session opens a Linux shell as `ssm-user`. Switch to the `oracle` operating-system user:

    ```bash
    <copy>
    sudo -iu oracle
    </copy>
    ```

4. Confirm your current user:

    ```bash
    <copy>
    whoami
    </copy>
    ```

    The output should be `oracle`. Stay in this `oracle` shell for the remaining steps.

## Task 2: Run the Preflight Script

1. Run the script from the `oracle` user's home directory and save its output. The script loads your assigned environment variables and performs the checks automatically. Wait until the shell prompt returns before entering another command.

    ```bash
    <copy>
    cd "$HOME"
    umask 077
    set -o pipefail
    bash "$HOME/lab1-preflight.sh" 2>&1 | tee "$HOME/lab1-preflight.log"
    </copy>
    ```

2. Check the summary. Expect `Failed checks : 0` and `LAB1_PREFLIGHT: PASS`. Resolve any failed checks before proceeding.

    ![Final preflight summary with zero failed checks and LAB1_PREFLIGHT PASS](./images/preflight-section-8.png)

    If both values match, continue to Lab 2. The detailed review below is optional.

3. **Optional:** Open the saved output to review a check or investigate a failure:

    ```bash
    <copy>
    less -S "$HOME/lab1-preflight.log"
    </copy>
    ```

    Use the arrow keys or Page Up/Page Down to move through the output. Use the left and right arrows for wide lines. Press `q` to return to the shell.

## (Optional Task) Review Detailed Validation Output

The sections below show screenshots of sample output. Compare them with your own results. Resource names, addresses, paths, timestamps, container IDs, and row counts can differ. Check your assigned values rather than copying values from the screenshots.

### Section 1: Your Assigned Environment

This section identifies the source database EC2 host, source database, target Autonomous Database, and Amazon EFS filesystem. It also checks that the ZDM executable is accessible.

Confirm that the assignment ID, target database name, target database TNS alias, and **ADB-S display name** match your assigned resources. The display name identifies the target database in the console; the TNS alias is used to connect to it. Check that the source database and Amazon EFS addresses are populated and that the ZDM executable check passes.

These values connect the migration components to the correct source database, target database, and Amazon EFS storage. A mismatch can send a connection or data-transfer operation to the wrong resource.

![Assigned source, target ADB-S display name, EFS details, and ZDM executable check](./images/preflight-section-1.png)

### Section 2: Source SSH Access

This section checks that the source SSH key exists and that ZDM can use it to connect as `ec2-user` and switch to `oracle` without an interactive password prompt.

Expect both `ec2-user` and `oracle` in the output, followed by `PASS` for source SSH and the Oracle user switch. ZDM needs this access to perform source-side migration operations. Do not continue if the key or user-switch check fails.

![Source SSH key and passwordless switch from ec2-user to oracle both pass](./images/preflight-section-2.png)

### Section 3: Source SYSTEM Login Verification

This section verifies a password-based `SYSTEM` connection to the source database service `SOURCE19C`.

Expect `PASS: password-based SYSTEM login to SOURCE19C` and `PASS` for SYSTEM login verification. This confirms that the source administrative credentials and local listener connection work. ZDM needs a working source administrative account; operating-system access alone does not prove that database authentication succeeds.

![Password-based SYSTEM connection to SOURCE19C passes](./images/preflight-section-3.png)

### Section 4: Source Database Readiness and Baseline

This section checks the source database state, logging configuration, GoldenGate setting, account status, and initial row count.

First, confirm that the instance is `OPEN` and `ACTIVE`, the database is `READ WRITE`, and `LOG_MODE` is `ARCHIVELOG`. Expect `FORCE_LOGGING` to be `YES`, supplemental logging to be enabled (`YES` or `IMPLICIT`), and `enable_goldengate_replication` to be `TRUE`.

The source database must stay available while the initial data is copied. Archive logging and the additional logging settings provide the change information GoldenGate needs to capture ongoing transactions.

![Source database state, archive logging, supplemental logging, and GoldenGate replication setting](./images/preflight-section-4a.png)

Next, confirm that the source database accounts `FINANCE`, `GGADMIN`, and `SYSTEM` are all `OPEN`. Record `SOURCE_BASELINE`, the current number of rows in `FINANCE.ACCOUNTS`, for later comparison with the target database. Expect `PASS` for source database SQL readiness checks.

![Source memory diagnostics, open database accounts, baseline row count, and SQL readiness result](./images/preflight-section-4b.png)

### Section 5: DNS and TCP Connectivity

This section checks whether the target database and Amazon EFS hostnames resolve, then tests connections from EC2 to target database ports `1521` and `1522` and Amazon EFS port `2049`.

Expect `PASS` for both hostname checks and all three port checks. Port `1521` is used for the configured SQL connection, `1522` for the wallet-based TCPS connection, and `2049` for Amazon EFS access over NFSv4.

ZDM and GoldenGate need network access to the databases, and Data Pump needs Amazon EFS staging storage. These checks prove that EC2 can reach the endpoints; they do not prove database authentication, an Amazon EFS mount, or connectivity from the target database to Amazon EFS.

![Target and EFS hostname resolution and all three TCP port checks pass](./images/preflight-section-5.png)

### Section 6: ZDM Service

This section reports the status of the ZDM service and its local configuration.

Expect `Running: true` and `PASS: ZDM service is running`. Repository paths and service ports provide diagnostic context. ZDM must be running to accept and coordinate evaluation and migration jobs; this result does not mean a migration has started.

![ZDM service reports Running true and a passing status check](./images/preflight-section-6.png)

### Section 7: GoldenGate Container and Wallet

This section checks the `oggfree` container as its owner, `ec2-user`, confirms that the wallet files are present, checks the configured wallet location, and contacts the local GoldenGate endpoint.

Expect the container status to show `Up`, the wallet check to report `PASS`, and the overall container, wallet, and endpoint check to pass. The wallet files support the secure target database connection. A running GoldenGate service is needed to replicate changes after the initial data copy.

An HTTP response of `401` means the endpoint answered but requires authentication.

![Running GoldenGate container, wallet readiness, and local endpoint response](./images/preflight-section-7.png)

### Section 8: Final Readiness Summary

This section summarizes the checks. Expect `Passed checks : 12`, `Failed checks : 0`, and the final `LAB1_PREFLIGHT: PASS` marker.

Review any `FAIL` messages before proceeding, even if other sections pass. A successful summary confirms these preflight checks completed; it does not mean the data has migrated or GoldenGate replication is already running.

![Final summary with twelve passed checks, zero failed checks, and LAB1_PREFLIGHT PASS](./images/preflight-section-8.png)

The script loads environment variables in its own process. They do not remain in your interactive shell afterward, so source the required environment files when a later command needs them.

Remain in the `oracle` shell for Lab 2.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / October 8, 2026
