# Enable Coherence Spring Session

## Introduction

In this chapter, you will learn how to configure Coherence as an HTTP session store using Spring Session.

We will modify the previous REST endpoints by adding a simple 'hello' service that will allow us to set and change session attributes.

Estimated time: 15 minutes

### Objectives

In this lab, you will:

* Configure Spring Session
* Add a **`SessionController`** service to read and write to HTTP Sessions
* View the session information in VisualVM

### Prerequisites

You should have completed the previous labs.

## Task 1: Configure Spring Session

1. In the base **`pom.xml`**, add the following dependency so you can use Coherence Spring Session:

    ```xml
      <copy><dependency>
        <groupId>com.oracle.coherence.spring</groupId>
        <artifactId>coherence-spring-session</artifactId>
        <version>${coherence-spring.version}</version>
      </dependency></copy>
    ```

2. Add the **`@EnableCoherenceHttpSession`** annotation to the existing annotations in **`CoherenceConig.java`** to enable the Coherence Spring Session.

    ```java
     <copy>@EnableCoherenceHttpSession(
     cache = "spring:session:sessions",
     flushMode = FlushMode.ON_SAVE,
     sessionTimeoutInSeconds = 1800,
     useEntryProcessor = true
     )</copy>
      public class CoherenceConfig {
     ...      
     }
    ```

    Note: You will also have to add the following imports:
 
    ```bash
     <copy>import com.oracle.coherence.spring.session.config.annotation.web.http.EnableCoherenceHttpSession;
      import org.springframework.session.FlushMode;</copy>
    ```
    
    Notes regarding the above:      
    
      * **`@EnableCoherenceHttpSession`** - Enables Spring Session support for Coherence
      * **`session`** - not used in the above example, specifies the name of the Coherence Session. Optional, Defaults to Coherence' default session.
      * **`cache`** - The name of the cache to use. Optional. Defaults to spring:session:sessions.
      * **`flushMode`** - The FlushMode to use. Optional. Defaults to FlushMode.ON_SAVE.
      * **`sessionTimeoutInSeconds`** The session timeout. Optional. Defaults to 1800 seconds (30 minutes)
      * **`useEntryProcessor`** - () When doing HTTP session updates, shall we use a Coherence entry processor? The default is {@code true}.

3. Enable POF serializer by adding the file **`example-pof-config.xml`** in **`src/main/resources`**:

    ```xml
      <copy><?xml version="1.0"?>
      <pof-config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://xmlns.oracle.com/coherence/coherence-pof-config"
         xsi:schemaLocation="http://xmlns.oracle.com/coherence/coherence-pof-config coherence-pof-config.xsd">
    
        <user-type-list>
          <include>coherence-pof-config.xml</include>
          <user-type>
            <type-id>2001</type-id>
            <class-name>org.springframework.session.MapSession</class-name>
            <serializer>
              <class-name>com.oracle.coherence.spring.session.serialization.pof.MapSessionPofSerializer</class-name>
            </serializer>
          </user-type>
          <user-type>
            <type-id>4000</type-id>
            <class-name>com.oracle.coherence.spring.session.SessionUpdateEntryProcessor</class-name>
          </user-type>
        </user-type-list>
      </pof-config></copy>
    ```

    > Note: The above enables specific POF serialization required by Coherence Spring Session when using POF. Also as we are using entry processors, we must also specify the **`SessionUpdateEntryProcessor`** class. 

4. Specify to use the above POF config file by adding the following to **`src/main/resources/application.properites`**: 

    ```properties
    <copy>coherence.pof.config=example-pof-config.xml</copy>
    ```
 
5. Add a new class called **`SessionController.java`** in the same package as **`DemoController.java`** with the following contents:

    ```java
     <copy>package com.oracle.coherence.demo.frameworks.springboot.controller;

      import jakarta.servlet.http.HttpSession;
      import org.apache.logging.log4j.LogManager;
      import org.apache.logging.log4j.Logger;
      import org.springframework.beans.factory.annotation.Autowired;
      import org.springframework.http.ResponseEntity;
      import org.springframework.stereotype.Controller;
      import org.springframework.web.bind.annotation.GetMapping;
      import org.springframework.web.bind.annotation.PathVariable;
      import org.springframework.web.bind.annotation.RequestMapping;
      
     @Controller
     @RequestMapping(path = "/api/session")
      public class SessionController {

          private static final Logger logger = LogManager.getLogger(SessionController.class);

     @Autowired
          private HttpSession session;

          /**
     * Increments the specified counter variable on each request.
     * @param counter the counter name to increment
     * @return a simple String containing the counter and the session id.
     */
     @GetMapping("/{counter}")
          public ResponseEntity<String> updateCounter(@PathVariable String counter) {
              Integer counterValue = (Integer) this.session.getAttribute(counter);
              if (counterValue == null) {
     counterValue = 1;
                  this.session.setAttribute(counter, counterValue);
     }
              else {
     counterValue++;
                  this.session.setAttribute(counter, counterValue);
     }

              logger.info("Session ID: {}; counterValue = {}", this.session.getId(), counterValue);
              return ResponseEntity.ok(this.session.getId() + " " + counter + "=" + counterValue + "\n");
     }

          /**
     * Deletes the specified counter variable.
     * @param counter the counter name to delete
     */
     @GetMapping("/delete/{counter}")
         public ResponseEntity<String> deleteCounter(@PathVariable String counter) {
             this.session.removeAttribute(counter);

             logger.info("Session ID: {}; deleted counter = {}", this.session.getId(), counter);
             return ResponseEntity.ok(this.session.getId() + " deleted counter " + counter + "\n");
     }

         /**
     * Invalidates the {@link HttpSession} session.
     */
     @GetMapping("/invalidate")
         public ResponseEntity<String> invalidate() {
             this.session.invalidate();

             logger.info("Session ID: {}; Invalidated", this.session.getId());
             return ResponseEntity.ok(this.session.getId() + " invalidated\n");
     }
     }</copy>
    ```

    The example above exposes two endpoints where we can issue CURL requests to increment a specific session attribute or remove a session attribute.
      
    This uses the standard Spring **`HttpSession`** which has been wired through the previous step to use Coherence. 

## Task 2: Build and run the example

In this step, we will run various CURL commands a number of times and observe the behaviour of the responses and view the session cache in Coherence.  We will use the **`-c`** option of curl to save and utilize session cookies to ensure proper session association.

1. In a terminal, issue the following command to build the application:

    ```bash
    <copy>mvn clean install -DskipTests</copy>
    ```

2. Then run the following command to start the application:

    ```bash
    <copy>java -jar target/springboot-1.0-SNAPSHOT.jar</copy>
    ```

3. In a separate terminal window, run the following command to access the **`/api/session`** resource with the session attribute **`counter1`**:

    ```bash
    <copy>curl -i -c cookie.txt http://localhost:8080/api/session/counter1</copy>
    ```
   
    The output should be similar to the following and the cookie information will be stored in the file **`cookie.txt`**.

    ```bash
     HTTP/1.1 200
     Set-Cookie: SESSION=Zjk5NTRlMWItMzVkNC00YTJkLThhNjktNWYyMDZkZjZiMTI1; Path=/; HttpOnly; SameSite=Lax
     Content-Type: text/plain;charset=UTF-8
     Content-Length: 48
     Date: Tue, 01 Apr 2025 04:58:16 GMT

     f9954e1b-35d4-4a2d-8a69-5f206df6b125 counter1=1
    ```
   
    > Note: You should also be seeing a log message in the Spring application indicating what is happening.

4. In the same terminal, run the following command to issue the CURL command to use the cookie from the file.

    ```bash
    <copy>curl -i -b cookie.txt http://localhost:8080/api/session/counter1</copy>
    ```

    You will see the output shows the **`counter1`** attribute with a value of **2** as we have specified to use the same cookie to ensure proper session association.

    ```bash
    f9954e1b-35d4-4a2d-8a69-5f206df6b125 counter1=2  
    ```

    > Note: You can verify the **`spring:session:sesisons`** cache by using VisualVM as we did in the previous lab. You should see there is one entry for our session. Ensure that you close the tab you opened with the previous process and double-click on the new (`springboot-1.0-SNAPSHOT.jar`) process.

5. Execute the command multiple times to keep incrementing the session:

    ```bash
    <copy>curl -i -b cookie.txt http://localhost:8080/api/session/counter1</copy>
    ```

6. Access the URL `http://localhost:8080/api/session/counter1` via a web browser.
 
    You will see a second cache entry in VisualVM as the browser is a new session. The counter will also increase each time you refresh.

7. Access the URL `http://localhost:8080/api/session/counter2` via a web browser.
 
    Keep refreshing the browser to increase the new counter.

8. Access the URL `http://localhost:8080/api/session/invalidate` via a web browser.

    This will invalidate the session, then access `http://localhost:8080/api/session/counter2` and you will see the counter start incrementing again as the session was invalidated.

## Task 3: Change the session timeout to 30 seconds

In this task, we will change the session timeout from 1800 seconds to 30 seconds and observe the results.

1. Edit the file **`CoherenceConig.java`** and change the **`sessionTimeoutInSeconds`** to 30.

    ```java
     @EnableCoherenceHttpSession(
     cache = "spring:session:sessions",
     flushMode = FlushMode.ON_SAVE,
     sessionTimeoutInSeconds = <copy>30</copy>,
     useEntryProcessor = true
     )
      public class CoherenceConfig {
     ...      
     }
    ```       

2. Stop, rebuild and re-run the application as described previously.

3. Re-open VisualVM and connect to the new process.

4. Access the URL `http://localhost:8080/api/session/counter1` via a web browser.

    You will see a second cache entry in VisualVM as the browser is a new session. The counter will also increase each time you refresh.

5. Wait for more than 30 seconds and ensure that you see no entries in the cache. This means the session was invalidated.    

6. Access the browser and you will see a new session created and the counter start a 1.
   
## Learn More
            
* [Coherence Spring Session](https://docs.coherence.community/coherence-spring/docs/latest/refdocs/reference/htmlsingle/index.html#spring-session)

## Acknowledgements

* **Author** - Tim Middleton
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, April 2025