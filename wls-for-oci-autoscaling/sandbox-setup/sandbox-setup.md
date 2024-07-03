# Create the OCI resources

## Introduction
Before demonstrating autoscaling in the **WebLogic for OCI** stack, several prerequisites must be met to ensure a secure and efficient setup. We have created an **authentication token**, a **Vault** with encryption keys and **secrets**, and an **Application Performance Monitoring domain** in the Oracle Cloud Infrastructure for the interest of time. In this lab,  we create a pair of SSH keys. These foundational steps are essential for securing your environment and enabling effective performance monitoring and autoscaling.

Estimated Time: 10 minutes

### Objectives
* Know your pre-created OCI resources.
* Generate a pair of SSH keys.


### Prerequisites
This lab assumes you have the following:
- An Oracle Free Tier or Paid Cloud account

## Task 1: Know your pre-created OCI resources.

In this task, you will understand the resources we created for you and what are their uses in WebLogic for the OCI stack.

**Authentication Token** - we have created an authentication token for you and saved it as a secret inside the **Vault**. During WebLogic for OCI stack creation, we will use the secret which has stored the authentication token.

**Vault and Secret** - Secrets are credentials such as passwords, certificates, SSH keys, or **authentication tokens** that you use with Oracle Cloud Infrastructure services. In this workshop, we have stored passwords for **WebLogic Admin Server** and OCI **Authentication token** in secrets.

**Application Performance Monitoring Domain** - The Application Performance Monitoring (APM) domain in OCI provides comprehensive tools for monitoring and analyzing the performance of your applications. It helps in identifying bottlenecks and optimizing performance by offering detailed insights into application behaviour and resource usage. In this workshop, we have created an Application Performance Monitoring domain.

## Task 2: Create a SSH key pair 

In this task, we create an SSH key pair in the Cloud Shell. We will use this SSH key to create the **WebLogic for OCI** stack. Later, we will log in to the WebLogic Compute node from Cloud Shell using these SSH keys.

1. In OCI Console, click on **Developer tools** icon and then click **Cloud Shell** as shown below.
 ![cloud shell](images/cloudshell-menu.png)

2. Copy and paste the following command to ensure that you don't have an existing ssh key pair.    
 ```bash
    <copy>ls -ltra ~/.ssh</copy>
 ```
3. Copy and paste the following command to generate the ssh key pair. Press **enter** to select the default values as shown below.
 ```bash
    <copy>ssh-keygen -b 2048 -t rsa</copy>
 ```
 ![ssh key](images/generate-ssh.png)

4. Copy and paste the following command to get the public key and save it in some text file. We will need it in lab 2 for creating the stack.
 ```bash
    <copy>cat ~/.ssh/id_rsa.pub</copy>
 ```
 ![copy ssh](images/copy-ssh.png)

     > Don't close Cloud Shell, we will use this. You can minimise the **Cloud Shell** using **-** and restore Cloud Shell using the **restore icon** as shown.
 ![minimise cloudshell](images/minimise-cloudshell.png)
 Leave this browser tab open.


You may now proceed to the next lab.

## Acknowledgements
* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, July 2024
