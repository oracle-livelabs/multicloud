# Introduction

## About this Workshop

In this workshop, you will build an AI-powered chat assistant for a coffee shop using Helidon and LangChain4J. The assistant will understand natural language, provide menu recommendations, and guide users through the ordering process.

Estimated time: 90 minutes

### Objectives

In this workshop, you will learn:


* How to use Helidon and LangChain4J to build an AI-powered assistant.
* How to use Helidon Inject for dependency injection.
* How to create embeddings from structured data and store them in an embeddings store.
* How to query the embeddings store using natural language.
* What ingestors and content providers are, and how to implement them.
* How to fine-tune your AI assistant for better responses.

### Prerequisites

The Helidon HOL works smoothly on Linux, macOS, or Windows, as long as you have a reasonably up-to-date operating system.

The most important requirement is having the latest JDK! You will also need Maven 3.8+ and a Java IDE of your choice. While our screenshots feature VS Code, you are free to use any IDE you're comfortable with.

To summarize the prerequisites, you need:

* JDK 21+ (newer versions are encouraged!)
* Maven 3.8+
* For Linux: glibc 2.27+ (e.g., OL8+, Ubuntu 18+)
* curl
* A Java IDE of your choice

> If you are Windows user using PowerShell please be aware of the [curl alias issue](https://curl.se/windows/microsoft.html).

## About Helidon 

[Helidon](https://helidon.io/) Helidon is an open-source Java framework for developing cloud native services.

Helidon is open source under the Apache license. Sources are available on [GitHub](https://github.com/helidon-io/helidon/tree/main).

Helidon is cloud-native ready. It provides fast start-up time and has low memory consumption and a small disk footprint. It also comes with a full observability stack out of the box including health checks, metrics, tracing and logging.

Helidon fully supports GraalVM native image allowing you to build a native executable from your Java application.

Helidon applications are stand-alone Java applications running in their own JVM and powered by the Helidon WebServer.

## Learn More

* [Helidon Documentation](https://helidon.io/docs/v4/about/doc_overview)
* [Helidon Project](https://helidon.io/)

## Acknowledgements

* **Author** - Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi, Daniel Kec
* **Last Updated By/Date** - Daniel Kec, March 2025