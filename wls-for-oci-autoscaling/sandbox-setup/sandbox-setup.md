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

In this task, you will understand the resources we created for you and what are their uses in WebLogic for the OCI stack. you must have data sheet with you, where you will have the value of these resources.

**Region Name**- We have created the resources for you in the **US East(Ashburn)** region. Make sure you are in this region.   

**Compartment**- When you create a domain with Oracle WebLogic Server for OCI, by default the compute instances, networks, and load balancer are all created within a single compartment. We have created the compartment for you, please find your compartment name in the data sheet. 

**Policies**- Access to Oracle Cloud Infrastructure is controlled through policies.There are two major groupings of policies that are required by Oracle WebLogic Server for OCI:
   - User Group Policies
   - Dynamic Group Policies and Dynamic Group Policies for Autoscaling</br>
   > We have created the required policies for your username.


**Application Performance Monitoring Domain** - The Application Performance Monitoring (APM) domain in OCI provides comprehensive tools for monitoring and analyzing the performance of your applications. It helps in identifying bottlenecks and optimizing performance by offering detailed insights into application behaviour and resource usage. In this workshop, we have created an Application Performance Monitoring domain. Please find the APM domain name in your data sheet.

**Registry User** - To access image in the OCI registry to deploy autoscaling function, we have created the common user. Please find the shared Registry user in your data sheet.

**OCIR Auth token** - In order for Oracle Cloud Infrastructure Registry to deploy autoscaling OCI Functions, you must provide an auth token. we have created an authentication token for the shared user and saved it as a secret inside the vault. Please find the secret for OCIR Auth token in your data sheet.

**WLS Password** - While creating the WebLogic for OCI stack, we need to provide the Administrator password for the new WebLogic domain. we have saved this password as a secret inside the vault. Please find the WLS Password in your data sheet. 

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
* **Contributors** - Adrian Padilla Duarte , Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, July 2024
