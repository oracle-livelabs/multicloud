# Verify OCI Lab Environment

## Introduction

In this module, you deploy the OCI network foundation into your assigned lab compartment, then validate the resources it created. The network stack creates the VCN, private subnets, network security groups (NSGs), route tables, DRG, and DNS forwarding configuration.

Estimated Time: 20 minutes

### Objectives

* Deploy the OCI network foundation with Resource Manager.
* Inspect the lab VCN, DRG, private subnet, and network security group.
* Validate the OCI network resources needed by the Interconnect and Autonomous AI Lakehouse modules.

## Task 1: Create and deploy the OCI network stack

1. Select **Deploy to Oracle Cloud** to open Resource Manager.

    <a class="tryit-button" href="https://cloud.oracle.com/resourcemanager/stacks/create?region=us-ashburn-1&amp;zipUrl=https%3A%2F%2Fgithub.com%2Foracle-livelabs%2Fmulticloud%2Fraw%2Frefs%2Fheads%2Fmain%2Foci_aws_private_s3%2Fresource-manager-oci-network-rm.zip" target="_blank" rel="noopener noreferrer" style="display: inline-block; width: auto;">Deploy to Oracle Cloud</a>

2. On **Stack information**, select the **I have reviewed and accept the Oracle Terms of Use** checkbox. Wait for the stack title and description to appear.

    ![Oracle Terms of Use checkbox and Create in compartment selector outlined in red; identifying information is blurred.](images/resource-manager-terms.png)

3. Under **Create in compartment**, confirm that your assigned lab compartment is selected, then select **Next**.

4. On the **Configure variables** page, enter the values supplied for you in the LiveLabs portal by the lab administrator. Use your assigned values rather than values from another learner.

    | Variable | What to enter |
    | --- | --- |
    | `region` | For this lab, use `us-ashburn-1`. This value is preselected; leave it unchanged. |
    | **Lab compartment** | This field should be preselected. Confirm that it is your assigned learner compartment, which follows the naming convention `<Username>-COMPARTMENT`; do not select the tenancy/root compartment. |
    | `name_prefix` | Your assigned lab name prefix, if one is provided. |
    | `vcn_cidr`, `adb_subnet_cidr`, `dns_subnet_cidr` | Keep the default values. |
    | `aws_vpc_cidr` | The CIDR of your assigned AWS lab VPC. |
    | `aws_resolver_inbound_ip` | One private IP address of the Route 53 Resolver **inbound** endpoint. Find this value in the administrator-supplied values in the LiveLabs portal. This lets OCI forward S3 DNS queries to AWS through the private path. |
    | `s3_dns_domain` | Keep the default value: `s3.us-east-1.amazonaws.com`. |
    | `admin_client_cidr` | Enter your workstation's public IP address in `/32` CIDR format, for example `203.0.113.25/32`. On Windows, run `ipconfig` and identify the IPv4 address to use. On macOS, run `curl ifconfig.me`. Append `/32` to the address. If Windows shows only a private address such as `10.x.x.x`, `172.16-31.x.x`, or `192.168.x.x`, use your network's public egress IP instead. Do not use `0.0.0.0/0`. |

5. Select **Next**. On the **Review** page, review the configuration, leave **Run apply** selected, then select **Create**.

6. Open the apply job that Resource Manager starts automatically. Wait for the job status to show **Succeeded** before continuing. If the job fails, open the job, review its logs, correct the input identified in the error, and run **Apply** again.

## Task 2: Validate the OCI network resources

1. From the OCI Console navigation menu, open **Networking** → **Virtual cloud networks**.

    ![Navigate to Virtual Cloud Networks](images/ocinavigatevcn.png "Navigate to Virtual Cloud Networks")

2. Confirm that the compartment selector is set to your assigned lab compartment. Select the VCN created by the network stack.

    ![Select the lab VCN](images/selectvcn.png "Select the lab VCN")

3. On the VCN details page, select **Gateways**. Confirm the Dynamic Routing Gateway (DRG) created for the lab is attached and available.

    ![Inspect the VCN DRG attachment](images/vcndrg.png "Inspect the VCN DRG attachment")

4. Select **Security** → **Network security groups**. Confirm that the Autonomous AI Lakehouse NSG with **`DB`** in its name is present.

    ![Inspect the VCN network security group](images/vcnnsg2.png "Inspect the VCN network security group")

5. Select **Subnets**. Confirm that the Autonomous Database subnet with **`DB`** in its name is private and has the expected CIDR. Open its route table and confirm that the AWS VPC CIDR route targets the DRG.

    ![Inspect the private Autonomous Database subnet](images/vcnsubnet.png "Inspect the private Autonomous Database subnet")

## Summary

Your OCI network foundation, DRG, private subnet, NSG, and DNS forwarding configuration are ready. The Autonomous AI Lakehouse stack will let you select the VCN, subnet, and NSG by name from drop-down lists.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - Arun Ramakrishnan, October 2026
