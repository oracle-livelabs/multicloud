# Setup the Environment

## Introduction

This lab walks you through the steps to setup the required environment for the Workshop.

Estimated time: 05 minutes

### Objectives

* Setup the Code Editor
* Download the required Maven and JDK version
* Download the Helidon source code

### Prerequisites

* You must have an [Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure) enabled account.
* You must have Chrome as a browser to open Code Editor.



## Task 1: Setup the Code Editor

1. In Cloud Console, click **Developer tools** icon -> **Code Editor** icon.
    
2. In Code Editor, click **Terminal** -> **New Terminal**.
    ![Open Terminal](images/open-terminal.png)

## Task 2: Download the required Maven and JDK version

1. Copy the following commands and paste in the terminal. It downloads the required version of JDK and Maven.

    ```bash
    <copy>cd ~
    wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
    tar -xvf apache-maven-3.8.8-bin.tar.gz
    wget https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.tar.gz
    tar -xzvf jdk-23_linux-x64_bin.tar.gz
    cd ~</copy>
    ```

## Task 3: Open Helidon Application in the Code Editor

1.  Copy the following commands and paste in the terminal to download the source code of helidon application.

    ```bash
    <copy>curl -O https://objectstorage.uk-london-1.oraclecloud.com/p/Ke2PNzmGVcAOHj-UZqvtADLlRFodC3Ino_wMhzBxzIQQWS3MyEiT9KyDOfpcQwtT/n/lrv4zdykjqrj/b/ankit-bucket/o/helidon-ai-hol.zip</copy>
    ```
    
2. Copy and paste the following command to unzip the *helidon-ai-hol.zip*.
    ```bash
    <copy>unzip ~/helidon-ai-hol.zip</copy>
    ```

3. Click *File* -> *Open* in Code Editor.
    ![Open Project](images/open-project.png)

4. Select *helidon-ai-hol* folder and click *Open*.
    ![Helidon Project](images/helidon-project.png)

    > Click **Explorer** icon as shown and expand the folders.
        ![open explorer](images/open-explorer.png)


5. Open a new terminal, and then copy and paste the following command to set the PATH and JAVA_HOME variable.
    ```bash
    <copy>PATH=~/jdk-23.0.2/bin:~/apache-maven-3.8.8/bin:$PATH
    JAVA_HOME=~/jdk-23.0.2/</copy>
    ```

6. Copy the following command and run in the terminal to verify that required JDK and Maven version are configured properly.

    ```bash
    <copy>mvn -v</copy>
    ```

    you will have the output similar to the following:
    ```bash
    $ mvn -v
    Apache Maven 3.8.8 (4c87b05d9aedce574290d1acc98575ed5eb6cd39)
    Maven home: /home/ankit_x_pa/apache-maven-3.8.8
    Java version: 23.0.2, vendor: Oracle Corporation, runtime: /home/ankit_x_pa/jdk-23.0.2
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "4.14.35-2047.542.2.el7uek.x86_64", arch: "amd64", family: "unix"
    $ 
    ```

    > *You will use only this terminal for building and running the application as it has the required JDK and Maven version.* You can use any terminal for testing the helidon application.


You may now *proceed to the next lab*.

## Learn More

### About Code Editor

The Code Editor enables you to edit and deploy code for various OCI services directly from the OCI Console. You can now update service workflows and scripts without having to switch between the Console and your local development environments. This makes it easy to rapidly prototype cloud solutions, explore new services, and accomplish quick coding tasks.

Code Editor's direct integration with Cloud Shell allows you access to the GraalVM Enterprise Native Image and JDK 17 (Java Development Kit) pre-installed in Cloud Shell.

## Acknowledgements

* **Author** - Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, February 2025