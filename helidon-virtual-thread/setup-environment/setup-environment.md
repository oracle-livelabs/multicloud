# Setup the Environment

## Introduction

This lab walks you through the steps to setup the required environment for the Workshop.

[Lab1 walkthrough](videohub:1_far2bboa)

Estimated Time: 10 minutes

### Objectives
* Setup the Code Editor
* Download the required Maven and JDK version
* Download the Helidon source code

### Prerequisites

* You must have an [Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure) enabled account.
* You must have Chrome as a browser to open Code Editor.


## Task 1: Setup the Code Editor

1. In Cloud Console, click the Code Editor icon as shown.
    ![Code Editor](images/code-editor.png)

2. In Code Editor, click Terminal -> New Terminal.
    ![Open Terminal](images/open-terminal.png)

## Task 2: Download the required Maven and JDK version

1. Copy the following commands and paste in the terminal. It downloads the required version of JDK and Maven.

    ```bash
    <copy>wget https://archive.apache.org/dist/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz
    tar -xvf apache-maven-3.8.3-bin.tar.gz
    wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-aarch64_bin.tar.gz
    tar -xzvf jdk-21.0.2_linux-aarch64_bin.tar.gz</copy>
    ```

## Task 3: Download the Helidon source code

1.  Copy the following commands and paste in the terminal to download the source code of helidon application.

    ```bash
    <copy>curl -O https://objectstorage.uk-london-1.oraclecloud.com/p/mtb2d7fzfQKf9XEuSimkOBQnmR5yfbjUwcnPaMpAN5fcd8ENKwtzzlGeOrdpkZPt/n/lrv4zdykjqrj/b/ankit-bucket/o/helidon-virtual-thread.zip</copy>
    ```
    

2. Copy and paste the following command to unzip the *helidon-virtual-thread.zip*.
    ```bash
    <copy>unzip ~/helidon-virtual-thread.zip</copy>
    ```

You may now *proceed to the lab 2*.

## Learn More

### About Code Editor

The Code Editor enables you to edit and deploy code for various OCI services directly from the OCI Console. You can now update service workflows and scripts without having to switch between the Console and your local development environments. This makes it easy to rapidly prototype cloud solutions, explore new services, and accomplish quick coding tasks.

Code Editor's direct integration with Cloud Shell allows you access to the GraalVM Enterprise Native Image and JDK 17 (Java Development Kit) pre-installed in Cloud Shell. 

## Acknowledgements

* **Author** -  Ankit Pandey    
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, February 2024
