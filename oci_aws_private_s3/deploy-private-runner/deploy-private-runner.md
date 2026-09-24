# Deploy the Private OCI Test Runner

## Introduction

In this lab, you will deploy a private OCI compute instance with Resource Manager. At first boot, the instance runs an automated test that reads `sample.csv` and writes `validation-result.txt` through the Amazon S3 Interface VPC Endpoint.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

* Create the runner Resource Manager stack
* Supply the OCI network outputs and restricted AWS credentials
* Plan and apply the runner stack
* Allow the first-boot validation to complete

## Task 1: Download the Runner Stack

1. Download the OCI runner Resource Manager package:

    [Download `resource-manager-private-s3-runner-rm.zip`](https://c4u04.objectstorage.us-ashburn-1.oci.customer-oci.com/p/EcTjWk2IuZPZeNnD_fYMcgUhdNDIDA6rt9gaFj_WZMiL7VvxPBNMY60837hu5hga/n/c4u04/b/livelabsfiles/o/labfiles/resource-manager-private-s3-runner-rm.zip)

2. Do not extract the ZIP file. It is a flat Resource Manager archive and is ready to upload.

## Task 2: Create the Runner Stack

1. In the OCI Console, open **Developer Services**, then **Resource Manager**, and then **Stacks**.

2. Click **Create stack**.

3. Select **My configuration** and **.Zip file**.

4. Upload `resource-manager-private-s3-runner-rm.zip`.

5. Leave **Working directory** blank.

6. Name the stack `private-s3-runner` and select Terraform **1.5.x**.

7. Click **Next**.

## Task 3: Enter the Runner Variables

Enter these values in the stack variables:

| Variable | Value |
|---|---|
| `compartment_ocid` | Your OCI lab compartment OCID |
| `subnet_ocid` | `runner_subnet_ocid` from Lab 2 |
| `network_security_group_ocid` | `runner_nsg_ocid` from Lab 2 |
| `s3_bucket_name` | `S3BucketName` from Lab 1 |
| `s3_endpoint_host` | The completed `YOUR_BUCKET.bucket.vpce-...` hostname from Lab 1 |
| `aws_access_key_id` | The access key ID from Lab 1 |
| `aws_secret_access_key` | The secret access key from Lab 1; mark it sensitive if that option is available |
| `ssh_public_key` | Leave blank for the normal validation path |

The runner receives only the restricted AWS credentials created by the CloudFormation stack. Do not use a general-purpose or administrator access key.

## Task 4: Plan and Apply the Runner Stack

1. Finish creating the stack.

2. On the stack details page, click **Plan** and confirm the action.

3. Wait for the Plan job to finish with a status of **Succeeded**.

4. Review the planned resources.

5. Click **Apply** and confirm the action.

6. Wait for the Apply job to finish with a status of **Succeeded**.

7. After the VM is running, wait another three to five minutes for the first-boot test to finish.

The cloud-init script runs once when the instance first boots. It reads the S3 CSV through the private endpoint and writes the validation object.

## Summary

You deployed the private OCI runner and allowed its first-boot test to complete. Next, you will verify the result in Amazon S3.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
