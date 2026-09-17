# Troubleshoot the Private S3 Workshop

## Introduction

In this lab, you will diagnose common deployment, routing, credential, and endpoint-hostname issues. You can also configure optional OCI Bastion access when operating-system logs are required.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

* Identify common causes of failed plans and missing validation objects
* Correct access-denied and TLS hostname errors
* Optionally use OCI Bastion to inspect cloud-init logs on the private runner

## Task 1: Diagnose Common Issues

Use this table to identify the first checks for each symptom:

| Symptom | Check or fix |
|---|---|
| Resource Manager Plan fails | Verify the compartment, subnet, and NSG OCIDs. Check Compute quota and flexible-shape capacity. |
| Network Plan reports `Unsupported argument` for `drg_attachment_type` | Confirm that you downloaded the current network ZIP. Create a replacement network stack from the current package; a failed Plan creates no infrastructure. |
| VM exists but no result file appears | Confirm that the interconnect is active, BGP is **Up**, the endpoint security group permits TCP 443 from OCI, and `sample.csv` is at the bucket root. |
| `AccessDenied` | Check the access key, object names, bucket name, and endpoint policy values. Re-create the runner after correcting a value. |
| TLS hostname mismatch | Use `BUCKET.bucket.vpce-...`, not `BUCKET.vpce-...`. |
| An existing result makes a retry unclear | Delete `validation-result.txt` before destroying and applying the runner stack again. |

After correcting a runner variable or credential, destroy and apply the runner stack. Changing a variable on the existing instance does not rerun cloud-init.

## Task 2: Generate an Optional SSH Key

OCI Bastion diagnostics require an SSH key pair. The public key is a single line ending in `.pub`. Paste only that public key into the runner stack variable `ssh_public_key`. Keep the matching private key on your computer.

> **Warning:** Never upload or paste the private key into OCI Resource Manager, AWS, a ticket, email, or chat.

### macOS

1. Open **Terminal**.

2. Create the key pair:

    ```bash
    <copy>
    mkdir -p ~/.ssh
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/private-s3-lab-rsa -C "private-s3-lab-rsa"
    chmod 600 ~/.ssh/private-s3-lab-rsa
    </copy>
    ```

3. When prompted, choose a passphrase if your process permits one. Otherwise, press Enter to leave it blank for this disposable lab key.

4. Copy the public key:

    ```bash
    <copy>
    pbcopy < ~/.ssh/private-s3-lab-rsa.pub
    </copy>
    ```

5. Record the private key path: `/Users/YOUR_MAC_LOGIN/.ssh/private-s3-lab-rsa`.

### Windows 10 or 11

1. Open **PowerShell**.

2. Create the key pair and copy the public key:

    ```powershell
    <copy>
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.ssh"
    ssh-keygen -t rsa -b 2048 -f "$env:USERPROFILE\.ssh\private-s3-lab-rsa" -C "private-s3-lab-rsa"
    Get-Content "$env:USERPROFILE\.ssh\private-s3-lab-rsa.pub" | Set-Clipboard
    </copy>
    ```

3. When prompted, choose a passphrase if your process permits one. Otherwise, press Enter to leave it blank for this disposable lab key.

4. Record the private key path: `C:\Users\YOUR_WINDOWS_LOGIN\.ssh\private-s3-lab-rsa`.

If `ssh-keygen` is unavailable, install **OpenSSH Client** from **Settings**, **Apps**, **Optional features**, **View features**, **OpenSSH Client**.

## Task 3: Configure Bastion Diagnostic Access

1. Add the complete one-line public key to the runner stack variable `ssh_public_key` before creating the VM.

2. Create an OCI Standard Bastion in the runner VCN. Allow your computer's current public IP address as a `/32` CIDR.

3. Add an ingress rule to the runner NSG:

    | Setting | Value |
    |---|---|
    | Protocol | TCP |
    | Destination port | `22` |
    | Source | Bastion private endpoint IP with `/32` |

4. Create an **SSH port forwarding** Bastion session to the runner's private IP address on port `22`. Use the same public key.

5. Run the OCI-generated port-forward command in one terminal.

6. In a second terminal, connect through the forwarded port. Replace the key path and port with your values:

    ```bash
    <copy>
    ssh -i /path/to/private-key -p 2222 opc@127.0.0.1
    </copy>
    ```

7. Inspect cloud-init:

    ```bash
    <copy>
    sudo cloud-init status --long
    sudo tail -n 200 /var/log/cloud-init-output.log
    </copy>
    ```

## Summary

You reviewed the common failure modes and, when necessary, used OCI Bastion to inspect the private runner without assigning it a public IP address.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
