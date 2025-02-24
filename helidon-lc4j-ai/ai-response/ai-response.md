# Fine-Tune the Responses

## Introduction

Now that we have a working AI assistant, we can fine-tune it to provide better responses and a more natural conversational experience.

Estimated Time: 05 Minutes

### Objectives

In this lab, we will: 

* Add **chat memory** to maintain conversation context.  
* Customize the assistant’s behavior using a **System Message**.



## Task 1: Updating the AI Service - Adding Chat Memory and System Message

**Chat Memory** is a mechanism that stores past interactions in a conversation, allowing an AI model to maintain context, recall previous exchanges, and generate coherent, context-aware responses.</br>
*Why Do We Need Chat Memory?*</br>
By default, each user query is treated as an isolated request. This means the AI forgets previous interactions and lacks continuity in the conversation.</br>
In LangChain4J, **chat memory** helps the AI track ongoing discussions, making responses more cohesive and personalized.</br>
*Using `MessageWindowChatMemory`*</br>
LangChain4J provides `MessageWindowChatMemory`, a sliding window memory mechanism that keeps only the most recent interactions.</br>
To enable chat memory, annotate the AI service with `@Ai.ChatMemoryWindow(10)`, where `10` is the number of messages to retain.</br>


**Tuning the Prompt (System Message)**</br>
*Why Do We Need a System Message?*</br>
Currently, users can ask anything, and the assistant tries to answer every question. However, in a business scenario, we may want the assistant to:  
- **Stay on topic** and answer only menu-related questions.</br>
- **Maintain a specific persona and tone** (e.g., a friendly coffee shop assistant). </br> 
- **Politely refuse off-topic queries**.</br>

*Using a System Message*</br>
A **System Message** is a predefined instruction that sets rules for the AI model’s behavior, tone, and personality. It guides responses, ensuring they align with business needs.</br>
We will use the `@SystemMessage` annotation to provide instructions to our AI assistant.</br>


1. Modify `ChatAiService.java` to include chat memory and a system message:
    ```java
    <copy>@Ai.Service
    @Ai.ChatMemoryWindow(10)
    public interface ChatAiService {

        @SystemMessage("""
                You are Frank - a friendly coffee shop assistant helping customers with their orders.
                You must not answer any questions not related to the menu or placing orders.
                """)
        String chat(String question);
    }</copy>
    ```

    > **What This Does:**
    - **`@Ai.Service`** → Defines the interface as an AI service.
    - **`@Ai.ChatMemoryWindow(10)`** → Enables **chat memory** to retain the last **10 messages**.
    - **`@SystemMessage`** → Instructs the AI to:  
      - Adopt the persona of **Frank, a friendly coffee shop assistant**.  
      - **Politely refuse** unrelated questions.

## Task 2:  Testing the Fine-Tuned Assistant

1. Recompile and run the application:
    ```bash
    <copy>mvn clean package
    java -jar target/helidon-ai-hol.jar</copy>
    ```

2. Try asking an unrelated question:
    ```bash
    <copy>curl -G -X GET "http://localhost:8080/chat" --data-urlencode "question=What is the weather today?"</copy>
    ```

    > **Expected response:**
    "I'm here to help with the menu and taking orders! Would you like to know about our coffee options or maybe our pastries?"

3. Now ask a relevant question:
    ```bash
    <copy>curl -G -X GET "http://localhost:8080/chat" --data-urlencode "question=What do you offer today?"</copy>
    ```

    > **Expected response:**
    "We offer a variety of coffee drinks, including Latte, Espresso, Cappuccino, and more! Would you like to customize your drink?"


*Congratulations! You Have Completed the Hands-On Lab!* 


## Acknowledgements

* **Author** - Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi
* **Last Updated By/Date** - Ankit Pandey, February 2025