# Modify a WKT UI Project and Create a Model file

## Introduction

In this lab, we explore the on-premise WebLogic domain. We navigate through the administration console to view the deployed application, data sources and servers in *test-domain*. we also open the pre-created *`ocw_project.wktproj`*, which already have pre-filled values for *Project Settings* section. Then we create the model file, by introspecting of an offline on-premise domain. At last, we validate the model and prepare the model to be deployed on Oracle Kubernetes Cluster (OKE).

Estimated Time: 15 minutes

Watch the video below for a quick walk-through of the lab.
[Creation of Model for the OKE on OCI](videohub:1_qdch3qqg)

### Objectives

In this lab, you will:

* Explore the on-premise WebLogic domain **test-domain**.
* Open the base WKT project.
* Introspection of an offline on-premise domain.
* Validate and prepare the model. 

### Prerequisites

To run this lab, you must have:
* Access to noVNC Remote Desktop.

## Task 1: Explore on-premise domain

In this task, we navigate through the resources in on-premise **test-domain** using the WebLogic Administration console.

1. On the left side, click **Arrow Icon**. 
 ![copy clipboard](images/copy-clipboard.png)
 > **Important**- You can see the **Clipboard**, for copy and paste between the host machine and remote desktop, we use the **Clipboard**. For example, if you want to copy from the host machine and want to paste it inside the remote desktop, you need to first paste in the clipboard, then you can paste it into the remote desktop. Again click on **Arrow Icon** to hide the **Settings** option.

2. Click **Activities** and then Click the icon for **terminal** as shown below.
 ![open terminal](images/open-terminal.png)

3. Copy and paste the below command in the terminal to start the **on-premise WebLogic Admin Server**.
 ```bash
    <copy>cd ~/Oracle/Middleware/Oracle_Home/user_projects/domains/test_domain/bin/
    ./startWebLogic.sh</copy>
 ```
 ![start server](images/start-server.png)

3. Click **Activities** and then type **Firefox** in search box. Click the icon for **Firefox**.
 ![open firefox](images/open-firefox.png)

4. Copy and paste the below URL in the browser to open Admin Console and enter **weblogic/Welcome1%** as `Username/Password`, then click **Login**. 
 ```bash
    <copy>http://localhost:7001/console</copy>
 ```
 ![Login Admin Console](images/login-admin-console.png)

5. To view available servers, expand **Environment** and click **Servers**. You can see, that we have one dynamic cluster with 5 managed servers. 
 ![View Servers](images/view-servers.png)

6. To view the datasources, expand **Services** and click **Data Sources**.
 ![View Datasources](images/view-datasources.png)

7. To view the deployed application, click **Deployment**. You can see, that we have **opdemo** as a deployed application.
 ![View Deployments](images/view-deployments.png)

## Task 2: Opening the base WKT UI Project

For simplicity of lab, we created **`ocw_project.wktproj`**, which preset the location of docker, Java, Oracle Home, and Primary Image Tag. In this task, we open the **`ocw_project.wktproj`** project.

1. Click **Activities** and then type **WebLogic** in search box. Click the icon for **WebLogic Kubernetes Toolkit UI**.
 ![Open WKTUI](images/open-wktui.png)

2. To open **ocw_project.wktproj** project, click **File** -> **Open Project**. 
 ![Open Project](images/open-project.png)

3. Click **Home** in left side, then choose **ocw_project.wktproj** and click **Open Project**.
 ![Project Location](images/project-location.png)

4. Enter **welcome1** as **Password** and then click **Unlock**.
 ![unlock](images/un-lock.png)

5. Review **Project Settings** and read more about it in the notes below.

    > **For your information only:**<br>
    > As **Credential Story Policy**, we select **Store in Native OS Credentials Store**. It means the credentials (like for WebLogic Server and data sources) are only stored on the local machine.<br>
    > For **Where would you like the target Oracle Fusion Middleware domain to live?**, we select **Created in the container from the model in the image**. In this case, the set of model-related files is added to the image. So when the WebLogic Kubernetes Operator domain object is deployed, its inspector process runs and creates the WebLogic Server domain inside a running container on the fly.<br>
 ![Project Settings](images/project-settings.png)
    > As **Kubernetes Environment Target Type**, we select **WebLogic Kubernetes Operator**. This means you want this domain to be deployed in Kubernetes managed by the WebLogic Kubernetes Operator. These settings also determine what sections and their associated actions within the application, to display.<br>
    > we also specify the location for **JAVA HOME** and **ORACLE_HOME**. WebLogic Kubernetes Toolkit UI uses this directory when invoking the WebLogic Deployer Tooling and WebLogic Image Tool. <br>
    > To build new images, inspect images and interact with image repositories, the WKT UI application uses an image build tool, which defaults to docker.<br>
 ![Kubernetes Cluster Type](images/kubernetes-cluster-type.png)




## Task 3: Introspection of an Offline on-premise domain 

In this task, we perform introspection of an on-premise domain, which creates a model file consisting of the domain configuration.

1. In WebLogic Kubernetes Toolkit UI, Click **Model** -> **Code View**.
 ![Model](images/click-model.png)

2. Click **File** -> **Add Model** -> **Discover Model(offline)**.
 ![Discover Model](images/discover-model.png)

3. Click Open folder **icon** to open the **Domain Home**.
 ![Open Domain Hom](images/open-domain-home.png)

4. In the Home folder, navigate to **`/home/opc/Oracle/Middleware/Oracle_Home/user_projects/domains/`** directory and select **test-domain** folder then  click **Select**. Click **OK**.
 ![Navigate Location](images/navigate-location.png)
 ![Specify Location](images/specify-location.png)
    > If you look in the console, you will see that this invokes the WebLogic Deployer Tool to introspect the domain configuration in offline mode. 

5. You can see the window as shown below, at the end, you will have a model ready for you.
 ![View Model](images/view-model.png)

    > The result of this WDT introspection are the model(a metadata representation of your domain configuration), placeholder, where you can specify the values (like a password for datasource) and application in the application archive.

## Task 4: Validate and Prepare Model 

In this task, we validate the model and prepare the model to be deployed on Oracle Kubernetes Cluster (OKE).

1. To validate the model, click **Validate Model**.
 ![Validate Model](images/validate-model.png)
    > **For your information only:**<br>
    > Validate model invokes the WDT [Validate Model Tool](https://oracle.github.io/weblogic-deploy-tooling/userguide/tools/validate/), which validates that the model and its related artefacts are well-formed and provides help on the valid attributes and subfolder for a particular model location.

2. Once you see **Validate Model Complete** window, click **Ok**.
 ![Validate Complete](images/validate-complete.png)

3. To prepare the model, to be deployed on the Kubernetes cluster, click **Prepare Model**
 ![Prepare Model](images/prepare-model.png)
    > **For your information only:**<br>
    > Prepare model invokes the WDT [Prepare Model Tool](https://oracle.github.io/weblogic-deploy-tooling/userguide/tools/prepare/) to modify the model to work in a Kubernetes cluster with WebLogic Kubernetes Operator or Verrazzano installed.<br>
    > Prepare Model does the following:
    * Removes model sections and fields that are not compatible with the target environment.
    * Replaces endpoint values with model tokens that reference variables.
    * Replaces credential values with model tokens that reference either a field in a Kubernetes secret or a variable.
    * Provides default values for fields displayed in the application’s variable, variable overrides, and secret editors.
    * Extracts topology information to the application that it uses to generate the resource file used to deploy the domain.

4. Once you see **Prepare Model Complete** window,click **Ok**.
 ![Prepare Complete](images/prepare-complete.png)


## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi , Maciej Gruszka, 
* **Last Updated By/Date** - Ankit Pandey, July 2024