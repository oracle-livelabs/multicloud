# Build Helidon MP Application native image

## Introduction

In this lab, you will learn how to setup the environment on your local machine.

Estimated Time: 10 minutes


### Objectives

* Configure the required JDK and Maven.
* Download the application source code.

### Prerequisites

* You must have an IDE, to modify, build and run the project.


## Task 1: Download the required Maven and JDK version

1. In your IDE, open a terminal/console.

2. Copy the following commands and paste in the terminal. It downloads the required Maven.

    ```bash
    <copy>cd ~
    wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
    tar -xvf apache-maven-3.8.8-bin.tar.gz
    cd ~</copy>
    ```

3. Copy and paste the following URL in browser and download the **correct JDK 24** for your **Operating system** in your home directory.
    ```bash
    <copy>https://www.oracle.com/in/java/technologies/downloads/</copy>
    ```

4. Extract the JDK 24 in your home folder.

    > For example you are downloading JDK 24 for Linux environment. Run the command similar to below in your environment.   
    ```bash
        cd ~
        tar -xvf jdk-24_linux-x64_bin.tar.gz
    ```


## Task 2: Download the Helidon source code

1.  Copy the following commands and paste in the terminal to download the source code of helidon application.

    ```bash
    <copy>curl -O https://objectstorage.uk-london-1.oraclecloud.com/p/eVD6cUQpRms3iic_ZM4_si54wtIsFTNQUns-_U_HR7ofwQRj4m7qR76IMXDEEFqt/n/lrv4zdykjqrj/b/ankit-bucket/o/helidon-ai-hol.zip</copy>
    ```
    

2. Copy and paste the following command to unzip the *helidon-ai-hol.zip*.
    ```bash
    <copy>unzip ~/helidon-ai-hol.zip</copy>
    ```

You may now *proceed to the next lab*.

## Acknowledgements

* **Author** -  Dmitry Kornilov
* **Contributors** - Sid Joshi, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, February 2025
