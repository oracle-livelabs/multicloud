# Access the Bobby's Books sample application Explore Verrazzano, Grafana and Kiali Console

## Introduction

In Lab 3, we deployed the Bobby's Book application. In this lab, we will access the application and verify that it is working. Later, we will explore the Verrazzano and Grafana consoles.

Estimated time: 10 minutes

### Objectives

In this lab, you will:

* Access the Bobby's Book application.
* Explore the Verrazzano console.
* Explore the Grafana console.

### Prerequisites

<if type="freetier">
* Run Lab 1, which creates an OKE cluster on the Oracle Cloud Infrastructure.
</if>

<if type="livelabs">
* Run Lab 1, which configure kubectl to access an OKE cluster on the Oracle Cloud Infrastructure.
</if>

* Run Lab 2, which installs Verrazzano on a Kubernetes cluster.
* Run Lab 3, which deploys the Bobby's Book application.
* You should have a text editor, where you can paste the commands and URLs and modify them, as per your environment. Then you can copy and paste the modified commands for running them in the *Cloud Shell*.
* We recommend to use Firefox for opening the URLs of Bobby's Books application, Verrazano, Grafana and Kiali Console. However, if you want to use Chrome, then you need to use the undocumented 'thisisunsafe' workaround to allow chrome to accept the cert.

## Task 1: Access the Bobby's Book application

1. We need an `EXTERNAL_IP` address through which we can access the Bobby's Book application. To get the `EXTERNAL_IP` address of the istio-ingressgateway service, copy the following command and paste it in the *Cloud Shell*.

      ```bash
      <copy> kubectl get service \
      -n "istio-system" "istio-ingressgateway" \
      -o jsonpath={.status.loadBalancer.ingress[0].ip}; echo</copy>
      ```

   The output should be similar to the following:
      ```bash
         $ kubectl get service \
         > -n "istio-system" "istio-ingressgateway" \
         > -o jsonpath={.status.loadBalancer.ingress[0].ip}; echo
         XX.XX.XX.XX
      ```
2. To open the Robert's Book Store Home Page, copy the following URL and replace *XX.XX.XX.XX* with your *EXTERNAL_IP* address which we got in the last step, as shown in the following image.

      ```bash
      <copy>https://bobs-books.bobs-books.XX.XX.XX.XX.nip.io/</copy>
      ```

   ![Roberts Books Page](images/robertbooks.png " ")

3. Click *Advanced*, as shown:

   ![Robert Advanced](images/robertadvanced.png " ")


4. Select *Proceed to bobs-books.bobs-books. EXTERNAL_IP .nip.io(unsafe)* to access the application. If you are the not getting this option for proceed, just type *thisisunsafe* without any space anywhere inside this chrome browser window. As you are typing in the chrome browser window, you can't see it, but as soon as you finish typing *thisisunsafe*, you can see application page immediately. You can find more details [here](https://verrazzano.io/latest/docs/faq/faq/#enable-google-chrome-to-accept-self-signed-verrazzano-certificates).

   ![Robert Unsafe](images/robertunsafe.png " ")
   ![Robert Page](images/robertpage.png " ")

5. To open the Bobby's Book Store Home page, open a new tab and copy the following URL and replace *XX.XX.XX.XX* with your `EXTERNAL_IP` address, as shown in the following image.

      ```bash
      <copy>https://bobs-books.bobs-books.XX.XX.XX.XX.nip.io/bobbys-front-end/</copy>
      ```

      ![Bobbys URL](images/bobbysurl.png " ")

      ![Bobby bookstore](images/bobbysbookstore.png " ")

      > Leave this page open  because we will use it in Lab 8.

6. To open the Bobby's Book Order Manager UI, open a new tab and copy the following URL and replace *XX.XX.XX.XX* with your *EXTERNAL_IP* address as shown in the following image.

      ```bash
      <copy>https://bobs-books.bobs-books.XX.XX.XX.XX.nip.io/bobs-bookstore-order-manager/orders</copy>
      ```

   ![order manager](images/ordermanager.png " ")

7. Go Back to the *Bobby's Books* page and let's purchase a book. Click *Books* as shown in the following image.

   ![Check out order](images/checkoutorder.png " ")

8. Select the image for the *Twilight* Book, as shown in the following image.

   ![Purchase book](images/purchasebook.png " ")

9. First, click *Add to cart* and then *Checkout* as shown in the following image.

   ![Click addcart](images/clickaddcart.png " ")

10. Enter the details for purchasing the book. For *Your State*, enter your two digit state code and then click *Submit Order*.

   ![Submit Order](images/submitorder.png " ")
11. Go back to the *Order Manager* page and select the *Refresh* button to check if your order is successfully recorded in the order manager.

   ![Verify Order](images/verifyorder.png " ")

## Task 2: Explore the Rancher Console

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
      "openSearchDashboardsUrl": "https://kibana.vmi.system.default.xx.xx.xx.xx.nip.io",
      "openSearchUrl": "https://elasticsearch.vmi.system.default.xx.xx.xx.xx.nip.io",
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

10. From the home page of the rancher console, you can view the Verrazzano Links. Click *Hamburger menu* -> *Verrazzano*.

      ![Rancher Home](images/rancher-home.png)

11. Click *Applications* and then click *bobs-books*.
      ![Bobs Application](images/bobs-application.png)

12. You can view the pods associated with the application. To view the components, Click *Components*.
      ![Bobbys Components](images/bobs-components.png)

13. You can view the components of the application here. To view what are the related resources, click *Related Resources*.
      ![Bobs Resource](images/bobs-resource.png)

14. Click *Hamburgar menu* -> *local*, to open the *Cluster Explorer*. The *Cluster Explorer* allows you to view and manipulate all of the custom resources and CRDs in a Kubernetes cluster from the Rancher UI.
      ![Verrazzano Cluster](images/verrazzano-cluster.png)


15. The dashboard gives an overview of the cluster and the deployed applications. The number of resources belongs to the *User Namespaces* which is practically almost all the resources including the system too. You can filter by namespace at top of the dashboard, but this is not necessary now. Click on the **Nodes** item in the left side menu to get an overview of the current load of the nodes.

      ![Cluster Explorer](images/cluster-dashboard.png)

16. The whole deployment doesn't have any impact on the OKE cluster. Now click on the **Deployment** item in the left side menu to check your *bobs-books* application.

      ![Nodes](images/node.png)

17. You can see several deployments. Click on the *bobbys-helidon-stock-application*.

      ![Deployments](images/deployments.png)

18. On the *Deployment* page you can see your application deployment. A deployment provides declarative updates for pods and replica sets. The pod name contains an auto-generated unique string to identify that particular replica. To see how many and what type of containers are running in this pod click on the name.

      ![Bob deployment](images/bobs-deployment.png)

19. You should see two containers in the pod. The *bobbys-helidon-stock-application* runs the "real" application and the other is the sidecar container which is automatically injected and necessary to take the advantage of the Istio features. Here you can check the application's log in the container. Click on the dotted menu button at the top right corner and select **View Logs**.

      ![Pod](images/view-logs.png)

20. Make sure to access the Bobbys application's page. Find the custom `bobbys-helidon-stock-application` log entry. If you can't see the application log then click the **Settings** (blue button with the gear icon) and change the time filter to show all the log entries from the container start.

      ![Pod](images/log.png)

## Task 3: Explore the Grafana Console

1. Click *Hamburgar menu* -> *Verrazzano*.
      ![Home](images/ranchar-menu.png)

2. On the home page, you'll see the link for opening the *Grafana console*. Click the link for the **Grafana Console** as shown:

      ![Grafana Home](images/grafana-link.png)

3. Click *Advanced*.

    ![Grafana Advanced](images/grafanaadvanced.png " ")

4. Select *grafana.vmi.system.default.XX.XX.XX.XX.nip.io(unsafe)*. If you are the not getting this option for proceed, just type *thisisunsafe* without any space.

    ![Grafana proceed](images/grafanaproceed.png " ")

5. The Grafana Home Page opens. Select *Home*  at the top left.

    ![Grafana Homepage](images/grafanahomepage.png " ")

6. Type *WebLogic* and you will see *WebLogic Server Dashboard* under *General*. Select *WebLogic Server Dashboard*.

    ![Search WebLogic](images/searchweblogic.png " ")

    Here you can observe the two domains under *Domain* and Running Servers, Deployed Applications, Server Name and their Status, Heap Usage, Running Time, JVM Heap. If your application has resources like JDBC and JMS, you can also get details about it here.

    ![WebLogic Dashboard](images/weblogicdashboard.png " ")

7. Now, select WebLogic Server Dashboard and type *Helidon* and you will see *Helidon Monitoring Dashboard*. Select *Helidon Monitoring Dashboard*.

    ![Helidon](images/helidon.png " ")

    Here you can see various details like the *Status* of your application and its *Uptime*, Garbage Collector, and Mark Sweep Total and its Time, Thread Count.

    ![Helidon Dashboard](images/helidondashboard.png " ")

8. Now, select Helidon Monitoring Dashboard and type *Coherence* and you will see *Coherence Dashboard Main*. Select *Coherence Dashboard Main*.

    ![Coherence](images/coherence.png " ")

9. Here you can see the details of the *Coherence Cluster*. For the Bobby's Books application, we have two Coherence clusters, one for Bobby's Books and another for Robert's Books. You need to select the drop-down menu for *Cluster Name* to view both the clusters.

    ![Bobby Cluster](images/bobbycluster.png " ")

    ![Robert Cluster](images/robertcluster.png " ")

## Task 4: Explore the Kiali Console

1. Go back to the Verrazzano home page and click **Kiali** console.

      ![Rancher link](images/kiali-link.png)

2. On Left side, Click on Graph.

   ![Kiali Dashboard](images/kialidashboard.png " ")

3. In the Namespace dropdown, check the box for *bobs-books* and make the curser move outside the dropdown. 
   ![Bobs Namespace](images/bobsnamespace.png " ")

4. You can view the graphical view of *bobs-books* application. Click *Legend* to view the Legend view.

   ![Graphical View](images/graphicalview.png " ")

5. Here you can view, what each shapes represents, like circle represents the *Workloads*.

   ![Legend View](images/legendview.png " ")

6. On Left side, Click on *Applications*.

   ![Applications](images/applications.png " ")


## Task 5: Explore the OpenSearch Dashboards

1. Go back to the Verrazzano home page and click the **OpenSearch Dashboards** console.

      ![Kibana link](images/opensearch-link.png)

2. Click *Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)* if necessary. The first time *OpenSearch Dashboards* shows the welcome page. It offers built-in sample data to try OpenSearch but you can select the **Explore on my own** option because Verrazzano completed the necessary configuration and the application data is already available.

      ![Kibana welcome page](images/opensearch-proceed.png)

3. On the OpenSearch homepage click the **Home** -> **Discover**.

      ![Kibana dashboard click](images/discover-1.png)

4. To find a log entry in OpenSearch first you need to define the index pattern. Click *Create index pattern*. Type `verrazzano-application-hello-helidon` in the **Index Pattern name**. Select the result from the list below and click **Next step** as shown.

      ![Index pattern](images/create-index.png)
      ![Opensearch index](images/opensearch-index.png)

5. On the next page select *@timestamp* as **Time Filter** field name and click **Create Index pattern**.

      ![Index pattern](images/time-filter.png)

6. When the index is ready you need to click *Home* -> *Discover*. 

      ![Index pattern](images/discover-2.png)

7. Make sure your have purchased one book from Bobbys Front end application and you have verified the same in Bobs Order manager web page. Press **Enter** or click **Refresh**. You should get at least one result.
       ![Log result](images/log-result.png)

## Task 6: Explore the Prometheus Console

1. Go back to the Verrazzano home page and click **Prometheus** console.

      ![Prometheus link](images/prometheus-link.png)

2. Click **Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)** if prompted.

3. On the Prometheus dashboard page type *get* into the search field and click your custom metric *application_org_books_bobby_BookResource_getBook_total*.

      ![Prometheus execute](images/prometheus-query.png)

4. Click **Execute** and check the result below. You should see your metric's current value which means how many requests were completed by your endpoint. You can also switch to *Graph* view instead of the *Console* mode.

      ![Prometheus value](images/execute-query.png)

      >You can also add another metric to your dashboard. Discover the available, default metrics in the list.

   Leave the *Cloud Shell* open; we will use it for upcoming labs.

## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Peter Nagy
* **Last Updated By/Date** - Ankit Pandey, November 2022
