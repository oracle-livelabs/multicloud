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

2. Locate the AWS account details. Keep the panel open so you can copy the values when prompted. Depending on the event, the panel can include:

    - AWS console sign-in URL
    - AWS account ID or account alias
    - IAM user name
    - Password
    - Assigned AWS Region

> **Note:** These credentials are temporary. Use only the account and resources assigned to you, and do not sign in as the AWS account root user.

## Task 2: Sign In to the AWS Management Console

1. If **View Login Info** provides an AWS console sign-in URL, open that URL in a new browser tab. Otherwise, open the [AWS Management Console](https://console.aws.amazon.com/).

2. If AWS asks which identity to use, select **IAM user**.

3. If prompted, copy the AWS account ID or account alias from **View Login Info**, paste it into the sign-in page, and continue.

4. Copy the IAM user name and password from **View Login Info**, paste them into the corresponding fields, and select **Sign in**.

5. If AWS requires a password change, enter the temporary password as the current password and create a new password that meets the displayed requirements. Keep the new password available for the remainder of the workshop.

6. Complete multifactor authentication only if the event credentials or facilitator instruct you to do so.

## Task 3: Confirm the Account and Region

1. After the AWS Console Home page opens, select the account menu in the upper-right corner.

2. Confirm that the displayed account ID or alias and IAM user match the values assigned to you.

3. In the Region selector, choose the AWS Region provided in **View Login Info** or by the workshop facilitator.

4. Keep the AWS console open for the remaining labs.

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Reference** - [Sign in to the AWS Management Console as an IAM user](https://docs.aws.amazon.com/signin/latest/userguide/introduction-to-iam-user-sign-in-tutorial.html)
- **Last Updated By/Date** - Oracle LiveLabs, October 2026
