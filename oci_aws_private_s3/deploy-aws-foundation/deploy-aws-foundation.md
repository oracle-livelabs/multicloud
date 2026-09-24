# Deploy the AWS Foundation

## Introduction

In this lab, you will deploy the AWS networking and S3 resources, upload the test data, create a limited access key, and build the private S3 endpoint hostname used by the OCI runner.

The CloudFormation template creates an AWS VPC, two private endpoint subnets, a Virtual Private Gateway (VGW), a Direct Connect gateway and association, an endpoint-subnet return route, an S3 Interface VPC Endpoint, an endpoint security group, an S3 bucket, an IAM user, and restrictive IAM and endpoint policies.

Estimated Time: 20 minutes

### Objectives

In this lab, you will:

* Deploy the AWS CloudFormation template
* Upload `sample.csv` to the S3 bucket
* Create an access key for the restricted IAM user
* Construct the bucket-specific S3 interface endpoint hostname

## Task 1: Download the CloudFormation Template

1. Download the AWS CloudFormation template to your computer:

    [Download `private-s3-aws-baseline.yaml`](https://c4u04.objectstorage.us-ashburn-1.oci.customer-oci.com/p/EcTjWk2IuZPZeNnD_fYMcgUhdNDIDA6rt9gaFj_WZMiL7VvxPBNMY60837hu5hga/n/c4u04/b/livelabsfiles/o/labfiles/private-s3-aws-baseline.yaml)

2. Keep the filename `private-s3-aws-baseline.yaml`.

## Task 2: Create the AWS Stack

1. In the AWS Management Console, open **CloudFormation**.

2. Select **Stacks**, then **Create stack**, and then **With new resources (standard)**.

3. Select **Choose an existing template**, then select **Upload a template file**.

4. Choose the downloaded `private-s3-aws-baseline.yaml` file and click **Next**.

5. Enter `private-s3-aws-baseline` for the stack name.

6. For `LabBucketName`, enter the globally unique bucket name you selected in Getting Started.

7. Keep the default CIDRs unless you selected replacement network ranges. If you changed them, confirm that all dependent CIDRs are consistent and non-overlapping.

8. Click **Next** twice.

9. On the review page, acknowledge that CloudFormation can create IAM resources, and then click **Submit**.

10. Wait until the stack status is **CREATE_COMPLETE**. Resolve any rollback before continuing.

## Task 3: Record the Stack Outputs

1. Open the **Outputs** tab for the `private-s3-aws-baseline` stack.

2. Record these values:

    | Output | Used for |
    |---|---|
    | `DirectConnectGatewayId` | Creating Oracle--AWS Interconnect |
    | `S3BucketName` | Uploading and validating objects |
    | `S3InterfaceEndpointId` | Confirming the restricted private path |
    | `S3InterfaceEndpointDnsEntries` | Building the endpoint hostname |
    | `LabRunnerUserArn` | Finding the restricted IAM user |

## Task 4: Upload the Test CSV File

1. Create a local file named `sample.csv` with exactly this content:

    ```csv
    <copy>
    id,name,region
    1,Ada,us-east-1
    2,Linus,us-east-1
    </copy>
    ```

2. In the AWS Management Console, open **S3**.

3. Open the bucket identified by `S3BucketName`.

4. Click **Upload**, then **Add files**, and choose `sample.csv`.

5. Upload the file to the bucket root. Do not place it in a folder.

## Task 5: Create the Limited AWS Access Key

1. In the AWS Management Console, open **IAM**.

2. Select **Users**, then open the user identified by `LabRunnerUserArn`.

3. Open **Security credentials** and click **Create access key**.

4. Select **Application running outside AWS**, acknowledge the recommendation, and create the key.

5. Copy the **Access key ID** and **Secret access key** immediately and store them securely. The secret access key is displayed only once.

    > **Warning:** Do not place these credentials in source control, email, screenshots, tickets, or chat messages.

The generated IAM policy permits only `GetObject` on `sample.csv` and `PutObject` on `validation-result.txt`, and only when the request uses the S3 interface endpoint.

## Task 6: Build the S3 Endpoint Hostname

1. Return to the CloudFormation stack's **Outputs** tab.

2. In `S3InterfaceEndpointDnsEntries`, find the entry whose DNS name begins with `*.bucket.vpce-`.

3. If AWS shows the entry as `HOSTED_ZONE_ID:DNS_NAME`, remove the `HOSTED_ZONE_ID:` prefix.

4. Replace the `*` with the exact value of `S3BucketName`.

    The completed hostname has this form:

    ```text
    <copy>
    YOUR_BUCKET.bucket.vpce-0123456789abcdef-suffix.s3.us-east-1.vpce.amazonaws.com
    </copy>
    ```

5. Record the completed hostname for the runner deployment.

The `.bucket.` component is required. A hostname in the form `YOUR_BUCKET.vpce-...` produces a TLS certificate hostname mismatch.

## Summary

You deployed the AWS foundation, uploaded the test CSV file, created limited credentials, and constructed the bucket-specific private endpoint hostname. Next, you will deploy the OCI network foundation.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, September 2026
