# Install Verrazzano

## Introduction

This lab walks you through the steps to install Verrazzano on a Kubernetes cluster in the Oracle Cloud Infrastructure.

Estimated Time: 20 minutes

### About Product/Technology

Verrazzano is an end-to-end enterprise container platform for deploying cloud-native and traditional applications in multi-cloud and hybrid environments. It is made up of a curated set of open source components – many that you may already use and trust, and some that were written specifically to pull together all of the pieces that make Verrazzano a cohesive and easy-to-use platform.

Verrazzano includes the following capabilities:

* Hybrid and multicluster workload management
* Special handling for WebLogic, Coherence, and Helidon applications
* Multicluster infrastructure management
* Integrated and pre-wired application monitoring
* Integrated security
* DevOps and GitOps enablement

### Objectives

In this lab, you will:

* Setup `kubectl` to use the Oracle Kubernetes Engine cluster
* Install the Verrazzano vz CLI.
* Install the development (`dev`) profile of Verrazzano.

### Prerequisites

Verrazzano requires the following:

* A Kubernetes cluster and a compatible `kubectl`.
* At least 2 CPUs, 100GB disk storage, and 16GB RAM available on the Kubernetes worker nodes. This is sufficient to install the development profile of Verrazzano. Depending on the resource requirements of the applications you deploy, this may or may not be sufficient for deploying your applications.
* In Lab 1, you created a Kubernetes cluster on the Oracle Cloud Infrastructure. You will use that Kubernetes cluster, *cluster1*, for installing the development profile of Verrazzano.

## Task 1: Configure `kubectl` (Kubernetes Cluster CLI)


We will use `kubectl` to manage the cluster remotely using the Cloud Shell. It needs a `kubeconfig` file. This will be generated using the OCI CLI which is pre-authenticated, so there’s no setup to do before you can start using it.

1. Click **Access Cluster** on your cluster detail page.

    > If you moved away from that page, then open the navigation menu and under **Developer Services**, select **Kubernetes Clusters (OKE)**. Select your cluster and go to the detail page.

    ![Access Cluster](images/access-cluster.png)

    > A dialogue is displayed from which you can open the Cloud Shell and contains the customized OCI command that you need to run, to create a Kubernetes configuration file.

2. Accept the default **Cloud Shell Access** and click **Copy** copy the `oci ce...` command and paste it into the Cloud Shell and run the command.

    ![Copy kubectl Config](images/copy-config.png)

    For example, the command looks like the following:

    ```bash
    oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.phx.aaaaaaaaaezwen..................zjwgm2tqnjvgc2dey3emnsd --file $HOME/.kube/config --region us-phoenix-1 --token-version 2.0.0
    ```

    ![kubectl config](images/create-config.png)

5. Verify that the `kubectl` is working by using the `get node` command. <br>
You may need to run this command several times until you see the output similar to the following.

    ```bash
    <copy>kubectl get node</copy>
    ```

    ```bash
    $ kubectl get node
    NAME          STATUS   ROLES   AGE    VERSION
    10.0.10.112   Ready    node    4m32s   v1.24.1
    10.0.10.200   Ready    node    4m32s   v1.24.1
    10.0.10.36    Ready    node    4m28s   v1.24.1
    ```

    > If you see the node's information, then the configuration was successful.

## Task 2: Install the vz CLI


1. Download the latest vz CLI.

    ```bash
    <copy>curl -LO https://github.com/verrazzano/verrazzano/releases/download/v1.4.2/verrazzano-1.4.2-linux-amd64.tar.gz</copy>
    ```
    The output should be similar to the following:
    ```bash
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 39.7M  100 39.7M    0     0  23.6M      0  0:00:01  0:00:01 --:--:-- 32.7M
    ```

2. Download the checksum file.

    ```bash
    <copy>curl -LO https://github.com/verrazzano/verrazzano/releases/download/v1.4.2/verrazzano-1.4.2-linux-amd64.tar.gz.sha256</copy>
    ```

  The output should be similar to the following:

    ```bash
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   102  100   102    0     0    218      0 --:--:-- --:--:-- --:--:--   218
    ```

3. Validate the binary against the checksum file.

    ```bash
    <copy>sha256sum -c verrazzano-1.4.2-linux-amd64.tar.gz.sha256</copy>
    ```

    The output should be similar to the following:
    ```bash
    verrazzano-1.4.2-linux-amd64.tar.gz: OK
    ```

4. Unpack and move to the vz binary,

    ```bash
    <copy>tar xvf verrazzano-1.4.2-linux-amd64.tar.gz
    cd ~/verrazzano-1.4.2/bin/</copy>
    ```

5. Test to ensure that the version you installed is up-to-date.

    ```bash
    <copy>./vz version</copy>
    ```

    The output should be similar to the following:
    ```bash
    Version: v1.4.2
    BuildDate: 2022-11-10T22:25:50Z
    GitCommit: 0576f21c8787ea948cb6cfbf1cdea52ef276749a
    ```



## Task 3: Installation of the Verrazzano development profile

An installation profile is a well-known configuration of Verrazzano settings that can be referenced by name, which can then be customized as needed.

Verrazzano supports the following installation profiles: development (`dev`), production (`prod`), and managed cluster (`managed-cluster`).

The following image describes the Verrazzano installation profiles.
![Install Profile](images/installprofile.png)

To change profiles in any of the following commands, set the *VZ_PROFILE* environment variable to the name of the profile you want to install.

For a complete description of Verrazzano configuration options, see the [Verrazzano Custom Resource Definition](https://verrazzano.io/docs/reference/api/verrazzano/verrazzano/).

In this lab, we are going to install the *development profile of Verrazzano*, which has the following characteristics:

* Wildcard (nip.io) DNS
* Self-signed certificates
* Shared observability stack used by the system components and all applications
* Ephemeral storage for the observability stack (if the pods are restarted, you lose all of your logs and metrics)
* It has a lightweight installation.
* It is for evaluation purposes.
* Single-node Opensearch cluster topology.

The following image describes the Verrazzano components that are installed with each profile.

![Verrazzano Profile](images/verrazzanoprofile.png " ")

According to our DNS choice, we can use nip.io (wildcard DNS) or [Oracle OCI DNS](https://docs.cloud.oracle.com/en-us/iaas/Content/DNS/Concepts/dnszonemanagement.htm). In this lab, we are going to install using nip.io (wildcard DNS).

An ingress controller is something that helps provide access to Docker containers to the outside world (by providing an IP address). The ingress routes the IP address to different clusters.

1. Install using the nip.io DNS Method. Copy the following command and paste it in the *Cloud Shell* to install Verrazzano.

    ```bash
    <copy>./vz install -f - <<EOF
    apiVersion: install.verrazzano.io/v1beta1
    kind: Verrazzano
    metadata:
      name: example-verrazzano
    spec:
      profile: dev
    EOF
    </copy>
    ```

    The output should be similar to the following:
    ```bash
    Installing Verrazzano version v1.4.2
    Applying the file https://github.com/verrazzano/verrazzano/releases/download/v1.4.2/verrazzano-platform-operator.yaml
    customresourcedefinition.apiextensions.k8s.io/verrazzanomanagedclusters.clusters.verrazzano.io created
    customresourcedefinition.apiextensions.k8s.io/verrazzanos.install.verrazzano.io created
    namespace/verrazzano-install created
    serviceaccount/verrazzano-platform-operator created
    clusterrole.rbac.authorization.k8s.io/verrazzano-managed-cluster created
    clusterrolebinding.rbac.authorization.k8s.io/verrazzano-platform-operator created
    service/verrazzano-platform-operator created
    deployment.apps/verrazzano-platform-operator created
    validatingwebhookconfiguration.admissionregistration.k8s.io/verrazzano-platform-operator created
    Waiting for verrazzano-platform-operator to be ready before starting install - 17 seconds
    2023-01-03T11:41:33.360Z info Reconciling Verrazzano resource default/example-verrazzano, generation 1, version 
    2023-01-03T11:41:33.449Z info Validate update
    2023-01-03T11:41:34.033Z info Starting EventSource
    ```

    > It takes around 15 to 20 minutes to complete the installation. This command installs the Verrazzano platform operator and applies the Verrazzano custom resource. Installation logs will be streamed to the command window until the installation has completed or until the default timeout (30m) has been reached.

2. Leave the *Cloud Shell* open and let the installation run. Please continue with the next lab.

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, January 2023