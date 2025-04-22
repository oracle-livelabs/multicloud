# Add Events

## Introduction

Event-driven patterns are a common way to build scalable applications and microservices. 
Coherence produces a number of events that can be used by applications to respond to data changes and other actions in Coherence.

There are two main types of events in Coherence:

* [Map Events](https://docs.oracle.com/en/middleware/fusion-middleware/coherence/14.1.2/develop-applications/using-map-events.html) which are subscribed to using a `MapListener` - in Spring annotated by `@CoherenceEventListener` only
* [Live Events](https://docs.oracle.com/en/middleware/fusion-middleware/coherence/14.1.2/develop-applications/using-live-events.html) which are subscribed to using an `EventInterceptor` - in Spring annotated by `@CoherenceEventListener` and `@Synchronous`

Spring makes subscribing to both of these event-types and others, much simpler by using observer methods annotated 
with `@CoherenceEventListener` and optionally `@Synchronous`.

Estimated time: 15 minutes

### Objectives

In this lab, you will:
       
* Add MapListeners on the customer's cache to show when data has been modified
* Add Synchronous EventInterceptors, (Partitioned Cache Events) to modify data as it is being updated          

      > Note: there are other events in the Live Events area which we do not cover in this lab, including the following:
      * **Partitioned Cache Lifecycle Events** - A set of events that represent the operations for creating a cache, destroying a cache, and clearing all entries from a cache.
      * **Partitioned Service Events** - A set of events that represent the operations being performed by a partitioned service. Partitioned service events include both partition transfer events and partition transaction events. Partition transfer events are related to the movement of partitions among cluster members. Partition transaction events are related to changes that may span multiple caches and are performed within the context of a single request.
      * **Lifecycle Events** - A set of events that represent the activation and disposal of a ConfigurableCacheFactory instance.
      * **Federation Events** -  A set of events that represent the operations being performed by a federation service. Federation events include both federated connection events and federated change events. Federated connection events are related to the interaction of federated participants and federated change events are related to cache updates.
            
      > See the `Learn More` section below for documentation links.

### Prerequisites

You should have completed the previous labs.

## Task 1: Adding MapListeners

In this task, we will add Coherence event listeners to respond to cache **`MapEvents`**.  
A `MapEvent` observer method is a method on a Spring bean that is annotated with **`@CoherenceEventListener`**. 
The annotated method must have a void return type and must take a single method parameter of type **`MapEvent`**, 
typically this has the generic types of the underlying map/cache key and value.

These observe methods, can respond to insert, update or delete events and contain the new value for insert, the old and new value
for updates and the old value for deletes. You can also filter events based on a where clause.

1. Open the file **`./src/main/java/com/oracle/coherence/demo/frameworks/springboot/controller/DemoController.java`** in VisualStudio code and add the following to the end of the file.
   
    ```java
     <copy>/**
     * Listener that will be fired upon insertion of a new {@link Customer}.
     * @param event event
     */
     @CoherenceEventListener
      public void onCustomerInserted(@Inserted @CacheName("customers") MapEvent<Integer, Customer> event) {
          Logger.info(String.format("Inserted customer key=%d, value=%s", event.getKey(), event.getNewValue()));
     }

      /**
     * Listener that will be fired upon deletion of a {@link Customer}.
     * @param event event
     */
     @CoherenceEventListener
      public void onCustomerDeleted(@Deleted @CacheName("customers") MapEvent<Integer, Customer> event) {
          Logger.info(String.format("Deleted customer key=%d, old value=%s", event.getOldEntry().getKey(), event.getOldValue()));
     }

      /**
     * Listener that will be fired upon update of a {@link Customer}.
     * @param event event
     */
     @CoherenceEventListener
      public void onCustomerUpdated(@Updated @CacheName("customers") MapEvent<Integer, Customer> event) {
          Logger.info(String.format("Updated customer key=%d, old value=%s, new value=%s", event.getKey(), event.getOldValue(), event.getNewValue()));
     }
   
      /**
     * Listener that will be fired upon update of a {@link Customer} where the new balance < 1000.
     * Note: the 1000.0d indicates to Coherence this is a double value.
     * @param event event
     */
     @CoherenceEventListener
     @WhereFilter("balance < 1000.0d")
      public void onCustomerUpdatedLowBalance(@Updated @CacheName("customers") MapEvent<Integer, Customer> event) {
          Logger.info(String.format("Low balance for customer, Updated customer key=%d, value=%s", event.getKey(), event.getNewValue()));
     }</copy>
    ``` 

    Looking a one of the methods **`onCustomerInserted`**, this is annotated as **`@CoherenceEventListener**`**, which indicates to Coherence that this is an event listener. The **`@Inserted`** annotation indicates this should be run only on insert events and the **`@CacheName`** specifies the cache that this listener applies to.

    Note: You will also have to add the following imports:
   
    ```java
    <copy>import com.oracle.coherence.common.base.Logger;
    import com.oracle.coherence.spring.annotation.event.CacheName; 
    import com.oracle.coherence.spring.annotation.event.Deleted; 
    import com.oracle.coherence.spring.annotation.event.Inserted;
    import com.oracle.coherence.spring.annotation.event.Updated;
    import com.oracle.coherence.spring.event.CoherenceEventListener;
    import com.tangosol.util.MapEvent;
    import com.oracle.coherence.spring.annotation.WhereFilter;</copy>
    ```
    > *In the **VS Code**, Click **File** -> **Auto Save** to save this file*.

2. In a terminal, issue the following command to build the application:

    ```bash
     <copy>mvn clean install -DskipTests</copy>
    ```

3. Then run the following command to start the application:

    ```bash
     <copy>java -jar target/springboot-1.0-SNAPSHOT.jar</copy>
    ```
             
4. In a new terminal window, run the following command to insert a customer:

    ```bash
     <copy>curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "name": "Tim", "balance": 1000}' http://localhost:8080/api/customers</copy>
    ```      
   
    You should see output similar to the following showing the event listener firing:

    ```bash
     ... Inserted customer key=1, value=Customer{id=1, name='Tim', balance=1000.0}   
    ```

5. Run the following command, (note the changed balance) to update the customer:

    ```bash
     <copy>curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "name": "Tim", "balance": 5000}' http://localhost:8080/api/customers</copy>
    ```      
   
    You should see output similar to the following showing the new and old values captured.

    ```bash
     ... Updated customer key=1, old value=Customer{id=1, name='Tim', balance=1000.0}, 
     new value=Customer{id=1, name='Tim', balance=5000.0}
    ```
    
6. Run the following to change the balance to $500. This will then cause the low-balance listener to trigger based on the where clause:

    ```bash
     <copy>curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "name": "Tim", "balance": 500}' http://localhost:8080/api/customers</copy> 
    ``` 
   
    You should see output showing two event listeners firing, one for the low balance and one for the general update. 

    ```bash
     Low balance for customer, Updated customer key=1, value=Customer{id=1, name='Tim', balance=500.0}
     Updated customer key=1, old value=Customer{id=1, name='Tim', balance=5000.0}, new value=Customer{id=1, name='Tim', balance=500.0}
    ```   
   
    > Note: When using where clauses, you should consider adding indexes on fields in the where clause for more efficient access. See the [Documentation](https://docs.oracle.com/en/middleware/fusion-middleware/coherence/14.1.2/develop-applications/querying-data-cache.html#GUID-75243AC5-8FF4-4485-8754-25FE8B3A8101) for more information.
    
7. Run the following to delete customer 1:

    ```bash
     <copy>curl -X DELETE http://localhost:8080/api/customers/1</copy>
    ``` 
   
    You should see an output showing the old value of the deleted customer.

    ```bash
     Deleted customer key=1, old value=Customer{id=1, name='Tim', balance=500.0}
    ```

8. To start a second application server without the HTTP server, Open a **new tab** in the terminal and run the following command:

    ```bash
    <copy>cd ~/spring-workshop-01-base/
    java -Dserver.port=-1 -Dloader.main=com.tangosol.net.Coherence -Dcoherence.management.http=none -jar target/springboot-1.0-SNAPSHOT.jar </copy>
    ```   
 
    Once the second server starts up you should see the following message on the first server console. This indicates that the cluster has partitioned the data between the two members for high availability.

    ```bash
     Partition ownership has stabilized with 2 nodes
    ```

9. Run the following command, (note the changed balance) to update the customer:

    ```bash
     <copy>curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "name": "Tim", "balance": 6000}' http://localhost:8080/api/customers</copy>
    ```      
   
    You should see output similar to the following showing the new customer **on both servers**.

    ```bash
     ... Inserted customer key=1, value=Customer{id=1, name='Tim', balance=6000.0}
    ```        

    Note: The reason for both members receiving the events is that each of the servers has registered for it. This is fine for responding to events,but in the next lab we cover how we can write interceptors to work with or modify data before, during or after it has been added to the cluster. 
    
## Task 2: Adding EventInterceptor to mutate data
    
An EntryEvent is emitted when data is mutated on a cache. These events are only emitted on the storage-enabled member 
that is the primary owner of the entry that is mutated. The `@Synchronous` annotation is added to indicate this is an `EventInterceptor`.

For example, the onEvent method below will receive entry events for all caches.

```java
@CoherenceEventListener
@Synchronous
public void onEvent(EntryEvent event) {
    // TODO: process the event
}
```

There are a number of different EntryEvent types:

* Inserting - an entry is being inserted into a cache, use the @Inserting annotation
* Inserted - an entry has been inserted into a cache, use the @Inserted annotation
* Updating - an entry is being updated in a cache, use the @Updating annotation
* Updated - an entry has been updated in a cache, use the @Updated annotation
* Removing - an entry is being deleted from a cache, use the @Removing annotation
* Removed - an entry has been deleted from a cache, use the @Removed annotation
           
In this section, we will create an `Inserting` or `Updating` listener to modify data during or after is committed to the cache.

To restrict the EntryEvent types received by a method apply one or more of the annotations above to the method parameter. For example, the method below will receive Inserted and Removed events.
  
```java
@CoherenceEventListener
@Synchronous
public void onEvent(@Inserted @Removed EntryEvent event) {
    // TODO: process the event
}
```


1. Add an event listener that will ensure that a customer's name is always uppercase.

 Open the file **`./src/main/java/com/oracle/coherence/demo/frameworks/springboot/controller/DemoController.java`** in VisualStudio code and add the following to the end of the file.
  
    ```java 
     <copy>/**
     * Listener that will be fired on a storage-enabled node while an entry is being inserted or updated.
     * The modified value of the {@link Customer} is saved to the cache.
     * @param event event
     */
     @CoherenceEventListener
     @Synchronous
      public void uppercaseInterceptor(@Inserting @Updating @CacheName("customers") EntryEvent<Integer, Customer> event) {
          BinaryEntry<Integer, Customer> entry = event.getEntry();
          Customer                       customer = entry.getValue();

          customer.setName(customer.getName().toUpperCase());
          //The following ensures the value is updated before it's committed to the backing map
          entry.setValue(customer);
     }</copy>
    ```  
    
    Note: You will also have to add the following imports:

    ```java
    <copy>import com.oracle.coherence.spring.annotation.event.Inserting;
    import com.oracle.coherence.spring.annotation.event.Updating;
    import com.oracle.coherence.spring.annotation.event.Synchronous;
    import com.tangosol.net.events.partition.cache.EntryEvent;
    import com.tangosol.util.BinaryEntry;</copy>
    ```

    > Note: It is important that the amount of work you do within a synchronous event listener is minimized as you are holding an implicit exclusive lock on the entry while this code runs. You should not be doing any operations that do external calls to other systems as this will affect the performance and throughput of the cluster.
   
2. In a terminal, issue the following command to build the application:

    ```bash
     <copy>mvn clean install -DskipTests</copy>
    ```

3. Then run the following command to start the application:

    ```bash
     <copy>java -jar target/springboot-1.0-SNAPSHOT.jar</copy>
    ```
             
4. In a new terminal window, run the following command to insert a customer:

    ```bash
     <copy>curl -X POST -H "Content-Type: application/json" -d '{"id": 1, "name": "Tim", "balance": 1000}' http://localhost:8080/api/customers</copy>
    ```      
      
    You should see output from the original listener showing the inserted value with the uppercase name:

    ```bash
     Inserted customer key=1, value=Customer{id=1, name='TIM', balance=1000.0}
    ```   
      
5. Confirm the data is stored correctly by issuing the following:

    ```bash
     <copy>curl http://localhost:8080/api/customers/1</copy>
    ```   
   
    You should see an output similar to the following indicating that the customer has been retrieved and the name is in fact uppercase.

    ```json 
     {"id":1,"name":"TIM","balance":1000.0}
    ```  
    > *Press **Ctrl + C** in both the tab, to stop the running server.*

## Learn More
  
* [Map Events Documentation](https://docs.oracle.com/en/middleware/fusion-middleware/coherence/14.1.2/develop-applications/using-map-events.html)
* [Live Events Documentation](https://docs.oracle.com/en/middleware/fusion-middleware/coherence/14.1.2/develop-applications/using-live-events.html)

## Acknowledgements

* **Author** - Tim Middleton
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, April 2025