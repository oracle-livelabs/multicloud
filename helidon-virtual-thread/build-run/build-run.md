# Build and Run the Helidon Virtual thread and Reactive application

## Introduction

This lab walks you through the process of building and running the Helidon 4 and Helidon 3 Reactive applications in Oracle Code Editor inside Oracle Cloud Infrastructure.

[Lab2 walkthrough](videohub:1_e88ydqwt)

Estimated Time: 15 minutes



### Objectives

In this lab, you will:

* Build, run and test the Helidon 4 Virtual thread application
* Build, run and test the Helidon 3 Reactive application
* Analyse the simplicity of the Virtual thread application comparative to Reactive application

### Prerequisites

To run this lab, you must have:

* Oracle Cloud Account
* Completed Lab 1, which install the required JDK and maven.

## Task 1: Build and Run the Helidon 4 application

1. Click *File* -> *Open* in Code Editor.
    ![Open Project](images/open-project.png)

2. Select *helidon-virtual-thread* folder and click *Open*.
    ![Helidon Project](images/helidon-project.png)
    > Please ignore the warnings/problems, you notice in Code Editor while opening this folder.


3. Open a new terminal, and then copy and paste the following command to set the PATH and JAVA_HOME variable.
    ```bash
    <copy>PATH=~/jdk-21.0.2/bin:~/apache-maven-3.8.3/bin:$PATH
    JAVA_HOME=~/jdk-21.0.2/</copy>
    ```

4. Copy the following command and run in the terminal to verify that required JDK and Maven version are configured properly.

    ```bash
    <copy>mvn -v</copy>
    ```

    you will have the output similar to the following:
    ```bash
    $ mvn -v
    Apache Maven 3.8.3 (ff8e977a158738155dc465c6a97ffaf31982d739)
    Maven home: /home/ankit_x_pa/apache-maven-3.8.3
    Java version: 21.0.2, vendor: Oracle Corporation, runtime: /home/ankit_x_pa/jdk-21.0.2
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "4.14.35-2047.529.3.2.el7uek.x86_64", arch: "amd64", family: "unix"
    $  
    ```

    > *You will use only this terminal for building and running the application as it has the required JDK and Maven version.*

5. Copy and paste the following command to build the blocking application.
    ```bash
    <copy>cd ~/helidon-virtual-thread/virtualthread/
    mvn clean package -DskipTests</copy>
    ```

    You will have output similar to the following:
    ```bash
    [INFO] --- maven-jar-plugin:3.0.2:jar (default-jar) @ example-virtual-thread ---
    [INFO] Building jar: /home/ankit_x_pa/helidon-virtual-thread/virtualthread/target/example-virtual-thread.jar
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  3.258 s
    [INFO] Finished at: 2024-02-21T08:20:52Z
    [INFO] ------------------------------------------------------------------------
    $
    ```

6. Copy and paste the following command in the terminal to run the blocking version of the application:
    ```bash
    <copy>java -jar target/example-virtual-thread.jar</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ java -jar target/example-virtual-thread.jar
    Feb 21, 2024 8:22:10 AM io.helidon.config.MetaConfigFinder lambda$findSource$9
    WARNING: Configuration file application.yaml is on classpath, yet there is no parser configured for it
    Feb 21, 2024 8:22:10 AM io.helidon.webserver.ServerListener start
    INFO: [0x20695538] http://0.0.0.0:38197 bound for socket '@default'
    Feb 21, 2024 8:22:10 AM io.helidon.common.features.HelidonFeatures features
    INFO: Helidon SE 4.0.5 features: [Config, Encoding, Media, WebClient, WebServer]
    Feb 21, 2024 8:22:10 AM io.helidon.webserver.LoomServer startIt
    INFO: Started all channels in 41 milliseconds. 645 milliseconds since JVM startup. Java 21.0.2+13-LTS-58
    ```

7. Write down the port number on which the server runs (see the log entry for @default). For example, in our output, the port number is 38197. Similarly, find out your server port number.

8. To open new terminal, click *Terminal* -> *New Terminal*. We will use this terminal to run *curl* commands. 
    ![New Terminal](images/new-terminal.png)
    

9. Copy and paste the following command into the new terminal. Don't forget to replace *`<port>`* with your server port.
    ```bash
    <copy>curl http://localhost:<port>/one</copy>
    ```
    You will have output similar to the following:
    ```bash
    curl http://localhost:38197/one
    remote_1
    $
    ```

10. Copy and paste the following command into the new terminal. Don't forget to replace to *`<port>`* with your server port.
    ```bash
    <copy>curl http://localhost:<port>/sequence</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ curl http://localhost:38197/sequence
    Combined results: [remote_2, remote_3, remote_4, remote_5, remote_6, remote_7, remote_8, remote_9, remote_10, remote_11]
    $
    ```
    > Notice the order of the results. As suggested by the name, this request invokes a remote resource multiple times in sequence.


11. Copy and paste the following command into the new terminal. Don't forget to replace to *`<port>`* with your server port.
    ```bash
    <copy>curl http://localhost:<port>/parallel</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ curl http://localhost:38197/parallel
    Combined results: [remote_21, remote_18, remote_12, remote_13, remote_14, remote_15, remote_16, remote_17, remote_19, remote_20]
    $
    ``` 
    > Notice the order of the results. As suggested by the name, this request invokes a remote resource multiple times in parallel.

12. Press the *Ctrl + C* in the terminal where *java -jar * command is running to to stop the server.

## Task 2: Build and Run the Reactive application

1. Copy and paste the following command to build the reactive application.
    ```bash
    <copy>cd ~/helidon-virtual-thread/reactive/
    mvn clean package -DskipTests</copy>
    ```

    You will have output similar to the following:
    ```bash
    [INFO] --- maven-dependency-plugin:3.0.0:copy-dependencies (copy-libs) @ example-reactive ---
    [INFO] 
    [INFO] --- maven-jar-plugin:3.0.2:jar (default-jar) @ example-reactive ---
    [INFO] Building jar: /home/ankit_x_pa/helidon-virtual-thread/reactive/target/example-reactive.jar
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  3.023 s
    [INFO] Finished at: 2024-02-21T08:25:36Z
    [INFO] ------------------------------------------------------------------------
    $
    ```

2. Copy and paste the following command in the terminal to run the reactive version of the application:
    ```bash
    <copy>java -jar target/example-reactive.jar</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ java -jar target/example-reactive.jar
    2024.02.21 08:30:28.921 Logging at initialization configured using classpath: /logging.properties
    2024.02.21 08:30:29.191 Configuration file application.yaml is on classpath, yet there is no parser configured for it
    2024.02.21 08:30:29.449 Helidon SE 3.2.5 features: [Config, Fault Tolerance, Tracing, WebServer]
    2024.02.21 08:30:29.601 Channel '@default' started: [id: 0x3ab38b5d, L:/0.0.0.0:33547]
    ```

3. Write down the port number on which the server runs (see the log entry for @default). For example, in our output, the port number is 33547. Similarly, find out your server port number.

4. Go back to the terminal, which we opened in Task 1 for running the curl command.
    
5. Copy and paste the following command into the new terminal. Don't forget to replace to *`<port>`* with your server port.
    ```bash
    <copy>curl http://localhost:<port>/one</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ curl http://localhost:33547/one
    remote_1
    $
    ```

6. Copy and paste the following command into the new terminal. Don't forget to replace to *`<port>`* with your server port.
    ```bash
    <copy>curl http://localhost:<port>/sequence</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ curl http://localhost:33547/sequence
    Combined results: [remote_2, remote_3, remote_4, remote_5, remote_6, remote_7, remote_8, remote_9, remote_10, remote_11]
    $
    ```
    > Notice the order of the results. As suggested by the name, this request invokes a remote resource multiple times in sequence.


7. Copy and paste the following command into the new terminal. Don't forget to replace to *`<port>`* with your server port.
    ```bash
    <copy>curl http://localhost:<port>/parallel</copy>
    ```
    You will have output similar to the following:
    ```bash
    $ curl http://localhost:33547/parallel
    Combined results: [remote_17, remote_16, remote_13, remote_20, remote_12, remote_19, remote_18, remote_14, remote_21, remote_15]
    $
    ``` 
    > Notice the order of the results. As suggested by the name, this request invokes a remote resource multiple times in parallel.

8. Press the *Ctrl + C* in the terminal where *java -jar * command is running to to stop the server.

## Task 3: Analyse the simplicity of the Helidon 4 application

**Virtual thread vs. Reactive**

Let’s compare the implementations between Virtual thread and Helidon SE (reactive) for the same task.

* Both implementations execute REST calls using the Helidon WebClient
* The Virtual thread implementation is straightforward to follow:
    - The execution flow is reflected by the statement order in the code
    - There are no calls to intricate or semantically-rich library calls
    - Debugging is straightforward
* Reactive versions require a good understanding of reactive libraries
    - Including Multi, flatMap, error handling, etc.
    - Control flow is no longer obvious due to use of reactive handlers
    - An understanding of flatMap's capability to enable/forbid concurrency is required
    - Debugging is more difficult


1. Open the *virtualthread/src/main/java/io/examples/helidon/virtualthread/BlockingService.java* file to see how endpoints are implemented in the blocking version of the application.
    ![Blocking Block](images/virtual-thread.png)

2. Open the *reactive/src/main/java/io/examples/helidon/reactive/ReactiveService.java* file to see how endpoints are implemented in the reactive version of the application.
    ![Reactive Service](images/reactive-service.png)

3. In *OPEN EDITORS* section, right click on the *BlockingService.java* file and select the *Select for Compare*.
    ![Select Compare](images/select-compare.png)

4. Right click on the *ReactiveService.java* file and select the *Compare with Selected*.
    ![Compare selected](images/compare-selected.png)


5. See that reactive code is more complicated than blocking (Virtual Thread)
    ![Compare code](images/compare-code.png)

    > Check methods one, sequence and parallel in BlockingService and ReactiveService respectively. See if you understand how they work!

You may now *proceed to the next lab*.

## Acknowledgements
* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, March 2025
