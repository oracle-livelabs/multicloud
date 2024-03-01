# Build Helidon MP Application native image

## Introduction

In this lab, you will learn how to setup the environment on your local linux machine.

Estimated Time: 10 minutes


### Objectives

* Configure the required JDK and Maven.
* Download the application source code.

### Prerequisites

* You must have an IDE, to modify, build and run the project.


## Task 1: Download the required Maven and JDK version

1. In your IDE, open a terminal/console.

2. Copy the following commands and paste in the terminal. It downloads the required version of JDK and Maven and set the PATH variable to use the required Maven and JDK.

    ```bash
    <copy>wget https://archive.apache.org/dist/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz
    tar -xvf apache-maven-3.8.3-bin.tar.gz
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
    tar -xzvf jdk-21_linux-x64_bin.tar.gz</copy>
    ```

## Task 2: Download the Helidon source code

1.  Copy the following commands and paste in the terminal to download the source code of helidon application.

    ```bash
    <copy>curl -O https://objectstorage.uk-london-1.oraclecloud.com/p/mtb2d7fzfQKf9XEuSimkOBQnmR5yfbjUwcnPaMpAN5fcd8ENKwtzzlGeOrdpkZPt/n/lrv4zdykjqrj/b/ankit-bucket/o/helidon-virtual-thread.zip</copy>
    ```
    

2. Copy and paste the following command to unzip the *helidon-virtual-thread.zip*.
    ```bash
    <copy>unzip ~/helidon-virtual-thread.zip</copy>
    ```

You may now *proceed to the next lab*.

## Acknowledgements

* **Author** -  Ankit Pandey    
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, February 2024
