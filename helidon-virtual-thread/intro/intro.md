# Introduction

## About this Workshop

In this lab, You will use Oracle Code Editor to build, run and modify microservices using the Helidon WebServer available in Helidon 4. Helidon WebServer is written from the ground up to leverage Java 21's virtual threads and provides a simple blocking programming model.

You will also see how it compares to more complex reactive programming.

During this lab, you will use Helidon Project Starter to develop a Helidon Microprofile application.  It’s highly customizable, providing various options that allow users to select Helidon features they want to add to their project. Then, you will migrate the application on Helidon 3.2.6 to Helidon 4 running on the new Helidon WebServer using virtual threads.

This workshop is designed to be as self-explanatory as possible, but feel free to ask for clarification or assistance along the way.

Estimated Time: 90 minutes

### Objectives

* Explore OCI Code Editor
* Build and run the Helidon 4(Virtual thread) application
* Build and run the Helidon 3 (Reactive) application
* Analyse the simplicity of the Helidon 4 application
* Compare stack trace for Helidon 4 and Helidon 3 application
* Generate a Helidon MP application
* Migrate the Helidon 3 application to Helidon 4


**About Helidon**

Helidon is an open-source microservices framework introduced by Oracle that provides a collection of Java libraries designed for creating a lightweight and fast microservices-based application.

In earlier versions of Helidon developers could pick from two programming models. [Helidon MP](https://helidon.io/docs/v3/#/mp/introduction) an implementation of the Eclipse MicroProfile standard with APIs familiar to Jakarta EE developers. And [Helidon SE](https://helidon.io/docs/v3/#/se/introduction) is a lean, reactive framework.


In Helidon 4 Oracle is introducing a webserver written from the ground up to use JEP 425 virtual threads. Helidon 4 provides an easy-to-use programming model with outstanding performance. With virtual threads, threads are no longer a scarce resource to be carefully pooled and managed. Instead, they are an abundant resource that can be created as needed to handle nearly unlimited concurrent requests. Because each request runs in its dedicated thread it is free to perform blocking operations -- like calling a database, or another service. And it can do so in a simple synchronous way with no fear of blocking a platform thread and starving other requests. You no longer need to resort to complicated asynchronous code to implement a low-overhead, highly concurrent service.


The Helidon web server replaces Netty in the Helidon ecosystem. It also can be used by other frameworks as an embedded web server component.

### Prerequisites
This lab assumes you have:
* Oracle Cloud Account or Laptop with permissions to install software if required




## Learn More

* [https://helidon.io](https://helidon.io)

## Acknowledgements
* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, March 2025