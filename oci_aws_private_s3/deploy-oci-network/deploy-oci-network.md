# Deploy the OCI Network Foundation

## Introduction

In this lab, you will use OCI Resource Manager to deploy the VCN, private subnet, DRG, Service Gateway, routing, and network security resources required by the private test runner.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

* Create an OCI Resource Manager stack from the provided Terraform ZIP file
* Plan and apply the network foundation
* Record the DRG, private subnet, and NSG OCIDs

## Task 1: Download the OCI Network Stack

1. Download the OCI network Resource Manager package:

    [Download `resource-manager-oci-network-rm.zip`](https://c4u04.objectstorage.us-ashburn-1.oci.customer-oci.com/p/EcTjWk2IuZPZeNnD_fYMcgUhdNDIDA6rt9gaFj_WZMiL7VvxPBNMY60837hu5hga/n/c4u04/b/livelabsfiles/o/labfiles/resource-manager-oci-network-rm.zip)

2. Do not extract the ZIP file. It is a flat Resource Manager archive and is ready to upload.

## Task 2: Create the Network Stack

1. In the OCI Console, open the navigation menu and select **Developer Services**, then **Resource Manager**, and then **Stacks**.

2. Click **Create stack**.

3. Select **My configuration** and **.Zip file**.

4. Upload `resource-manager-oci-network-rm.zip`.

5. Leave **Working directory** blank.

6. Name the stack `private-s3-oci-network` and select Terraform **1.5.x**.

7. Click **Next**.

8. Enter your OCI lab compartment OCID for `compartment_ocid`.

9. Keep the default region, CIDRs, and name prefix unless you selected replacement CIDRs in Getting Started.

10. Create the stack.

## Task 3: Plan and Apply the Network Stack

1. On the stack details page, click **Plan** and confirm the action.

2. Wait for the Plan job to finish with a status of **Succeeded**.

3. Review the Plan log and confirm that it will create the intended networking resources.

4. Click **Apply** and confirm the action.

5. Wait for the Apply job to finish with a status of **Succeeded**.

## Task 4: Record the Network Outputs

1. Open **Outputs** on the Resource Manager stack.

2. Record these values:

    | Output | Used for |
    |---|---|
    | `drg_ocid` | Connecting Oracle--AWS Interconnect |
    | `runner_subnet_ocid` | Placing the test runner in the private subnet |
    | `runner_nsg_ocid` | Applying the runner's network security rules |

The stack creates a regional private subnet with no public IP path. This is intentional.

## Summary

You deployed the OCI network foundation and recorded the DRG, private subnet, and NSG OCIDs. Next, you will authorize the managed interconnect in AWS and OCI.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
