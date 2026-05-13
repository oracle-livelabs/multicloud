
# Create the Required Resources to Create an Oracle Autonomous AI Database on Dedicated Exadata Infrastructure on Oracle AI Database@AWS

## Introduction

This lab walks you through creating an ssh key pair which is required for creating an Exadata VM cluster.


> **What is an SSH key pair?**  

> An SSH key pair consists of two cryptographically linked files — a **private key** (kept secret on your machine) and a **public key** (shared with remote servers). Together they let you authenticate securely without a password.
 
 Estimated Time: About 5 min.

### Objectives

* In this lab you will create an ssh key pair.



## Creating an SSH Key Pair on macOS

1. Open Terminal

Launch **Terminal** via:
- **Spotlight**: Press `Cmd + Space`, type `Terminal`, press `Enter`
- **Finder**: Applications → Utilities → Terminal

2. Generate the Key Pair

Run the following command:
```bash
ssh-keygen -t ed25519 
```

> **Why `ed25519`?** It uses elliptic-curve cryptography, offering strong security with shorter key sizes and faster performance. If your server requires RSA, use `-t rsa -b 4096` instead.

3. Choose a Save Location

You will be prompted:

```
Enter file in which to save the key (/Users/yourname/.ssh/id_ed25519):
```

- Press **Enter** to accept the default location (`~/.ssh/id_ed25519`), or type a custom path.
- The default location is recommended unless you manage multiple keys.

4. Set a Passphrase (Recommended)

```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```
- A passphrase adds an extra layer of security — if your private key file is ever stolen, it cannot be used without the passphrase.
- Press **Enter** twice to skip (not recommended for sensitive environments).

5. — Confirm the Key Was Created
```bash
ls -la ~/.ssh/ 
```
| File | Description |
|------|-------------|
| `id_ed25519` | **Private key** — never share this file |
| `id_ed25519.pub` | **Public key** — safe to share with servers |

6. View Your Public Key

 ```bash
 cat ~/.ssh/id_ed25519.pub
 ```

Copy the output (beginning with `ssh-ed25519 ...`) — you will need this when creating Exadata VM cluster.

Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created Exadata Infrastructure!**.

**You may now proceed to the next lab.**.


## Creating an SSH Key Pair on Windows

1. Open PowerShell 

- **PowerShell**: Press `Win + X` → "Windows PowerShell"


2. Generate the Key Pair

```powershell
ssh-keygen -t ed25519 
```

For older systems that don't support ed25519:

```powershell
ssh-keygen -t rsa -b 4096 
```

3. Choose a Save Location

You will be prompted:

```
Enter file in which to save the key (C:\Users\yourname/.ssh/id_ed25519):
```

- Press **Enter** to accept the default, or enter a custom path.

4. Set a Passphrase (Recommended)

```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

Enter a strong passphrase or press **Enter** twice to skip.

5. Confirm the Key Was Created

```powershell
dir $env:USERPROFILE\.ssh\
```

You should see:

| File | Description |
|------|-------------|
| `id_ed25519` | **Private key** — never share this file |
| `id_ed25519.pub` | **Public key** — safe to share with servers |

6. View Your Public Key

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub
```
Copy the entire output — you will need this when creating Exadata VM cluster.

8. Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created Exadata Infrastructure!**.

**You may now proceed to the next lab.**

## Learn More
* [Oracle AI Database@AWS](https://docs.oracle.com/en-us/iaas/Content/database-at-aws/oaaws.htm)
* [What is an Oracle Exadata ?](https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/exadata-cloud-infrastructure-overview.html)

## Acknowledgements
- **Author:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Contributor:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Devinder Singh, May 2026
