# Clean Up the Workshop

## Introduction

In this lab, you will remove the OCI and AWS resources in dependency order. Cleaning up prevents continued charges and avoids leaving active credentials in the AWS account.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Remove Oracle--AWS Interconnect
* Destroy both OCI Resource Manager stacks
* Delete the generated AWS access key
* Delete the AWS CloudFormation stack

## Task 1: Delete Oracle--AWS Interconnect

1. Delete the managed interconnect using the AWS and OCI provider consoles.

2. Wait until the connection is removed before destroying the OCI network foundation.

## Task 2: Destroy the OCI Runner Stack

1. In OCI Resource Manager, open the `private-s3-runner` stack.

2. Click **Destroy** and confirm the action.

3. Wait for the job to finish with a status of **Succeeded**.

## Task 3: Destroy the OCI Network Stack

1. In OCI Resource Manager, open the `private-s3-oci-network` stack.

2. Click **Destroy** and confirm the action.

3. Wait for the job to finish with a status of **Succeeded**.

## Task 4: Delete the AWS Access Key

1. In the AWS Management Console, open **IAM**.

2. Open the restricted lab runner user created by the CloudFormation stack.

3. On **Security credentials**, deactivate and delete the access key you created in Lab 1.

## Task 5: Delete the AWS Stack

1. In Amazon S3, open the workshop bucket and delete all objects, including `sample.csv` and `validation-result.txt`.

2. In AWS CloudFormation, select the `private-s3-aws-baseline` stack.

3. Click **Delete** and confirm the action.

4. Wait until CloudFormation removes the stack.

If CloudFormation cannot delete the S3 bucket because it is not empty, empty the bucket and retry the stack deletion.

## Summary

You removed the interconnect, OCI stacks, limited AWS credential, and AWS foundation. You have completed the workshop and cleaned up its resources.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
