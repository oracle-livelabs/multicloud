# Establish Oracle--AWS Interconnect

## Introduction

In this lab, you will authorize the managed interconnect in AWS and OCI. This cross-cloud handoff requires account-specific approval in both providers and is therefore completed manually.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

* Create a multicloud interconnect request in AWS
* Use the provider activation key to create the FastConnect connection in OCI
* Confirm that the connection is provisioned and BGP is up

## Task 1: Create the AWS Interconnect Request

1. In the AWS Management Console, open **Direct Connect**.

2. Select **AWS Interconnect**, then click **Create multicloud interconnect**.

3. Select **Oracle Cloud Infrastructure** as the cloud provider.

4. Select AWS **US East (N. Virginia)** (`us-east-1`) and OCI **US East (Ashburn)** when prompted.

5. Select the Direct Connect gateway identified by `DirectConnectGatewayId` in Lab 1.

6. Enter your OCI tenancy OCID if requested.

7. Create the request.

8. Copy the provider activation key and store it temporarily. You will use it in OCI.

## Task 2: Create the OCI FastConnect Connection

1. In the OCI Console, open the navigation menu and select **Networking**, then **FastConnect**.

2. Click **Create FastConnect**.

3. Select **FastConnect Interconnect**.

4. Select **Configured in AWS first**.

5. Paste the provider activation key from AWS.

6. Select the DRG identified by `drg_ocid` in Lab 2.

7. Create the connection.

## Task 3: Verify the Interconnect

1. In OCI, monitor the FastConnect connection until its lifecycle state is **Provisioned** and its BGP state is **Up**.

2. In AWS, confirm that the multicloud interconnect is active.

Provisioning can take several minutes. Both provider consoles must show a healthy connection before you deploy the test runner.

This workshop uses the managed Oracle--AWS Interconnect workflow. Do not create an ordinary customer Direct Connect connection or a private virtual interface for this environment.

## Summary

You authorized Oracle--AWS Interconnect in both cloud accounts and verified that BGP is up. Next, you will deploy the private OCI test runner.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
