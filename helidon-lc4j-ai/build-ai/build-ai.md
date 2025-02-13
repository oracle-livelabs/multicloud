# Build an AI Service

## Introduction

### Why Do We Need an AI Service?

LLM-powered applications typically require more than just a **chat model**. To provide **advanced AI functionality**, we also need:

- **Embedding models**
- **Embedding storage**
- **Chat memory** (to remember conversation history)
- **Other AI components**

Instead of managing these separately, we can use **LangChain4J AI Services**, which combine different AI components into a single service and make them work together.

Helidon’s **LangChain4J integration** makes it easy to create AI Services using **Helidon Inject**.


### Objectives

In This Section, We Will:

* Implement an **AI Service**.
* Modify our **RESTful service** to use the AI Service instead of calling the chat model directly.
* Testing the AI Service.


## Task 1: Creating the AI Service

An **AI Service** is a user-defined interface annotated with `@Ai.Service`. By default, it **automatically integrates all LangChain4J (LC4J) components** registered in Helidon's service registry. This means that if no specific configuration is provided, the service will use all available AI components.

At this stage, only the **`ChatLanguageModel`** has been configured, so it will be **automatically injected** into the service. Later, we will extend the AI Service by adding **embedding storage, chat memory**, and other components to enhance its capabilities.

1. We will keep all AI-related classes in `io.helidon.hol.lc4j.ai` package. Right click on `io.helidon.hol.lc4j` and select **New Folder** and Enter name **ai**.

2. Right click on `io.helidon.hol.lc4j.ai`, and select **New File** and Enter **`ChatAiService.java` as name.
    ```bash
    <copy>ChatAiService.java</copy>
    ```
3. Copy and paste the following content in `MenuItem.java`
    ```bash
    <copy>package io.helidon.hol.lc4j.ai;

    import io.helidon.integrations.langchain4j.Ai;

    import dev.langchain4j.service.SystemMessage;

    @Ai.Service
    public interface ChatAiService {

        String chat(String question);
    }</copy>
    ```

## Task 2:  Updating the RESTful Service

Now, let's modify our existing `ChatBotService.java` to use the **AI Service** instead of interacting with the chat model directly.

### **Before:**

Previously, `ChatLanguageModel` was injected into `ChatBotService` and called directly:

```java
var answer = chatModel.generate(question);
```

### **After:**

Now, we will inject and use `ChatAiService` instead:

```java
var answer = chatAiService.chat(question);
```

1. Replace the existing content of `ChatBotService.java` with the below one:
    ```bash
    <copy>
    @Service.Singleton
    public class ChatBotService implements HttpService {

        private final ChatAiService chatAiService;

        @Service.Inject
        public ChatBotService(ChatAiService chatAiService) {
            // Injecting ChatAiService using constructor injection
            this.chatAiService = chatAiService;
        }

        @Override
        public void routing(HttpRules httpRules) {
            httpRules.get("/chat", this::chatWithAssistant);
        }

        private void chatWithAssistant(ServerRequest req, ServerResponse res) {
            // Reading the `question` query parameter from the request. 
            var question = req.query().get("question");

            // Calling the AI service to get the answer
            var answer = chatAiService.chat(question);

            // Return the answer
            res.send(answer);
        }
    }</copy>
    ```

## Task 3: Testing the AI Service

1. Recompile and run the application:
    ```bash
    <copy>mvn clean package
    java -jar target/helidon-ai-hol.jar</copy>
    ```

2. Copy and paste the following command in the other terminal to test the application.
    ```bash
    <copy>curl -X GET "http://localhost:8080/chat?question=Hello"</copy>
    ```

    **Expected Result:** The response should still be an AI-generated answer, just like before.

## Acknowledgements

* **Author** - Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, February 2025