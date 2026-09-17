# Validate the Private S3 Path

## Introduction

In this lab, you will confirm that the private OCI runner read the source CSV and wrote a result to Amazon S3 through the S3 Interface VPC Endpoint. You will also learn how to run the test again without rebuilding the network foundations.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Verify the validation result in the S3 bucket
* Relate the result to the endpoint-restricted AWS policies
* Re-create only the disposable runner when another test is required

## Task 1: Verify the Result Object

1. In the AWS Management Console, open **S3**.

2. Open your workshop bucket and refresh the object list.

3. Confirm that `validation-result.txt` exists at the bucket root.

4. Open `validation-result.txt`.

5. Confirm that the result contains:

    * A `SUCCESS` result
    * The CSV content or the `sample.csv` source key
    * A UTC timestamp

This is the end-to-end validation. The OCI VM has no public IP address, and the AWS policies require the request's `aws:SourceVpce` value to match the S3 interface endpoint created in Lab 1.

## Task 2: Run the Validation Again

Cloud-init runs only when the VM first boots. Updating variables on an existing runner does not execute the test again.

1. Delete `validation-result.txt` from the S3 bucket so the next result is unambiguous.

2. In OCI Resource Manager, open the `private-s3-runner` stack.

3. Click **Destroy** and confirm the job.

4. Wait for the Destroy job to finish with a status of **Succeeded**.

5. Click **Apply** and confirm the job.

6. Wait for the Apply job to finish with a status of **Succeeded**.

7. Allow three to five minutes for the new runner to boot, then refresh the S3 bucket.

8. Open the new `validation-result.txt` and confirm that it reports `SUCCESS` with a new timestamp.

Keep the AWS foundation, OCI network foundation, and active interconnect in place between test runs. Only the disposable runner must be re-created.

## Summary

You verified that a private OCI VM can read from and write to Amazon S3 through Oracle--AWS Interconnect and the S3 Interface VPC Endpoint. You also repeated the validation by re-creating only the runner.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
