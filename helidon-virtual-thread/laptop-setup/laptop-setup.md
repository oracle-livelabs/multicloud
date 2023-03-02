# Build Helidon MP Application native image

## Introduction

In this lab, you will learn how to setup the environment on your local linux machine.

Estimated Time: 15 minutes


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
    wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.tar.gz
    tar -xzvf jdk-19_linux-x64_bin.tar.gz</copy>
    ```

## Task 2: Download the Helidon source code

1.  Copy the following commands and paste in the terminal to download the source code of helidon application.

    ```bash
    <copy>curl -LSs https://github.com/oracle-livelabs/multicloud/blob/main/helidon-virtual-thread/setup-environment/code/helidon-levelup-2023-main.zip?raw=true >~/helidon-levelup-2023-main.zip </copy>
    ```
    

2. Copy and paste the following command to unzip the *helidon-levelup-2023-main.zip*.
    ```bash
    <copy>unzip ~/helidon-levelup-2023-main.zip</copy>
    ```

You may now *proceed to the next lab*.

## Acknowledgements

* **Author** -  Joe DiPol
* **Contributors** - Ankit Pandey, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, Feb 2023
