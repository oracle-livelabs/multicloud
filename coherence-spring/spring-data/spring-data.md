# Use Coherence Spring Data

## Introduction

The Spring Data Coherence module provides integration with Coherence data grids. Key functional areas of 
Spring Data Coherence are a POJO-centric model for interacting with a Coherence data grid and easily writing a Repository style data access layer.

We will change the **`DemoController`** in the last lab to show you how we can achieve similar results using **Spring Data**. 

Estimated time: 20 minutes

### Objectives

In this lab, you will:
     
* Include the dependencies for Coherence Spring Data
* Add a Customer Repository class
* Update the controller to only use Coherence Spring Data

### Prerequisites
     
* You should have completed the previous labs.

## Task 1: Create the CustomerRepository

1. In the base **`pom.xml`**, add the following dependency so you can use the **`CoherenceRepository`** interface:

    ```xml
      <copy><dependency>
        <groupId>com.oracle.coherence.spring</groupId>
        <artifactId>coherence-spring-data</artifactId>
        <version>${coherence-spring.version}</version>
      </dependency></copy>
    ```

2. Create a new file called **`CustomerRepository.java`** in the directory **`./src/main/java/com/oracle/coherence/demo/frameworks/springboot/`** with the following contents:

    ```java
     <copy>package com.oracle.coherence.demo.frameworks.springboot;

      import com.oracle.coherence.spring.data.config.CoherenceMap;
      import com.oracle.coherence.spring.data.repository.CoherenceRepository;

     @CoherenceMap("customers")
      public interface CustomerRepository extends CoherenceRepository<Customer, Integer> {
     }</copy>
    ```

    > Note: The Coherence **NamedMap** that will be used by the Repository implementation will be what is specified within the **@CoherenceMap** annotation.

## Task 2: Configure the Repository

As Coherence is, at its core, a key-value store, mapping Entities for use with a Coherence Repository is relatively simple as only the id needs to be annotated. It is possible to use either **`org.springframework.data.annotation.Id`** or **`jakarta.persistence.Id`** to denote the entity’s id.

1. Update the **`Customer.java`** class to include the **`org.springframework.data.annotation.Id`** annotation:
   
    ```java
      public class Customer {
     @JsonProperty("id")
     <copy>@org.springframework.data.annotation.Id</copy>
          private int id;
     ...
    ```
    
2. Add the following to the existing **`CoherenceConig.java`** to enable the repository.

    ```java
     @Configuration
     <copy>@EnableCoherence
     @EnableCoherenceRepositories</copy>
      public class CoherenceConfig {
    ```
    
    You will need to include the following imports:

    ```java
     <copy>import com.oracle.coherence.spring.configuration.annotation.EnableCoherence;
      import com.oracle.coherence.spring.data.config.EnableCoherenceRepositories;</copy>
    ```

3. Update **`DemoController.java`** to contain only the following, which removes the **`@CoherenceCache`** annotations as we are only using spring data, but storing it in the Coherence cache.

    ```java
     <copy>package com.oracle.coherence.demo.frameworks.springboot.controller;
    
      import com.oracle.coherence.demo.frameworks.springboot.Customer;
    
      import com.oracle.coherence.demo.frameworks.springboot.CustomerRepository;
    
      import org.springframework.beans.factory.annotation.Autowired;
      import org.springframework.http.ResponseEntity;
    
      import org.springframework.web.bind.annotation.DeleteMapping;
      import org.springframework.web.bind.annotation.GetMapping;
      import org.springframework.web.bind.annotation.PathVariable;
      import org.springframework.web.bind.annotation.PostMapping;
      import org.springframework.web.bind.annotation.RequestBody;
      import org.springframework.web.bind.annotation.RequestMapping;
      import org.springframework.web.bind.annotation.RestController;
    
      import java.util.Collection;
      import java.util.Optional;
      import java.util.stream.Collectors;
      import java.util.stream.StreamSupport;
    
     @RestController
     @RequestMapping(path = "/api/customers")
      public class DemoController {
    
     @Autowired
          private CustomerRepository customerRepository;
    
     @GetMapping
          public Collection<Customer> getCustomers() {
              return StreamSupport.stream(customerRepository.findAll().spliterator(), false)
     .collect(Collectors.toList());
     }
    
     @PostMapping
          public ResponseEntity<Void> createCustomer(@RequestBody Customer customer) {
              customerRepository.save(customer);
              return ResponseEntity.accepted().build();
     }
    
     @GetMapping("/{id}")
          public ResponseEntity<Customer> getCustomer(@PathVariable int id) {
              Optional<Customer> optionalCustomer = customerRepository.findById(id);
              return optionalCustomer.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
     }
    
     @DeleteMapping("/{id}")
          public void removeCustomer(@PathVariable int id) {
              customerRepository.findById(id).ifPresent(customer -> customerRepository.delete(customer));
     }
     }</copy>
    ```

4. In a terminal, issue the following command to build the application:

    ```bash
     <copy>mvn clean install -DskipTests</copy>
    ```

5. Then run the following command to start the application:

    ```bash
     <copy>java -jar target/springboot-1.0-SNAPSHOT.jar</copy>
    ```
6. In a separate terminal window, run the following command to insert a customer:

    ```bash
     <copy>curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "name": "Tim", "balance": 1000}' http://localhost:8080/api/customers</copy>
    ```

    > Note: You can verify the customer's cache by using VisualVM as we did in the previous lab. This shows the repository API is writing to and reading from Coherence. Ensure that you close the tab you opened with the previous process and double-click on the new (`springboot-1.0-SNAPSHOT.jar`) process.

    You can also verify by running the following:
    ```bash
     <copy>curl http://localhost:8080/api/customers/1</copy>
    ```   

    You should see an output similar to the following.

    ```json 
     {"id":1,"name":"Tim","balance":1000.0}
    ```

## Learn More

* [Coherence Spring](https://docs.coherence.community/coherence-spring/docs/latest/)    
* [Coherence Spring Data](https://docs.coherence.community/coherence-spring/docs/latest/refdocs/reference/html/spring-data.html#spring-data)



## Acknowledgements

* **Author** - Tim Middleton
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, April 2025