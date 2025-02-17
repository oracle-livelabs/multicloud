#  Fill the EmbeddingStore

## Introduction

To enable our AI assistant to **retrieve menu-related information**, we need to fill the **embedding store** with structured business data.

Estimated Time: 10 minutes

### Objectives

In this lab, we will:  

* Create an **ingestor** to process and store menu items as embeddings.  
* Generate meaningful **text representations** of menu items.  
* Fill the embedding store during application startup.


## Task 1: Create an `MenuItemsIngestor`

**What is an Ingestor?**

An **ingestor** is a component responsible for **processing and adding data** into an embedding store by converting raw text or documents into embeddings. These embeddings enable **semantic searches** in AI-driven applications.

We will use LangChain4J’s `EmbeddingStoreIngestor`, which simplifies the ingestion process.

We will implement the ingestor as a **service** and inject all required components using **constructor injection**.

1. Right click on `io.helidon.hol.lc4j.ai`, and select **New File** and Enter **`MenuItemsIngestor.java`** as name.
    ```bash
    <copy>MenuItemsIngestor.java</copy>
    ```
2. Copy and paste the following content in `MenuItemsIngestor.java`
    ```java
    <copy>package io.helidon.hol.lc4j.ai;

    import io.helidon.hol.lc4j.data.MenuItemsService;
    import io.helidon.service.registry.Service;
    import dev.langchain4j.model.embedding.EmbeddingModel;
    import dev.langchain4j.store.embedding.EmbeddingStore;
    import dev.langchain4j.data.segment.TextSegment;
    import io.helidon.common.config.Config;
    import io.helidon.hol.lc4j.data.MenuItem;
    import dev.langchain4j.data.document.Document;
    import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;

    @Service.Singleton
    public class MenuItemsIngestor {
        private final EmbeddingStore<TextSegment> embeddingStore;
        private final EmbeddingModel embeddingModel;
        private final MenuItemsService menuItemsService;

        @Service.Inject
        public MenuItemsIngestor(Config config,
                                EmbeddingStore<TextSegment> embeddingStore,
                                EmbeddingModel embeddingModel,
                                MenuItemsService menuItemsService) {
            this.embeddingStore = embeddingStore;
            this.embeddingModel = embeddingModel;
            this.menuItemsService = menuItemsService;
        }
    }</copy>
    ```

    > **What This Does:**
    - **Marks the class as a Helidon-managed singleton** (`@Service.Singleton`).
    - **Injects dependencies**:
        - `EmbeddingStore<TextSegment>` → Embedding store.
        - `EmbeddingModel` → Embedding model.
        - `MenuItemsService` → Provides access to menu items.


## Task 2: Creating a Text Representation of `MenuItem`

To convert menu items into embeddings, we need a **structured text representation**.

The **formatted text** should look like this:

> Latte: A rich espresso drink with steamed milk. Category: Drink. Price: $4.50. Tags: Hot, Customizable, Classic. Add-ons: Oat milk, Soy milk, Extra shot, Caramel syrup.

1. Add the following method to **`MenuItemsIngestor.java`**:
    ```java
    <copy>private Document generateDocument(MenuItem item) {
        var str = String.format(
                "%s: %s. Category: %s. Price: $%.2f. Tags: %s. Add-ons: %s.",
                item.getName(),
                item.getDescription(),
                item.getCategory(),
                item.getPrice(),
                String.join(", ", item.getTags()),
                String.join(", ", item.getAddOns())
        );

        return Document.from(str);
    }</copy>
    ```

    > **What This Does:**
    - Formats menu item details into a single string.
    - Uses `String.format()` to ensure clear and readable text.
    - Returns a `Document` object that can be processed into embeddings.

## Task 3: Filling the Embedding Store

Now, we are ready to ingest menu items into the embedding store.

1. Add the following `ingest()` method to **`MenuItemsIngestor.java`**:
    ```java
    <copy>public void ingest() {
        // Create an ingestor with the given embedding model and embedding store
        var ingestor = EmbeddingStoreIngestor.builder()
                .embeddingModel(embeddingModel)
                .embeddingStore(embeddingStore)
                .build();

        // Read menu items from JSON
        var menuItems = menuItemsService.getMenuItems();

        // Convert menu items into text documents
        var documents = menuItems.stream()
                .map(this::generateDocument)
                .toList();

        // Process and store embeddings
        ingestor.ingest(documents);
    }</copy>
    ```

    > **What This Does:**
    - Creates an `EmbeddingStoreIngestor` using the provided embedding model and store.
    - Retrieves menu items from the `MenuItemsService`.
    - Converts menu items into structured text (`generateDocument`).
    - Processes the text into embeddings and stores them in the embedding store.

## Task 4: Calling the Ingestor at Application Startup

We need to trigger ingestion when the application starts.

1. Modify the **`ApplicationMain.java`** as shown below:
    ```java
    <copy>import io.helidon.hol.lc4j.ai.MenuItemsIngestor;

    public class ApplicationMain {
        public static void main(String[] args) {
        // Ensure logging is configured before anything else
        LogConfig.configureRuntime();

        var config = Services.get(Config.class);

        // Initialize and populate the embedding store
        Services.get(MenuItemsIngestor.class)
                .ingest();

        // Start the Helidon Web Server
        WebServer.builder()
                .config(config.get("server"))
                .routing(routing -> routing.register("/", Services.get(ChatBotService.class)))
                .build()
                .start();
    }
    }</copy>
    ```

    > **What This Does:**
    - Ensures logging is initialized first.
    - Calls `ingest()` to fill the embedding store before starting the web server.
    - Starts the **Helidon Web Server** to start serving our `ChatBotService`.

## Task 5: Testing the AI Assistant with RAG

Now that our application has menu data in the embedding store, we can ask the AI assistant questions about the menu!

1. Run the application:
    ```bash
    <copy>mvn clean package
    java -jar target/helidon-ai-hol.jar</copy>
    ```

2. Try querying the assistant:
    ```bash
    <copy>curl -X GET http://localhost:8080/chat?question="What%20can%20you%20offer%20today?"
    ```

    > Sample Test Questions
    Here are **five questions** to test whether the **assistant retrieves relevant menu items** from the embeddings store:
    **"What hot drinks do you have?"**
    - *Expected response:* A list of hot drinks like **Latte, Cappuccino, Espresso, and Hot Chocolate**.
    **"Do you have any vegan options?"**
    - *Expected response:* Items like **Avocado Toast, Iced Matcha Latte (with non-dairy milk options), and Blueberry Muffin (if applicable).**
    **"I’m looking for something sweet. What do you recommend?"**
    - *Expected response:* Items like **Caramel Frappuccino, Blueberry Muffin, Chocolate Chip Cookie, and Hot Chocolate**.
    **"What drinks can I get with caramel?"**
    - *Expected response:* **Caramel Frappuccino** and **Latte with caramel syrup add-on**.
    **"Do you have any breakfast items?"**
    - *Expected response:* **Avocado Toast, Blueberry Muffin, and Bagel with Cream Cheese**.


## Acknowledgements

* **Author** - Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, February 2025