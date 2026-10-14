# Create Oracle AWS Interconnect

## Introduction

In this module, you establish the managed Oracle--AWS Interconnect between the DRG and AWS Direct Connect gateway.

Estimated Time: 15 minutes

## Task 1: Create the OCI side

1. In the OCI Console navigation menu, open **Networking** → **Customer connectivity** → **FastConnect**.

    ![Navigate to FastConnect](images/navigatefastconnect.png "Navigate to FastConnect")

2. At the top of the FastConnect page, use the **Compartment** selector to choose **your assigned lab compartment**. Confirm that the compartment name matches the one provided by the lab administrator. The DRG created in the previous module is in this compartment.

3. Click **Create FastConnect**. Under **FastConnect type**, select **FastConnect interconnect**, then select **Oracle Interconnect for AWS**.

    ![Select Oracle Interconnect for AWS](images/fastconnectinterconnectselection.png "Select Oracle Interconnect for AWS")

4. Select **Configure in OCI first**.

    ![Configure the OCI side first](images/fastconnectocifirst.png "Configure the OCI side first")

5. For the DRG, select the DRG created by the OCI network Resource Manager stack. Its OCID is the `drg_ocid` value recorded in the **Verify OCI Lab Environment** module.

6. Enter the 12-digit **AWS account ID** for the AWS event account used in this lab. Obtain it from the lab administrator, or sign in to the AWS Console and open the account menu in the upper-right corner to copy the account ID. Verify the number before proceeding; it determines which AWS account can accept this Interconnect request.

7. Review the values, then click **Create**.

8. Wait for the virtual circuit to show **PENDING PARTNER**.

    ![Virtual circuit pending partner acceptance](images/pendingpartner.png "Virtual circuit pending partner acceptance")

9. Copy the **activation key**. Keep it available only long enough to complete Task 2; it is required to accept the connection in AWS.

    ![Copy the activation key](images/copykey.png "Copy the activation key")

## Task 2: Accept the AWS side

1. In the AWS Console, search for and open **Direct Connect**.

    ![Navigate to Direct Connect](images/navigatedirectconnect.png "Navigate to Direct Connect")

2. In the Direct Connect navigation pane, choose **AWS Interconnect**.

    ![Navigate to AWS Interconnect](images/navigateinterconnect.png "Navigate to AWS Interconnect")

3. Choose **Accept multicloud Interconnect**.

    ![Accept a multicloud Interconnect](images/acceptconnection.png "Accept a multicloud Interconnect")

4. Paste the OCI activation key copied in Task 1, then select the lab Direct Connect gateway from the `DirectConnectGatewayId` value recorded in the **Verify AWS Lab Environment** module.

    ![Configure the AWS Interconnect](images/configureawsinterconnect.png "Configure the AWS Interconnect")

5. Enter a description and add the `LabUser` tag value from the CloudFormation outputs when the console offers tags. Review the connection details and accept the connection.

    ![Confirm the AWS Interconnect request](images/confirmation.png "Confirm the AWS Interconnect request")

6. Wait for AWS to show the connection in **Pending partner** status while Oracle completes provisioning.

    ![AWS Interconnect pending partner status](images/awspendingpartner.png "AWS Interconnect pending partner status")

## Task 3: Verify the connection

1. Return to OCI FastConnect and wait for lifecycle state **PROVISIONED** and BGP state **UP**.

    ![OCI FastConnect provisioned](images/provisioned.png "OCI FastConnect provisioned")

2. In AWS Interconnect, confirm the connection is **Available**.

    ![AWS Interconnect available](images/available.png "AWS Interconnect available")

Do not continue until both providers report a healthy connection.

## Summary

The OCI DRG and AWS Direct Connect gateway are connected by Oracle--AWS Interconnect.
