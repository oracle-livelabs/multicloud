# Deploy WebLogic Domain to Oracle Kubernetes Cluster (OKE)

## Introduction

In this lab, we deploy the WebLogic Domain to kubernetes cluster. In primary image section, we specify the oracle account credential. In auxiliary image section, we specify oracle cloud account credential. Here we also specify the replica for the cluster.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Deploy the WebLogic Domain to Kubernetes Cluster.

## Task 1: Deploy the WebLogic Domain to the Oracle Kubernetes Cluster

In this task, we deploy the Kubernetes custom resource for the WebLogic domain to Kubernetes Cluster.

1. Click **WebLogic domain** and copy and paste the following image tag in **Primary Image Tag** as shown.
    ```bash
    <copy>container-registry.oracle.com/middleware/weblogic:12.2.1.4-slim-ol8</copy>
    ```
    ![enter primary tag](images/enter-primary.png)

2. Scroll down, enter the following in Primary Image section, Enter *domain-secret* as *Image Pull Secret Name*, and Use Oracle account username and password in *Image Registry Pull Username* and *Image Registry Pull Password*. Enter your Oracle email id in *Image Registry Pull Email Address*. These are the same credential which you used to accept license for *weblogic* images in Oracle Container Registry.
    ![Primary Image Details](images/primary-image-details.png)
    > **For your information only:**<br>
    > We are pulling the image from the Oracle Container Registry, so we are specifying the credential, which we used to accept the license agreement for WebLogic Server Images.


3. Scroll down, in Auxiliary Image section, uncheck the box for **Specify Auxiliary Image Pull Credentials**.

4.  In *Clusters* section, click on *Edit* icon as shown.
    ![Cluster Resize](images/cluster-resize.png)

5. Enter *2* as *Replicas* and then Click *OK*. The size of replica decides the number of managed server in the *Running* state after successfull deployment of WebLogic Domain to Kubernetes cluster.
    ![Cluster Replicas](images/cluster-replicas.png)

6. In Datasources section, double click to edit *passwords* for two datasource. You can give *tiger* as password in both the datasources. Once done, click *Deploy Domain*.
    ![Datasoure Password](images/datasource-password.png)
    > This deploy WebLogic Domain test-domain to Kubernetes namespace *test-domain-ns*.

7. Once you see *WebLogic Domain Deployment to Kubernetes Complete* window, Click *OK*.
    ![Deployment Complete](images/deployment-complete.png)

8. Go back to terminal, Click *Activities* and select the *Terminal* window. Copy the following command and paste it terminal. You should see the similar output, where pod for introspector run first then for the Admin Server and later pods for managed server goes in the *Running* state.

    ````bash
    <copy>kubectl get pods -n test-domain-ns -w</copy>
    ````

    ![Pod Status](images/pod-status.png)

9. You can also get the domain status through *WebLogic Kubernetes Toolkit UI*. Go back to *WebLogic Kubernetes Toolkit UI* and click *Get Domain Status*.
    ![Domain Status](images/domain-status.png)

10. In Domain Status window, Scroll down to see status of all server pods then click *OK*.
    ![Server Status](images/server-status.png)

You may now proceed to the next lab.

## Acknowledgements
* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, October 2024