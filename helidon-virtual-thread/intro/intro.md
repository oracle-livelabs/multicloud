# Introduction

## About this Workshop

In this lab, You will use Oracle Code Editor to build, run and modify microservices using the Helidon Nima WebServer available in Helidon 4. Nima is written from the ground up to leverage Java 19's virtual threads and provides a simple blocking programming model.

You will also see how it compares to more complex reactive programming.

During this lab, you will use Helidon Project Starter to develop the Helidon Microprofile application.  It’s highly customizable, providing various options that allow users to select Helidon features they want to add to the project. Then, you will migrate the application to Helidon 4 running on the new Helidon Nima WebServer using virtual threads.

This workshop is designed to be as self-explanatory as possible, but feel free to ask for clarification or assistance along the way.

Estimated Time: 90 minutes

### Objectives

* Explore OCI Code Editor
* Build and Run the Nima application
* Build and Run the Reactive application
* Analysing the simplicity of the Nima application
* Compare Stack trace for Nima and Reactive application
* Generate an Helidon MP application
* Migrate the Helidon 3 application to Helidon 4


### Prerequisites
This lab assumes you have:
* Oracle Cloud Account


## About Helidon Nima

Helidon is an open-source microservices framework introduced by Oracle that provides a collection of Java libraries designed for creating a lightweight and fast microservices-based application.

Under the umbrella of [Project Helidon](https://helidon.io/), Oracle introduced a new microservices framework based on virtual threads [JEP 425](https://openjdk.org/jeps/425) called Helidon Níma. It is built from the ground up to achieve an easy-to-use programming model with outstanding performance.

Developers could achieve a certain level of throughput using the regular Helidon framework through [Helidon MP](https://helidon.io/docs/v3/#/mp/introduction) or [Helidon SE](https://helidon.io/docs/v3/#/se/introduction), but if the application needs to be more performant, their only choice is to revert to a reactive-based service. However, it is worth mentioning that writing, maintaining, and debugging reactive-based services is more challenging.

Helidon Níma uses virtual threads to carve out the issue, as blocking is cheap, and we can create millions of them. Thus, this offers a stellar, low-overhead, highly concurrent server while maintaining a blocking thread model.

The Helidon Níma web server intends to replace Netty in the Helidon ecosystem. It also can be used by other frameworks as an embedded web server component.

Níma currently supports:

* HTTP/1
* HTTP/2
* gRPC
* Observability Features (Metrics, Health Checks, Tracing)
* Fault Tolerance
* Testing integrations

Helidon Nima also uses new Java language features like sealed classes and enhanced switch expressions.

Helidon Níma is a fully open-source framework, part of the Helidon codebase on [GitHub](https://github.com/helidon-io/helidon/tree/main/nima)

## Learn More

* [https://helidon.io](https://helidon.io)

## Acknowledgements

* **Author** -  Joe DiPol
* **Contributors** - Ankit Pandey, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, Feb 2023