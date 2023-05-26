# Provision the Infrastructure

## Introduction

In this lab, you will create a **compartment**, **dynamic groups**, **user group and policies**. Then you will create a **DevOps project** and its related resources using the Terraform in **OCI Code Editor**.

Estimated time: 10 minutes

### Objectives

In this lab, you will:

* Open Code Editor to download the Terraform script.
* Provision the compartment, dynamic groups, user group and policies.
* Provision the resources required for the DevOps project

### Prerequisites

* An Oracle Free Tier(Trial), Paid or LiveLabs Cloud Account
* Familiarity with compartments, dynamic groups, user groups and policies

## Task 1: Open Code Editor and download the source code

1. In Cloud Console, click the *Developer tools* icon as shown and then click *Code Editor*.
![open code editor](images/open-codeeditor.png)

2. Click *Terminal*-> *New Terminal* to open the terminal. During the workshop, you will be asked to open a new terminal. In this way, you can open a new terminal in Code Editor.
![open terminal](images/open-terminal.png)

3. Copy and paste the following command to the terminal to download the source code. This source code contains the terraform scripts which create the OCI resources required for this workshop. 

    ```bash
    <copy>curl -LSs https://objectstorage.uk-london-1.oraclecloud.com/p/p6rJ_WzkJq_THpuLmDPqyX0gcHYj-R_G25A4W0tMTsoV5pDbeQoqgegIK_PL6395/n/lrv4zdykjqrj/b/ankit-bucket/o/devops_helidon_to_instance_ocw_hol.zip >~/devops_helidon_to_instance_ocw_hol.zip
    unzip ~/devops_helidon_to_instance_ocw_hol.zip</copy>
    ```
![download source code](images/download-sourcecode.png)

4. To open the source code *`devops_helidon_to_instance_ocw_hol`* in the workspace, click *File*-> *Open*.
![open source code](images/open-sourcecode.png)

5. Select the *`devops_helidon_to_instance_ocw_hol`* in your home directory and click *Open*.
![open devops](images/open-devops.png)

6. Click the file name *terraform.tfvars* inside the *init* folder of *`devops_helidon_to_instance_ocw_hol`* as shown. You can see we have four variables (**`tenancy_ocid`**, **region**, **`compartment_ocid`**, **`user_ocid`** ) for which we need to provide the values. 
![open tfvars](images/open-tfvars.png)

7. In your browser, open a **new tab** for [Cloud Console](https://cloud.oracle.com/). We will use this tab to get the value of the above variables.

8. To get the **`tenancy_ocid`**, Click *User icon* and then click *Tenancy* as shown.
![get tenancy ocid](images/get-tenancyocid.png)

9. Click *Copy* to copy the **OCID** for tenancy and paste it in *terraform.tfvars* file as the value of *`tenancy_ocid`*.
![copy tenancy ocid](images/copy-tenancyocid.png)

10. You can find your home region name in the Cloud console as shown below. Then open the [URL](https://docs.oracle.com/en-us/iaas/Content/Registry/Concepts/registryprerequisites.htm#Availab) to find endpoints of this region. For example, in my case, *India South(Hyderabad)* is the home region and its endpoint is *ap-hyderabad-1*. Paste the end point of your home region in *terraform.tfvars* file as the value of *region*.
![home region](images/home-region.png)
![end points](images/end-points.png)

11. To get the **`user_ocid`**, click *User icon* and then click *My profile* as shown.
![my profile](images/my-profile.png)

12. Click *Copy* to copy the **OCID** for the user and paste it in *terraform.tfvars* file as the value of *`user_ocid`*.
![copy user ocid](images/copy-userocid.png)

13. Finally, your *terraform.tfvars* should look like this. Leave the value of *`compartment_ocid`* as it is. We will replace the value, once the compartment will be created as part of Task 2.
![init tfvars](images/init-tfvars.png)

## Task 2: Create a Compartment, Dynamic Groups, User Group and Policies

The goal of this task is to prepare the environment for the DevOps setup by creating a Compartment, Dynamic Group, User Group and policies. This section requires a user with administrator privilege. If you don't have it, make sure to request another user with such privilege to run this for you.

1. In the terminal, copy and paste the following command to navigate to the *init* folder.
    ```bash
    <copy>cd ~/devops_helidon_to_instance_ocw_hol/init/</copy>
    ```

2. In Code Editor, you can view various files in the *init* folder. These are the terraform scripts which create the compartment, dynamic groups, user group and policies.
![init files](images/init-files.png)

3. Copy and paste the following commands to provision the compartment, dynamic groups, user group and policies. 
    ```bash
    <copy>terraform init
    terraform plan
    terraform apply -auto-approve</copy>
    ```
    you will see output similar to below. Please observe the output to know what the terraform script creates. Also, you can refer the code to see its implementation.
    ![init created](images/init-created.png)

## Task 3: Create a DevOps project and its resources

1. In the terminal, copy and paste the following command to navigate to the *main* folder.
    ```bash
    <copy>cd ~/devops_helidon_to_instance_ocw_hol/main/</copy>
    ```

2. Copy and paste the following command to update the *terraform.tfvars* inside *main* folder. This will update the value of **`tenancy_ocid`**, **region**, and **`user_ocid`**.
    ```bash
    <copy>cp ../init/terraform.tfvars .</copy>
    ```
3. Copy and paste the following command to update the **compartment_ocid** of a newly created compartment in  *terraform.tfvars* inside *main* folder. 
    ```bash
    <copy>.../utils/update_compartment.sh</copy>
    ```

4. Copy and paste the following command in the terminal to provision all the DevOps resources.
    ```bash
    <copy>terraform init
    terraform plan
    terraform apply -auto-approve</copy>
    ```

    > This will provide the following resources required for DevOps:
    * **OCI DevOps Service** 
        * **OCI DevOps Project** that will contain all the DevOps components needed for this project.
        * **OCI Code Repository** that will host the Application source code project.
        * **DevOps Build Pipeline** with the following stages:
            * **Manage Build** - executes steps to download JDK20, maven and building the Helidon application
            * **Deliver Artifacts** - Uploads the built Helidon app and the Deployment to the Artifact Repository
            * **Trigger Deployment** - Triggers the Deployment Pipeline
        * **DevOps Deployment Pipeline** that will perform the following on the target environment:
            * Download JDK20
            * Install OCI CLI and use it to download the Application Deliverable
            * Run the Application
        * **DevOps Instance Group environment** that will be used by the Deployment Pipeline to identify the created OCI Compute Instance as the deployment target.
        * **DevOps Trigger** that will invoke the pipeline lifecycle from start to finish when a push event occurs on the OCI Code Repository.
    * **OCI Artifact Registry**
        * **OCI Artifact Repository** that will host the built Helidon App Binaries and Deployment Manifest as versioned artifacts.
    * **OCI Platform**
        * **OCI Compute Instance** that opens port 8080 from the firewall. This is where the application will be eventually deployed.
    * **OCI Virtual Cloud Network (VCN) with Security List** containing an Ingress that opens port 8080. Port 8080 is where the Helidon application will be accessed from. The OCI VCN will be used by the OCI Compute Instance for its network needs.

5. Diagram below depicts how the DevOps setup will work:
    ![devops diagram](images/devops-diagram.png)

6. You will get a similar output as shown below. You need to copy these values and paste them into a text file. So we can use it later in the workshop.
    ![tf output](images/tf-output.png)


You may now **proceed to the next lab.**

## Acknowledgements

* **Author** -  Keith Lustria
* **Contributors** - Ankit Pandey, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, May 2023
