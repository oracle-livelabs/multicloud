# Install Verrazzano

## Introduction

This lab walks you through the steps to install Verrazzano on a Kubernetes cluster in the Oracle Cloud Infrastructure.

Estimated time: 20 minutes

### About Product/Technology

Verrazzano is an end-to-end enterprise container platform for deploying cloud-native and traditional applications in multicloud and hybrid environments. It is made up of a curated set of open source components – many that you may already use and trust, and some that were written specifically to pull together all of the pieces that make Verrazzano a cohesive and easy to use platform.

Verrazzano includes the following capabilities:

* Hybrid and multicluster workload management
* Special handling for WebLogic, Coherence, and Helidon applications
* Multicluster infrastructure management
* Integrated and pre-wired application monitoring
* Integrated security
* DevOps and GitOps enablement

### Objectives

In this lab, you will:

* Install the Verrazzano platform operator.
* Install the development (`dev`) profile of Verrazzano.
* Verify the successful Verrazzano installation.

### Prerequisites

Verrazzano requires the following:

* A Kubernetes cluster and a compatible `kubectl`.
* At least 2 CPUs, 100GB disk storage, and 16GB RAM available on the Kubernetes worker nodes. This is sufficient to install the development profile of Verrazzano. Depending on the resource requirements of the applications you deploy, this may or may not be sufficient for deploying your applications.

<if type="freetier">
In Lab 1, you created a Kubernetes cluster on the Oracle Cloud Infrastructure. You will use that Kubernetes cluster, *cluster1*, for installing the development profile of Verrazzano.
</if>

<if type="livelabs">
In Lab 1, you created configuration file to access Kubernetes cluster on the Oracle Cloud Infrastructure. You will use that Kubernetes cluster, *cluster1*, for installing the development profile of Verrazzano.
</if>

## Task 1: Install the Verrazzano Platform Operator

Verrazzano provides a platform [operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) to manage the life cycle of Verrazzano installations. You can install, uninstall, and update Verrazzano installations by updating the [Verrazzano custom resource](https://verrazzano.io/docs/reference/api/verrazzano/verrazzano/).

Before installing Verrazzano, we need to install the Verrazzano Platform Operator.

1. Copy the following command and paste it in the *Cloud Shell* to run it.

    ```bash
    <copy>kubectl apply -f https://github.com/verrazzano/verrazzano/releases/download/v1.4.1/verrazzano-platform-operator.yaml</copy>
    ```
    The output should be similar to the following:
    ```bash
    $ kubectl apply -f https://github.com/verrazzano/verrazzano/releases/download/v1.4.1/verrazzano-platform-operator.yaml
    customresourcedefinition.apiextensions.k8s.io/verrazzanomanagedclusters.clusters.verrazzano.io created
    customresourcedefinition.apiextensions.k8s.io/verrazzanos.install.verrazzano.io created
    namespace/verrazzano-install created
    serviceaccount/verrazzano-platform-operator created
    clusterrole.rbac.authorization.k8s.io/verrazzano-managed-cluster created
    clusterrolebinding.rbac.authorization.k8s.io/verrazzano-platform-operator created
    service/verrazzano-platform-operator created
    deployment.apps/verrazzano-platform-operator created
    validatingwebhookconfiguration.admissionregistration.k8s.io/verrazzano-platform-operator created
    $
    ```
    > This `verrazzano-platform-operator.yaml` file contains information about the operator and the service accounts and custom resource definitions. By running this *kubectl apply* command, we are specifying whatever is in the `verrazzano-platform-operator.yaml` file.
    > All deployments in Kubernetes happen in a namespace. When we deploy the Verrazzano Platform Operator, it happens in the namespace called "verrazzano-install".

2. To find out the deployment status for the Verrazzano Platform Operator, copy the following command and paste it in the *Cloud Shell*.

    ```bash
    <copy>kubectl -n verrazzano-install rollout status deployment/verrazzano-platform-operator</copy>
    ```

  The output should be similar to the following:

    ```bash
    $ kubectl -n verrazzano-install rollout status deployment/verrazzano-platform-operator
    deployment "verrazzano-platform-operator" successfully rolled out
    $
    ```

    
    > Confirm that the operator pod associated with the Verrazzano Platform Operator is correctly defined and running. A Pod is a unit which runs containers / images and Pods belong to nodes.

3. To find out the pod status, copy and paste the following command in the *Cloud Shell*.

    ```bash
    <copy>kubectl -n verrazzano-install get pods</copy>
    ```

    The output should be similar to the following:
    ```bash
    $ kubectl -n verrazzano-install get pods
    NAME                                           READY   STATUS    RESTARTS   AGE
    verrazzano-platform-operator-f56788bfc-rgql6   1/1     Running   0          71s
    $
    ```

## Task 2: Installation of the Verrazzano development profile

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
    <copy>kubectl apply -f - <<EOF
    apiVersion: install.verrazzano.io/v1beta1
    kind: Verrazzano
    metadata:
      name: example-verrazzano
    spec:
      profile: ${VZ_PROFILE:-dev}
    EOF
    </copy>
    ```

    The output should be similar to the following:
    ```bash
    $ kubectl apply -f - <<EOF
    apiVersion: install.verrazzano.io/v1beta1
    kind: Verrazzano
    metadata:
      name: example-verrazzano
    spec:
      profile: ${VZ_PROFILE:-dev}
    EOF
    verrazzano.install.verrazzano.io/example-verrazzano created
    $
    ```

    <if type="freetier">
    > It takes around 15 to 20 minutes to complete the installation.
    </if>

    <if type="livelabs">
    > It takes around 8 to 10 minutes to complete the installation.
    </if>


2. To verify the successful installation, copy the following command and paste it in the *Cloud Shell*. It checks for the condition, if *InstallComplete* condition is met, and notifies you. Here *example-verrazzano* is the name of the *Verrazzano Custom Resource*.

    ```bash
    <copy>kubectl wait --timeout=20m --for=condition=InstallComplete verrazzano/example-verrazzano</copy>
    ```

    The output should be similar to the following:
    ```bash
    $ kubectl wait --timeout=20m --for=condition=InstallComplete verrazzano/example-verrazzano
    verrazzano.install.verrazzano.io/example-verrazzano condition met
    $
    ```

## Task 3: Verification of a successful Verrazzano installation

Verrazzano installs multiple objects in multiple namespaces. Verrazzano components are installed in the namespace *verrazzano-system*.

1. Please verify that all the pods associated with the multiple objects have a *Running* status. You will have 14 pods in the *Running* state.

    ```bash
    <copy>kubectl get pods -n verrazzano-system</copy>
    ```

    The output should be similar to the following:

    ```bash
    $   kubectl get pods -n verrazzano-system
    NAME                                             READY   STATUS   RESTARTS AGE
    coherence-operator-679cf4d55f-s76jx                1/1     Running   1    10m
    fluentd-2rrnr                                      2/2     Running   1    2m2s
    fluentd-g5scl                                      2/2     Running   1    2m18s
    fluentd-wdcwn                                      2/2     Running   1    2m16s
    oam-kubernetes-runtime-546f59d8d-lssmz             1/1     Running   0    10m
    verrazzano-application-operator-5fcb4498d5-rq99x   1/1     Running   0    9m14s
    verrazzano-authproxy-6f997b54bb-g6ll4              3/3     Running   0    8m47s
    verrazzano-console-7bc4f9995d-crh47                2/2     Running   0    8m28s
    verrazzano-monitoring-operator-5bdc84dc5f-8n8l6    2/2     Running   0    8m35s
    vmi-system-es-master-0                             2/2     Running   0    7m52s
    vmi-system-grafana-c8f55d8f9-zvqkb                 2/2     Running   0    7m50s
    vmi-system-kiali-795f84b549-6jnz5                  2/2     Running   0    8m42s
    vmi-system-kibana-69cd8dfc79-77s6h                 2/2     Running   0    3m20s
    weblogic-operator-5c74f97ff5-7rtvk                 2/2     Running   0    9m30s
    $
    ```

    Leave the *Cloud Shell* open; we need it for Lab 3.

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Peter Nagy
* **Last Updated By/Date** - Ankit Pandey, November 2022
