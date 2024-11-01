# Deploy WebLogic Operator to Oracle Kubernetes Cluster (OKE)

## Introduction

In this lab, we authenticate OCI CLI using the browser, which will creates *.oci/config* file. As we will use kubectl to manage the cluster remotely using the *Local Access*. It needs a *kubeconfig* file. This kubeconfig file will be generated using the OCI CLI. Then we verify the connectivity to Kubernetes cluster from the WebLogic Kubernetes Toolkit UI. At last, we install the WebLogic Kubernetes Operator to Kubernetes cluster(OKE).

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Configure kubectl (Kubernetes Cluster CLI) to connect to Kubernetes Cluster.
* Verify Connectivity of WebLogic Kubernetes Toolkit UI to Kubernetes Cluster.
* Install the WebLogic Kubernetes Operator to Kubernetes Cluster.


## Task 1: Configure kubectl (Kubernetes Cluster CLI) to connect to WebLogic for OKE Stack [WLS for OKE]
In this Task, we creats the configuration file *.oci/config* and *.kube/config* in */home/opc* directory. This configuration file allow us to access Oracle Kubernetes Cluster (OKE) from this virtual machine.


1. In Firefox, open the cloud console, select the **Hamburger Menu** -> **Developer Services** -> **Kubernetes Clusters (OKE)** as shown.
    ![OKE Icon](images/oke-icon.png)

2. Click on the cluster name which your created in lab 2. and then click **Access Cluster**. 
    ![Access Cluster](images/access-cluster.png)


3. Select **Local Access** and then click on **Copy** as shown.
    ![Local Access](images/local-access.png)

4. Click on **Activities** and select the **Terminal**.
    ![Terminal](images/click-terminal.png)

5. Paste the copied command in the terminal. For **Do you want to create a new config file?**, Type **y** then press **Enter**. For **Do you want to create your config file by logging in through a browser?**, Type **y** then press **Enter**.
    ![OCI Config](images/oci-config.png)

6. In Firefox Browser, click on your active session.
    > You will see *Authorization Completed* as shown.
    ![Authorization Complete](images/authorization-complete.png)

9. In **Enter a passphrase for your private key**, leave it empty and press **Enter**.
    ![Empty Passphrase](images/empty-passphrase.png)

10. Use the upper arrow key to run the **oce ce ...** command again and re-run it multiple time, until you see the **New config written to the Kubeconfig file /home/opc/.kube/config**.
    ![Create KubeConfig](images/create-kubeconfig.png)

11. Copy and paste the following command to change the **~/.kube/config** file permissions.
    ```bash
    <copy>chmod 600 ~/.kube/config</copy>
    ```

## Task 2: View the Cloud Resources of WebLogic for OKE Stack [WLS for OKE]

1. In OCI Console, Click the **navigation menu**, select **Developer Services**. Under the Resource Manager group, click **Stacks**.

2. Select the **Compartment** that contains your stack.

3. Click the name of your stack.

4. Navigate to **Application Information** tab, You can view the resources created by your stack. Copy the **Bastion Instance Public IP** and paste it in text file. 
    ![copy bastion](images/copy-bastion.png)

## Task 3: Enable proxy configuration in the terminal

In this task, we enable the **ssh tunneling** from the remote desktop to Oracle Kubernetes Cluster nodes. 

1. Open the terminal, copy and paste the following command to create the private key file in the remote desktop.
    ```bash
    <copy>vi ~/.ssh/opc.key</copy>
    ```

2. Press **i** to enter in insert mode, and paste the content of private key in this file and press escape and then enter **:wq**
to save this file.

3. Copy and paste the following command to change the private key file permissions.
    ```bash
    <copy>chmod 600 ~/.ssh/opc.key</copy>
    ```

4. Copy the following command  and paste it in terminal and then replace **bastion-public-ip** with the public ip you copied in last task. 
    ```bash
    <copy>ssh -D 1088 -fCqN -i ~/.ssh/opc.key opc@bastion-public-ip</copy>
    ```

5. Open the **~/.kube/config** file and then copy and paste the following in this file as shown below.
    ```bash
    <copy>proxy-url: socks5://localhost:1088</copy>
    ```
    ![proxy config](images/proxy-config.png)


## Task 4: Verify Connectivity of WebLogic Kubernetes Toolkit UI to WebLogic for OKE Stack [WLS for OKE]
In this task, we verify the connectivity to *Oracle Kubernetes Cluster(OKE)* from the `WebLogic Kubernetes Toolkit UI` application.

1. Go back to WebLogic Kubernetes Tool Kit UI, Click *Activities* and select the WebLogic Kubernetes Tool Kit UI window. 

2. Click  *Kubernetes* ->  *Client Configuration* and then click *Verify Connectivity*.
    ![Verify Connectivity](images/verify-connectivity.png)

3. Once you see *Verify Kubernetes Client Connectivity Success* window, Click *Ok*.
    ![Successfully Connected](images/successfully-connected.png)

## Task 5: Update the WebLogic Kubernetes Operator to WebLogic for OKE Stack [WLS for OKE]
This section provides support for installing the WebLogic Kubernetes Operator (the “operator”) in the target Kubernetes cluster. 

1. Click **WebLogic Operator**. Specify the following configuration details  and click **Update Operator**.

    **Kubernetes Namespace** - The Kubernetes namespace to which to install the operator. Enter the vale **wko-operator-ns** as shown in screenshot below.

    **Kubernetes Service Account** - The Kubernetes service account for the operator to use when making Kubernetes API requests. Enter the vale **wko-operator-sa** as shown in screenshot below.

    **Helm Release Name to Use for Operator Installation** - The Helm release name to use to identify this installation. Enter the vale **wko-weblogic-operator** as shown in screenshot below.

    ![WebLogic Operatotr](images/weblogic-operator.png) 
    
    > **For your information only:**<br>
    > !By default, the operator’s *Image Tag to Use* field is set to the image tag corresponding to the latest operator release version on the GitHub Container Registry.<br>
    > The operator needs to know which WebLogic domains in the Kubernetes cluster that it will manage. It does this at the Kubernetes namespace level, so any WebLogic domain in a Kubernetes namespace the operator is configured to manage, will be managed by the operator instance being installed.<br>
    > For *Kubernetes Namespace Selection Strategy* field, we select *Label Selector*, which means any Kubernetes namespace with a *weblogic-operator=enabled* label will be managed by this operator.<br>
    ![Operator Image](images/operator-image.png)
   
    > By enabling Enable Cluster Role Binding, the operator installation will create a Kubernetes ClusterRole and ClusterRoleBinding that the operator will use for all managed namespaces.<br>
    > By default, the operator’s REST API is not exposed outside the Kubernetes cluster. To enable the REST API to be exposed, you can enable *Expose REST API Externally*.
    ![Role Binding](images/role-binding.png)<br>
    
    > This pane lets you override the operator’s Java logging configuration, which can be useful when debugging issues with the operator.<br>
    ![Java Logging](images/java-logging.png)<br>
   
    > For more information on *WebLogic Kubernetes Operator Image*, *Kubernetes Namespace Selection Strategy*, *WebLogic Kubernetes Role Bindings*, *External REST API Access*, *Third Party Integrations* and *Java Logging*, see the [WebLogic Kubernetes Operator](https://oracle.github.io/weblogic-toolkit-ui/navigate/kubernetes/k8s-wko/) documentation.

2. Once you see *WebLogic Kubernetes Operator Installation Complete*, Click *Ok*.
    ![Operator Installed](images/operator-installed.png)

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, October 2024