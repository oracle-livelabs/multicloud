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
    tar -xzvf jdk-19_linux-x64_bin.tar.gz
    PATH=~/jdk-19.0.2/bin:~/apache-maven-3.8.3/bin:$PATH
    JAVA_HOME=~/jdk-19.0.2</copy>
    ```

3. Copy the following command and run in the terminal to verify that required JDK and Maven version are configured properly.

    ```bash
    <copy>mvn -v</copy>
    ```

    you will have the output similar to the following:
    ```bash
    $ mvn -v 
    Apache Maven 3.8.3 (ff8e977a158738155dc465c6a97ffaf31982d739)
    Maven home: /home/ankit_x_pa/apache-maven-3.8.3
    Java version: 19.0.2, vendor: Oracle Corporation, runtime: /home/ankit_x_pa/jdk-19.0.2
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "4.14.35-2047.520.3.1.el7uek.x86_64", arch: "amd64", family: "unix"
    $ 
    ```

    > *You will use only this terminal for building and running the application as it has the required JDK and Maven version.*


## Task 2: Download the Helidon source code

1.  Copy the following commands and paste in the terminal to download the source code of helidon application.

    ```bash
    <copy>curl -LSs https://github.com/pandey-ankit/helidon-virtual-thread/blob/main/setup-environment/code/helidon-levelup-2023-main.zip?raw=true >~/helidon-levelup-2023-main.zip </copy>
    ```
    

2. Copy and paste the following command to unzip the *helidon-levelup-2023-main.zip*.
    ```bash
    <copy>unzip helidon-levelup-2023-main.zip</copy>
    ```

## Acknowledgements

* **Author** -  Joe DiPol
* **Contributors** - Ankit Pandey, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, Feb 2023
