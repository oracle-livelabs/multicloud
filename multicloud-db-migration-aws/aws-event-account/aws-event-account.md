# AWS Event Account

## Introduction

Sign in to the temporary AWS account supplied for the workshop and confirm that you are using the assigned identity and Region.

Estimated Time: 5 minutes

### Objectives

In this lab, you will:

- Retrieve the AWS event credentials from LiveLabs
- Sign in to the AWS Management Console as the assigned IAM user
- Confirm the signed-in identity and workshop Region

## Task 1: Retrieve the AWS Event Credentials

1. On the LiveLabs workshop page, select **View Login Info**.

2. Locate your reservation information. Keep **View Login Info** open so you can copy your assigned values. The reservation contains these 12 fields:

    | Field | What to use it for |
    | --- | --- |
    | Username | Your AWS IAM user name, such as `labuser101`. |
    | Password | The AWS console password for your assigned IAM user. |
    | AWS Account ID | The workshop account: `209197637745`. |
    | EC2 Instance ID | The assigned EC2 instance to connect to during the workshop. |
    | Target Autonomous AI Database | The display name of your assigned target database, such as `ADBSlab101`. |
    | AWS Login | Your AWS console sign-in URL, including `?region=us-west-2`. |
    | AWS Region | The workshop Region: `us-west-2`, displayed as **US West (Oregon)**. |
    | Source SYSTEM Password | The source database administrative password requested by ZDM. |
    | Source GGADMIN Password | The source GoldenGate database user password requested by ZDM. |
    | Target ADMIN Password | The target Autonomous Database administrative password requested by ZDM. |
    | Target GGADMIN Password | The target GoldenGate database user password requested by ZDM. |
    | GoldenGate oggadmin Password | The GoldenGate hub administrative password requested by ZDM. |

    Use **Username** and **Password** to sign in to AWS. The five database and GoldenGate password fields are for later migration steps, not for AWS console sign-in.

    > **Note:** These credentials are temporary. Use only the account and resources assigned to you, and do not sign in as the AWS account root user.

## Task 2: Sign In to the AWS Management Console

1. Copy the **AWS Login** URL from your reservation information and open it in an incognito or private browser window to avoid using another AWS account's existing session. The provided URL includes the workshop Region:

    [Open the workshop AWS account in US West (Oregon)](https://209197637745.signin.aws.amazon.com/console?region=us-west-2)

2. The account-specific URL identifies the workshop account. If AWS prompts for **Account ID or alias**, enter the **AWS Account ID** from your reservation: `209197637745`.

3. In **IAM user name**, enter the **Username** from your reservation, such as `labuser101`. Use your assigned `labuserXXX` value, not the example unless it is your assignment.

4. In **Password**, paste the **Password** value shown in your reservation information. Do not use a database or GoldenGate password in this field.

5. Select **Sign in**. No separate account registration or password creation is needed for this step.

## Task 3: Confirm the Account and Region

1. After the AWS Console Home page opens, select the account menu in the upper-right corner.

2. Confirm that the account ID is **209197637745** and that the signed-in IAM user matches your reservation **Username** (`labuserXXX`).

3. Check the Region selector in the upper-right corner. It must show **US West (Oregon)**, with Region code **us-west-2**. If another Region is selected, choose **US West (Oregon)** before continuing.

4. Keep your reservation information available. Use **EC2 Instance ID** to identify your assigned source instance and **Target Autonomous AI Database** to identify your target by its display name, such as `ADBSlab101`. Always use your own assigned values.

5. Keep the AWS console open for the remaining labs.

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Reference** - [Sign in to the AWS Management Console as an IAM user](https://docs.aws.amazon.com/signin/latest/userguide/introduction-to-iam-user-sign-in-tutorial.html)
- **Last Updated By/Date** - Oracle LiveLabs, October 2026
