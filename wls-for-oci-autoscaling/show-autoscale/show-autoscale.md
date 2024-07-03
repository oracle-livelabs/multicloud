# Generate load and show autoscaling 

## Introduction

Monitoring and managing performance is crucial for maintaining an efficient Oracle Cloud Infrastructure (OCI) environment. This lab will help you observe the alarms created by the WebLogic for the OCI stack and generate CPU load on the WebLogic Server. By doing so, you can effectively view the scale-out, ensuring your applications run smoothly under varying load conditions.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Observe the Alarms created by WebLogic for the OCI stack.
* Generate the CPU Load on the WebLogic Server to view scaleout.

### Prerequisites
This lab assumes you have the following:

* An Oracle Cloud account
* Created Stack: Oracle WebLogic Server Enterprise Edition BYOL

## Task 1: Observe the Alarms created by WebLogic for the OCI stack

In this task, we observe the Alarms created by the stack. We will see the Alarm Definitions and Alarm Data.

1. In OCI Console, Click **Hamburger menu** -> **Observability & Management** -> **Alarm Definitions** under **Monitoring** section.
 ![alarm menu](images/alarm-menu.png)

2. You will notice two alarm definitions, one for the **scalein** operation and the other for the **scaleout** operations. Click the alarm for the **scaleout** as shown below.
 ![scaleout enable](images/scaleout-enable.png)
    
3. Enable the Alarm for the scaleout alarm by checking the box as shown.
 ![scaleout checkbox](images/scaleout-checkbox.png)


4. Observe the Status of the Alarm that is in the **OK** state. As you see in the summary  **ProcessCpuLoad is greater than the threshold value of 0.8**. Scroll down to view the Alarm data.
 ![scaleout initial](images/scaleout-alarm-initial.png)
 ![scaleout alarm data](images/scaleout-alarm-data.png)

    > As there is no load on the WebLogic Cluster, you may see the values less than **.8** for the **ProcessCpuLoad**, that is why the **scaleout** alarm is in **Ok** state.


## Task 2: Generate the CPU Load on the WebLogic Server

In this task, we execute files downloaded in lab 2. This file enhances the ProcessCpuLoad and triggers the Scaleout Alarm. Which will increase the node count from 1 to 2. As soon as the load trigger the Scaleout alarm, we terminate the execution of the generating file.

1. Copy and paste the following command in the text file and replace the **`LOAD_BALANCER_IP`** with the load balancer public IP.
 ```bash
    <copy>PATH=~/apache-jmeter-5.6.3/bin:$PATH
    cd ~/autoscale-workshop
    python3 jmeterrunner.py -l <LOAD_BALANCER_IP> -n 2 -s CpuTime</copy>
 ```


2. Paste the modified command in the Cloud Shell to Create CPU Load in WebLogic Cluster as shown below.
 ![generate load](images/generate-load.png)

3. Go back to Alarm data for the **scaleout** alarm, you will see the rise in ProcessCpuLoad as shown below.
 ![load increases](images/increase-load.png)
    
    > You need to wait till the ProcessCpuLoad is more than **.8** for a period of more than **five minutes**.
 ![load five](images/load-five.png)

4. As you see the **scaleout** alarm is in a **firing** state, go back to Cloud Shell to terminate the load generate process by entering **`Ctrl+C`** in the Cloud Shell as shown below.
 ![scaleout firing](images/scaleout-firing.png)
 ![stop load](images/stop-load.png)

5. You will also receive the email about the scaleout operation in the email ID provided during stack creation as shown below.
 ![scaleout email](images/scaleout-email.png)

6. You will also receive the email about the **Scaling Job Completed** as shown below.
 ![scaleout complete](images/scaleout-complete.png)

You may now proceed to the next lab.
    

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, July 2024