
# Create an ssh key pair

## Introduction

This lab walks you through creating an ssh key pair which is required for creating a Base Database. 


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
ssh-keygen -t rsa 
```

3. Choose a Save Location

You will be prompted:

```
Enter file in which to save the key (/Users/yourname/.ssh/id_rsa):
```

- Press **Enter** to accept the default location (`~/.ssh/id_rsa`), or type a custom path.
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
| `id_rsa` | **Private key** — never share this file |
| `id_rsa.pub` | **Public key** — safe to share with servers |

6. View Your Public Key

 ```bash
 cat ~/.ssh/id_rsa.pub
 ```

Copy the output (beginning with `ssh-rsa ...`) — you will need this when creating Exadata VM cluster.

Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created Exadata Infrastructure!**.

**You may now proceed to the next lab.**.


## Creating an SSH Key Pair on Windows

1. Open PowerShell 

- **PowerShell**: Press `Win + X` → "Windows PowerShell"


2. Generate the Key Pair

```powershell
ssh-keygen -t rsa
```

3. Choose a Save Location

You will be prompted:

```
Enter file in which to save the key (C:\Users\yourname/.ssh/id_rsa):
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
| `id_rsa` | **Private key** — never share this file |
| `id_rsa.pub` | **Public key** — safe to share with servers |

6. View Your Public Key

```powershell
type $env:USERPROFILE\.ssh\id_rsa.pub
```
Copy the entire output — you will need this when creating Base Database

8. Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created an ssh key pair!**.

**You may now proceed to the next lab.**

## Learn More
* [Oracle AI Database@Google Cloud](https://docs.oracle.com/en-us/iaas/Content/database-at-gcp/home.htm)
* [Oracle Base Database Service](https://docs.oracle.com/en/cloud/paas/base-database/about/)
* [How to create an ssh Key pair](https://docs.cloud.google.com/compute/docs/connect/create-ssh-keys#linux-and-macos)

## Acknowledgements
- **Author:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Contributor:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Devinder Singh, May 2026