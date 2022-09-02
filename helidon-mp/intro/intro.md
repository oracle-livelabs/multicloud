# Introduction

## About this Workshop

During this lab, you will use Helidon Project Starter to develop the HTTP microservice application.  It’s highly customizable, providing various options that allow users to select Helidon features they want to add to the project.

Then you will explore the OCI Code Editor and open the Helidon application in it. You will also learn, how to use GraalVM Enterprise Edition in Oracle Cloud Infrastructure(OCI) Cloud Shell.

You will build a GraalVM native image for a Helidon MP application using maven. Then you will modify the application by adding a custom endpoint in the existing Java Class. Later, you will build a native docker image of this application and push it to Oracle Cloud Container Image Registry. You will also create a compute instance and pull the docker image here and run the docker container for this application.

This workshop is designed to be as self-explanatory as possible, but feel free to ask for clarification or assistance along the way.

Estimated Time: 90 minutes

### Objectives

* Generate an Helidon MP application
* Explore OCI Code Editor 
* Create a native image for the Helidon MP application
* Create GraalVM native docker image for Helidon application
* Create a Virtual Machine
* Run docker container for Helidon MP application

### Prerequisites
This lab assumes you have:
* Oracle Cloud Account


## About Helidon

Helidon is an open-source microservices framework introduced by Oracle that provides a collection of Java libraries designed for creating a lightweight and fast microservices-based applications. The framework supports two programming models for writing microservices: Helidon SE and Helidon MP.

While Helidon SE is designed to be a microframework that supports the reactive programming model, Helidon MP is an implementation of the MicroProfile specification. Since MicroProfile has its roots in Java EE, the MicroProfile APIs follow a familiar, declarative approach with heavy use of annotations. This makes it a good choice for Java EE developers.

The MicroProfile features aim at the implementation of microservices. You can find APIs for defining REST Clients, monitoring the application, reading technical and functional statistics and configuring the application.
Helidon has also added additional APIs to the core set of Microprofile APIs giving you all the capabilities you need for writing modern cloud-native applications.

> The [MicroProfile](https://microprofile.io/) standard builds on Jakarta EE. Like Jakarta EE, MicroProfile is open source and is developed by the Eclipse Foundation. Implementation with MicroProfile takes place in the libraries or application servers implementing the standard, just like Jakarta EE.

## Learn More

* [https://helidon.io](https://helidon.io)

## Acknowledgements

* **Author** -  Dmitry Aleksandrov
* **Contributors** - Ankit Pandey, Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, August 2022
