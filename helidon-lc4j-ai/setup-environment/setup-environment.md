# Setup the Environment

## Introduction

This lab walks you through the steps to setup the required environment for the Workshop.

Estimated time: 05 minutes

### Objectives

* Setup the Visual Studio Code
* Check the required Maven and JDK version
* Open Helidon source code in VS Code

### Prerequisites

* You must have an [Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure) enabled account.
* You must have Chrome as a browser to open Code Editor.



## Task 1: Access the Remote console URL

1. You must have received the **bitly** link from the instructor. Open the URL in the browser.

## Task 2: Install Visual Studio Code in the Remote Desktop


1. In the terminal, copy and paste the below command to install the **VSCode** in the remote Desktop.
    ```bash
    <copy>cd ~
    ./install-vscode.sh</copy>
    ```

2. Click **Activities** and type **Visual**, you will see the icon for **Visual Studio code**. Click **Visual Studio Code** icon.
    > While opening application, if it asks for the password, enter **welcome1**.

    
3. In **VSCode**, click **Terminal** -> **New Terminal**.
    ![Open Terminal](images/open-terminal.png)


## Task 3: Check the required Maven and JDK versions are installed properly

1. Execute following commands in the terminal to verify that required JDK and Maven version are installed and configured properly.

    ```bash
    <copy>java -version</copy>
    ```

    ```bash
    <copy>mvn -v</copy>
    ```

    > Do not get alarmed if you encounter `WARNING: java.lang.System::load`, it's a harmless warning caused by Maven compatibility issue [MNG-8248](https://issues.apache.org/jira/browse/MNG-8248)

## Task 4: Open Helidon source code in VS Code

1. Click **Explorer** icon as shown and expand the folders.
        ![open explorer](images/open-explorer.png)

You may now *proceed to the next lab*.


## Acknowledgements

* **Author** - Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, March 2025