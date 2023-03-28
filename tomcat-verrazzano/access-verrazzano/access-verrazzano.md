# Use Verrazzano to Access and Monitor the Application

## Introduction

You deployed the tomcat application. In this lab, we will access the application and verify using multiple management tools provided by Verrazzano.

Estimated Time: 15 minutes

**Grafana**

Grafana is an open-source solution for running data analytics, pulling up metrics that make sense of the massive amount of data & to monitor our apps with the help of nice customizable dashboards. The tool helps to study, analyse & monitor data over some time, technically called time series analytics.
Useful to track the user behaviour, application behaviour, frequency of errors popping up in production or a pre-prod environment, type of errors popping up and the contextual scenarios by providing relative data.

[https://grafana.com/grafana/](https://grafana.com/grafana/)

**OpenSearch Dashboards**

OpenSearch Dashboards is a visualization dashboard for the content indexed on an OpenSearch cluster. Verrazzano creates an OpenSearch Dashboards deployment to provide a user interface for querying and visualizing the log data collected in OpenSearch.

To access the OpenSearch Dashboards console, read [Access Verrazzano](https://verrazzano.io/latest/docs/access/).

To see the records of an OpenSearch index through OpenSearch Dashboards, create an index pattern to filter for records under the desired index.

In Task 3, we will explore the OpenSearch Dashboards.

[https://opensearch.org/docs/latest/dashboards/index/](https://opensearch.org/docs/latest/dashboards/index/)

**Prometheus**

Prometheus is a monitoring and alerting toolkit. Prometheus collects and stores its metrics as time series data, i.e. metrics information is stored with the timestamp at which it was recorded, alongside optional key-value pairs called labels.

[https://prometheus.io/](https://prometheus.io/)

**Rancher**

Rancher is a platform that enables Verrazzano to run containers on multiple Kubernetes clusters in production. It enables hybrid which means a single pane of glass management of on-prem clusters and hosted on cloud services.

[https://rancher.com/](https://rancher.com/)

**Kiali**

Kiali is the user interface to Istio, and it is super simple to use. From the Verrazzano console, you can directly access Kiali. From there, you can see the traffic flows and any hot spots or trouble areas. You can then drill down to see the details of each. Kiali uses metrics data from Envoy stored in Prometheus to build the graphical model

### Objectives

In this lab, you will:

* Explore the Rancher console.
* Explore the Prometheus console.
* Explore the Grafana console.
* Explore the OpenSearch Dashboards.
* Explore the Kiali console.
* Explore the Keycloak console.


### Prerequisites

* Kubernetes (OKE) cluster running on the Oracle Cloud Infrastructure.
* Verrazzano installed on a Kubernetes (OKE) cluster.
* Deployed tomcat sample application.


## Task 1: Explore the Rancher Console

Verrazzano installs several consoles. The endpoints for an installation are stored in the `Status` field of the installed Verrazzano Custom Resource.

1. You can get the endpoints for these consoles by using the following command:

      ```bash
      <copy>kubectl get vz -o jsonpath="{.items[].status.instance}" | jq .</copy>
      ```

   The output should be similar to the following:
      ```bash
      $ kubectl get vz -o jsonpath="{.items[].status.instance}" | jq .
      {
      "consoleUrl": "https://verrazzano.default.xx.xx.xx.xx.nip.io",
      "grafanaUrl": "https://grafana.vmi.system.default.xx.xx.xx.xx.nip.io",
      "keyCloakUrl": "https://keycloak.default.xx.xx.xx.xx.nip.io",
      "kialiUrl": "https://kiali.vmi.system.default.xx.xx.xx.xx.nip.io",
      "openSearchDashboardsUrl": "https://osd.vmi.system.default.xx.xx.xx.xx.nip.io",
      "openSearchUrl": "https://opensearch.vmi.system.default.xx.xx.xx.xx.nip.io",
      "prometheusUrl": "https://prometheus.vmi.system.default.xx.xx.xx.xx.nip.io",
      "rancherUrl": "https://rancher.default.xx.xx.xx.xx.nip.io"
      }
      $
      ```


2. Use the `https://rancher.default.YOUR_UNIQUE_IP.nip.io` to open the Rancher console.

3. Verrazzano *dev* profile use self-signed certificates, so you need to click **Advanced** to accept risk and skip the warning.

      ![Advanced](images/rancher-advanced.png)

4. Click **Proceed to rancher default XX.XX.XX.XX.nip.io(unsafe)**. If you are not getting this option for proceeding, just type *thisisunsafe* without any space anywhere inside this chrome browser window. As you are typing in the chrome browser window, you can't see it, but as soon as you finish typing *thisisunsafe*, you can see the next page immediately. You can find more details [here](https://verrazzano.io/latest/docs/faq/faq/#enable-google-chrome-to-accept-self-signed-verrazzano-certificates).

      ![Proceed](images/rancher-proceed.png)

5. Click *Log in with Keycloak*.
      ![Rancher login](images/keycloak-login.png)

6. Because it redirects to the Keycloak console URL for authentication, click **Advanced**.

      ![Keycloak Authentication](images/keycloak-advanced.png)

7. Click **Proceed to Keycloak default XX.XX.XX.XX.nip.io(unsafe)**. If you are not getting this option for proceeding, just type *thisisunsafe* without any space anywhere inside this chrome browser window. As you are typing in the chrome browser window, you can't see it, but as soon as you finish typing *thisisunsafe*, you can see the next page immediately. You can find more details [here](https://verrazzano.io/latest/docs/faq/faq/#enable-google-chrome-to-accept-self-signed-verrazzano-certificates).

      ![Proceed](images/keycloak-proceed.png)

8. Now we need the username and password for the Verrazzano console. *Username* is *verrazzano* and to find out the password, go back to the *Cloud Shell* and paste the following command to find out the password for the *Rancher Console*.

      ```bash
      <copy>kubectl get secret --namespace verrazzano-system verrazzano -o jsonpath={.data.password} | base64 --decode; echo</copy>
      ```

9. Copy the password and go back to the browser, where the *Rancher Console* is open. Paste the password in the *Password* field and enter *verrazzano* as *Username* and then click **Sign In**.

      ![SignIn](images/verrazzano-sign-in.png)

10. From the home page of the rancher console, you can view the Verrazzano Links. you can access any of these consoles from rancher console.Click *Hamburger menu* -> *Verrazzano*.

      ![Rancher Home](images/rancher-home.png)

11. Click *Applications*. This section shows all the applications with their namespace and is managed by Verrazzano. Click the *tomcat-appconf* application within the *tomcat-ns* namespace.
      ![Tomcat Application](images/tomcat-application.png)

12. You can view the pods associated with the application. The pod name contains an auto-generated unique string to identify that particular replica. To view the logs of pods, Click *Three dots* -> *View Logs*.
      ![Tomcat Components](images/view-pod-logs.png)

13. You can view the application logs for the application. If you can't see the application log then click the **Settings** (blue button with the gear icon) and change the time filter to show all the log entries from the container start. To view the Component associated with the application, click *Components*.
      ![Application logs](images/view-pod-log.png)

14. This application has only one component.To view what are the related resources, click *Related Resources*.
      ![Tomcat Resource](images/tomcat-resource.png)
      ![Tomcat Resources](images/tomcat-resources.png)

15. Click *Hamburgar menu* -> *local*, to open the *Cluster Explorer*. The *Cluster Explorer* allows you to view and manipulate all of the custom resources and CRDs in a Kubernetes cluster from the Rancher UI.
      ![Verrazzano Cluster](images/verrazzano-cluster.png)


16. The dashboard gives an overview of the cluster and the deployed applications. The number of resources belongs to the *User Namespaces* which is practically almost all the resources including the system too. You can filter by namespace at top of the dashboard, but this is not necessary now. Click on the **Nodes** item in the left side menu to get an overview of the current load of the nodes.

      ![Cluster Explorer](images/cluster-dashboard.png)

17. The whole deployment doesn't have any impact on the OKE cluster. Now click on the **Deployment** item in the left side menu to check deployed application.

      ![Nodes](images/node.png)

18. You can see several deployments. 

      ![Deployments](images/deployment.png)

## Task 2: Explore the Grafana Console

1. Click *Hamburgar menu* -> *Home*.
      ![Home](images/ranchar-menu.png)

2. On the home page, you'll see the link for opening the *Grafana console*. Click the link for the **Grafana Console** as shown:

      ![Grafana Home](images/grafana-link.png)

3. Click **Advanced**.

      ![Advanced](images/grafana-advanced.png)

4. Click **Proceed to grafana.vmi.system.default.XX.XX.XX.XX.nip.io(unsafe)**. If you are not getting this option for proceeding, just type *thisisunsafe* without any space anywhere inside this chrome browser window. As you are typing in the chrome browser window, you can't see it, but as soon as you finish typing *thisisunsafe*, you can see the next page immediately. You can find more details [here](https://verrazzano.io/latest/docs/faq/faq/#enable-google-chrome-to-accept-self-signed-verrazzano-certificates).

      ![proceed](images/grafana-proceed.png)

5. Click on the *+* icon and then click *Import* as shown below.
      ![import](images/import.png)
      
6. Enter the *6340* as value for *Import via grafana.com* and click *Load*.
      ![load ID](images/load-id.png)

7. Select *Prometheus* as default Datasource and click *Import*.
      ![Import Datasource](images/import-datasource.png)

8. Select *tomcat-ns* as namespace and *tomcat-container* as container, then you will be able to see the *Heap Used*, *Mem Committed* and other data as shown below.
      ![select namespace](images/select-namespace.png)

      > From Grafana.com, you can get more id to import in grafana console.

## Task 3: Explore the OpenSearch Dashboards

1. Go back to the Verrazzano home page and click the **OpenSearch Dashboards** console.

      ![Kibana link](images/opensearch-link.png)

2. Click *Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)* if necessary. The first time *OpenSearch Dashboards* shows the welcome page. It offers built-in sample data to try OpenSearch but you can select the **Explore on my own** option because Verrazzano completed the necessary configuration and the application data is already available.

      ![Kibana welcome page](images/opensearch-proceed.png)

3. On the OpenSearch homepage click the **Home** -> **Discover**.

      ![Kibana dashboard click](images/discover-1.png)

4. Invoke the following HTTP request in the Cloud Shell against your endpoint. You can execute requests multiple times.

      ```bash
      <copy>curl -k https://$(kubectl get gateways.networking.istio.io tomcat-ns-tomcat-appconf-gw -n tomcat-ns -o jsonpath={.spec.servers[0].hosts[0]})/sample-webapp/log; echo</copy>
      ```

5. Select the *`verrazzano-application*`* namespace as shown and then type the custom log entry value you created in the tomcat application: `Logs ` into the filter textbox. Press **Enter** or click **Refresh**. You should get at least one result.
      ![Log result](images/log-result.png)

## Task 4: Explore the Prometheus Console

1. Go back to the Verrazzano home page and click **Prometheus** console.

      ![Prometheus link](images/prometheus-link.png)

2. Click **Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)** if prompted.

3. On the Prometheus dashboard page type *tomcat* into the search field and click metric *tomcat_requestcount_total* and then click *Execute*.

      ![Prometheus execute](images/prometheus-query.png)

4. Click **Execute** and check the result below. You should see your metric's current value which means how many requests were completed by your endpoint. You can also switch to *Graph* view instead of the *Console* mode.

      ![Prometheus value](images/execute-query.png)

      >You can also add another metric to your dashboard. Discover the available, default metrics in the list.

## Task 5: Explore the Kiali Console

1. Go back to the Verrazzano home page and click **Kiali** console.

      ![Rancher link](images/kiali-link.png)

2. Click **Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)** if prompted.

3. On Left side, Click on Graph.

   ![Kiali Dashboard](images/kiali-dashboard.png " ")

4. In the Namespace dropdown, check the box for *verrazzano-system* and make the curser move outside the dropdown. 
   ![Bobs Namespace](images/verrazzano-namespace.png " ")

5. You can view the graphical view of *verrazzano-system* namespace. Click *Legend* to view the Legend view.

   ![Graphical View](images/graphical-view.png " ")

6. Here you can view, what each shapes represents, like circle represents the *Workloads*.

   ![Legend View](images/legend-view.png " ")

7. On Left side, Click on *Applications* to view the deployed applications.

   ![Applications](images/applications.png " ")

## Task 6: Explore the Keycloak Console

1. Go back to the Verrazzano home page and click **Keycloak** console.

      ![Keycloak link](images/keycloak-link.png)

2. Click **Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)** if prompted.

3. On the Welcome to Keycloak page, click *Administration Console*.
      ![Keycloak home](images/keycloak-home.png)

4. Now we need the username and password for the Keycloak console. *Username* is *keycloakadmin* and to find out the password, go back to the *Cloud Shell* and paste the following command to find out the password for the *Keycloak Console*.

      ```bash
      <copy>kubectl get secret --namespace keycloak keycloak-http -o jsonpath={.data.password} | base64  --decode; echo</copy>
      ```

5. Copy the password and go back to the browser, where the *Keycloak Console* is open. Paste the password in the *Password* field and enter *keycloakadmin* as *Username* and then click **Sign In**.

      ![SignIn](images/keycloak-sign-in.png)

6. Here you can view default configuration done by Verrazzano.
      ![Keycloak Home](images/keycloak-realms.png)

Congratulations you have completed the tomcat application deployment on Verrazzano lab.

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, March 2023
