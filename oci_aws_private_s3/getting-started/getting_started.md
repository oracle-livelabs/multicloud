# Getting Started

## Introduction

In this lab, you will prepare your AWS and OCI environments and record the values used throughout the workshop.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Select the required AWS and OCI regions
* Record the OCI compartment OCID
* Choose a globally unique S3 bucket name
* Confirm that the default network ranges do not overlap existing networks

## Task 1: Open Both Cloud Consoles

1. Sign in to the AWS Management Console and the OCI Console in separate browser tabs.

2. In AWS, select **US East (N. Virginia)** (`us-east-1`) from the region menu.

3. In OCI, select **US East (Ashburn)** (`us-ashburn-1`).

4. Confirm that your AWS identity can create CloudFormation, VPC, Direct Connect, S3, and IAM resources.

5. Confirm that your OCI identity can create Resource Manager, Networking, FastConnect, and Compute resources in the lab compartment.

## Task 2: Record the OCI Compartment OCID

1. In the OCI Console, open the **Profile** menu and select **Tenancy**, or open the navigation menu and select **Identity & Security**, then **Compartments**.

2. Select the compartment where you will create the workshop resources.

3. Copy the compartment OCID and store it temporarily in a secure text file. You will use it in both OCI Resource Manager stacks.

## Task 3: Choose the Network Ranges

The workshop templates use these default CIDR blocks:

| Cloud | Default CIDR |
|---|---|
| OCI | `10.10.0.0/16` |
| AWS | `10.20.0.0/16` |

1. Check the networks already connected to your OCI and AWS environments.

2. Confirm that the two default ranges do not overlap each other or any network that must route to the workshop environment.

3. If a conflict exists, choose two non-overlapping private CIDR blocks. Use the replacement values consistently in the AWS and OCI deployments.

## Task 4: Choose an S3 Bucket Name

1. Choose a globally unique, lowercase S3 bucket name.

    For example:

    ```text
    <copy>
    YOURINITIALS-private-s3-lab-2026
    </copy>
    ```

2. Record the name. You will provide it to the AWS CloudFormation stack.

S3 bucket names are shared globally across all AWS customers. If CloudFormation reports that the name is unavailable, choose a different name and deploy the stack again.

## Task 5: Understand the Normal Validation Path

The automated validation does not require Docker, Cloud Shell, Oracle Cloud Infrastructure Registry (OCIR), SSH, OCI Bastion, an Oracle Integration Connectivity Agent, or a public IP address on the runner VM.

The runner VM remains private. If you later need operating-system diagnostics, Lab 6 provides an optional OCI Bastion procedure.

## Summary

You have selected the required regions, recorded your compartment OCID and bucket name, and confirmed that the OCI and AWS network ranges do not overlap. You are ready to deploy the AWS foundation.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
