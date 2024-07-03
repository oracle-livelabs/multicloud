# Setup the resource for load enhancement

## Introduction

Before demonstrating autoscaling in the WebLogic for OCI stack, certain prerequisites must be fulfilled. This guide outlines the steps to validate stack deployment and extract essential IP addresses for the Bastion, Load Balancer, and WebLogic Server (WLS) Node. Then, you will ssh login to the WebLogic Node from the CloudShell. These steps are crucial for ensuring a functional and accessible WebLogic environment.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Validate the stack and copy the IP of **Bastion**, **Load balancer** and **WLS Node**
* SSH Login to WebLogic Node from the CloudShell

### Prerequisites
This lab assumes you have the following:

* An Oracle Cloud account
* Created Stack: Oracle WebLogic Server Enterprise Edition BYOL

## Task 1: Validate the stack and copy the IP of Bastion, Load balancer and WLS Node

In this task, we verify the creation of the stack and save IP of Bastion, Load Balancer and WebLogic Node.  

1. Go back to the browser tab, where you have the job running. Once you see the job status as **SUCCEEDED**, it means your stack is successfully created. Click **Stack details** as shown below. 
 ![job succeed](images/job-succeed.png)

2. In the stack details page, click on the **Application information** tab as shown below.
 ![application information](images/application-information.png)

3. From the **WebLogic** section, copy the IP for the WebLogic Server node from the **WebLogic Server Administration Console:** URL. For example in the below screen, IP is **10.0.2.170**. Also, copy the IP for Load Balancer as shown below. Please save these values in the text file, we need it in the next task.
 ![loadbalencer compute ip](images/loadbalencer-compute-ip.png)
    > Don't take the value from the screenshot, they are just for reference. 

4. Copy the public IP for the Bastion node as shown below. Please save the value in the text file, we need it in the next task.
 ![bastion ip](images/bastion-ip.png)


## Task 2: SSH Login to WebLogic Node from the CloudShell

In this task, we connect to WebLogic Node from the Cloud Shell using the SSH Key, Bastion IP and WebLogic Node IP. Then, we download and deploy a sample application **RCMWeb** to the WebLogic Cluster. We use this application to increase the **CpuProcessLoad** on WebLogic Cluster.

1. Go back to CloudShell, copy and paste the following command in the text file and replace **`<BASTION_IP>`** and **`<WLS_NODE_IP>`** with the values, you copied in task 1 of this lab.
 ```bash
    <copy>ssh  -o ProxyCommand="ssh -W %h:%p opc@<BASTION_IP>" opc@<WLS_NODE_IP></copy>
 ```

2. Paste the modified command in Cloud Shell and enter **yes** as shown below.
 ![ssh node](images/ssh-node.png)

3. Copy and paste the following command to change the user from **opc** to **oracle** as shown below.
 ```bash
    <copy>sudo su - oracle</copy>
 ```
 ![change user](images/change-user.png)

4. Copy and paste the following command in the Cloud Shell to download the application. You will notice the **rcmweb.war** in the terminal.
 ```bash
    <copy>curl -O https://objectstorage.us-ashburn-1.oraclecloud.com/p/DngDhX3N6cSYkCOJdN04oEVpFNW4CZ-0AgJd6wseEpnOTyDVDmViRtD9lLs9We-Z/n/ocloud200/b/ocw24assets/o/rcmweb.war
    ls  ~</copy>
 ```
 ![download app](images/download-app.png)

5. Copy and paste the following command to set up the WebLogic Domain environment to deploy the application.
 ```bash
    <copy>. /u01/app/oracle/middleware/oracle_common/common/bin/setWlstEnv.sh</copy>
 ```

5. Copy and paste the following command in the text file and replace the Value for **`USERNAME`** and **`WLS_NODE_IP`**.
 ```bash
    <copy>java weblogic.Deployer -adminurl 't3://<WLS_NODE_IP>:9071' -username weblogic -password cloudworld24 -deploy -name RCMWeb -targets <USERNAME>_cluster ~/rcmweb.war</copy>
 ```

6. Paste the modified command to deploy the application in Cloud Shell as shown below.
 ![deploy app](images/deploy-app.png)

7. Enter **exit** twice to go back to the local user in the Cloud Shell environment as shown below.
 ![back cloudshell](images/back-cloudshell.png)



You may now proceed to the next lab.

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, July 2024