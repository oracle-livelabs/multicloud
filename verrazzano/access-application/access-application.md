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

   ![Verify Order](images/verify-order.png " ")

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

10. From the home page of the rancher console, you can view the Verrazzano Links. Click *Hamburger menu* -> *Verrazzano*.

      ![Rancher Home](images/rancher-home.png)

11. Click *Applications*. This section shows all the applications with their namespace and is managed by Verrazzano. Click the *bobs-books* application within the *bobs-books* namespace..
      ![Bobs Application](images/bobs-application.png)

12. You can view the pods associated with the application. The pod name contains an auto-generated unique string to identify that particular replica. To view the logs of *bobbys-helidon-stok-application* pods, Click *Three dots* -> *View Logs*.
      ![Bobbys Logs](images/bobs-logs.png)
      


13. You can view the application logs for the application. If you can't see the application log then click the **Settings** (blue button with the gear icon) and change the time filter to show all the log entries from the container start. To view the Component associated with the application, click *Components*.
      ![Bobbys Log](images/bobs-log.png)

14. You can view all the components of the *bobs-books* application here. To view what are the related resources, click *Related Resources*.
      ![Bobs Resource](images/bobs-resource.png)
      ![Bobs Resources](images/bobs-resources.png)

15. Click *Hamburgar menu* -> *local*, to open the *Cluster Explorer*. The *Cluster Explorer* allows you to view and manipulate all of the custom resources and CRDs in a Kubernetes cluster from the Rancher UI.
      ![Verrazzano Cluster](images/verrazzano-cluster.png)


16. The dashboard gives an overview of the cluster and the deployed applications. The number of resources belongs to the *User Namespaces* which is practically almost all the resources including the system too. You can filter by namespace at top of the dashboard, but this is not necessary now. Click on the **Nodes** item in the left side menu to get an overview of the current load of the nodes.

      ![Cluster Explorer](images/cluster-dashboard.png)

17. The whole deployment doesn't have any impact on the OKE cluster. Now click on the **Deployment** item in the left side menu to check deployed applications.

      ![clustr nodes](images/cluster-nodes.png)

18. You can see several deployments.

      ![Deployments](images/cluster-deployments.png)

## Task 3: Explore the Grafana Console

1. Click *Hamburgar menu* -> *Home* to open Rancher home page.
      ![Home](images/ranchar-menu.png)

2. On the home page, you'll see the link for opening the *Grafana console*. Click the link for the **Grafana Console** as shown:

      ![Grafana Home](images/grafana-link.png)

3. Click *Advanced*.

    ![Grafana Advanced](images/grafanaadvanced.png " ")

4. Select *grafana.vmi.system.default.XX.XX.XX.XX.nip.io(unsafe)*. If you are the not getting this option for proceed, just type *thisisunsafe* without any space.

    ![Grafana proceed](images/grafanaproceed.png " ")

5. The Grafana Home Page opens. Select *Home*  at the top left.

    ![Grafana Homepage](images/grafana-homepage.png " ")

6. Type *WebLogic* and you will see *WebLogic Server Dashboard* under *General*. Select *WebLogic Server Dashboard*.

    ![Search WebLogic](images/search-weblogic.png" ")

    Here you can observe the two domains under *Domain* and Running Servers, Deployed Applications, Server Name and their Status, Heap Usage, Running Time, JVM Heap. If your application has resources like JDBC and JMS, you can also get details about it here.

    ![WebLogic Dashboard](images/weblogic-dashboard.png " ")

7. Now, select WebLogic Server Dashboard and type *Helidon* and you will see *Helidon Monitoring Dashboard*. Select *Helidon Monitoring Dashboard*.

    ![Helidon](images/search-helidon.png " ")

    Here you can see various details like the *Status* of your application and its *Uptime*, Garbage Collector, and Mark Sweep Total and its Time, Thread Count.

    ![Helidon Dashboard](images/helidon-dashboard.png " ")

8. Now, select Helidon Monitoring Dashboard and type *Coherence* and you will see *Coherence Dashboard Main*. Select *Coherence Dashboard Main*.

    ![Coherence](images/search-coherence.png " ")

9. Here you can see the details of the *Coherence Cluster*. For the Bobby's Books application, we have two Coherence clusters, one for Bobby's Books and another for Robert's Books. You need to select the drop-down menu for *Cluster Name* to view both the clusters.

    ![Bobby Cluster](images/bobby-cluster.png " ")

    ![Robert Cluster](images/robert-cluster.png " ")

## Task 4: Explore the Kiali Console

1. Go back to the Verrazzano home page and click **Kiali** console.

      ![Rancher link](images/kiali-link.png)

2. On Left side, Click on Graph.

   ![Kiali Dashboard](images/kiali-dashboard.png " ")

3. In the Namespace dropdown, check the box for *bobs-books* and make the curser move outside the dropdown. 
   ![Bobs Namespace](images/bobs-namespace.png " ")

4. You can view the graphical view of *bobs-books* application. Click *Legend* to view the Legend view.

   ![Graphical View](images/graphical-view.png " ")

5. Here you can view, what each shapes represents, like circle represents the *Workloads*.

   ![Legend View](images/legend-view.png " ")

6. On Left side, Click on *Applications* to view all the deployed applications.

   ![Applications](images/kiali-applications.png " ")


## Task 5: Explore the OpenSearch Dashboards

1. Go back to the Verrazzano home page and click the **OpenSearch Dashboards** console.

      ![Kibana link](images/opensearch-link.png)

2. Click *Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)* if necessary.

3. On the OpenSearch homepage click the **Home** -> **Discover**.

      ![Kibana dashboard click](images/discover-1.png)

4. Select the *`verrazzano-applications*`* namespace as shown, then search for *books* and press **Enter** or click **Refresh**. You should get the logs containing *books*. 
       ![Log result](images/search-books.png)

## Task 6: Explore the Prometheus Console

1. Go back to the Verrazzano home page and click **Prometheus** console.

      ![Prometheus link](images/prometheus-link.png)

2. Click **Proceed to ... default XX.XX.XX.XX.nip.io(unsafe)** if prompted.

3. On the Prometheus dashboard page type *get* into the search field and click your custom metric *`application_org_books_bobby_BookResource_getBook_total`*.

      ![Prometheus execute](images/prometheus-query.png)

4. Click **Execute** and check the result below. You should see your metric's current value which means how many requests were completed by your endpoint. You can also switch to *Graph* view instead of the *Console* mode.

      ![Prometheus value](images/execute-query.png)

      >You can also add another metric to your dashboard. Discover the available, default metrics in the list.

## Task 7: Explore the Keycloak Console

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


## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Maciej Gruszka, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, August 2023
