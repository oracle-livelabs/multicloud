# Setup the Environment on Local Machine 

## Introduction

In this lab, you will learn how to setup the environment on your local machine.

Estimated Time: 5 minutes


### Objectives

* Configure the required JDK and Maven.
* Download the application source code.

### Prerequisites
The Helidon AI HOL works smoothly on Linux, macOS, or Windows, as long as you have a reasonably up-to-date operating system.

The most important requirement is having the latest JDK! You will also need Maven 3.8+ and a Java IDE of your choice. While our screenshots feature VS Code, you are free to use any IDE you're comfortable with.

To summarize the prerequisites, you need:

* JDK 21+ (newer versions are encouraged!)
* Maven 3.8+
* For Linux: glibc 2.27+ (e.g., OL8+, Ubuntu 18+)
* curl
* A Java IDE of your choice

> If you are Windows user using PowerShell please be aware of the [curl alias issue](https://curl.se/windows/microsoft.html).

## Task 1: Check required Maven and JDK versions are installed properly

Execute following commands in the terminal to verify that required JDK and Maven version are installed and configured properly.

```bash
<copy>java -version</copy>
```

```bash
<copy>mvn -v</copy>
```

> Do not get alarmed if you encounter `WARNING: java.lang.System::load`, it's a harmless warning caused by Maven compatibility issue [MNG-8248](https://issues.apache.org/jira/browse/MNG-8248)

## Task 2: Download the Helidon source code

There are 2 options available to access the HOL project.
If you have git available you can clone whole [Helidon Labs](https://github.com/helidon-io/helidon-labs/tree/main/hols/langchain4j) repository:

Git option:

```bash
git clone https://github.com/helidon-io/helidon-labs.git
cd helidon-labs/hols/langchain4j
```

Alternative sourcecode download:

```bash
curl -O https://objectstorage.uk-london-1.oraclecloud.com/p/Z7KkflaFYAGMVpWL5n0nGBMF58iAp5_suMxnCymjgNizS0r72GkDOqSctkPAQjsM/n/lrv4zdykjqrj/b/ankit-bucket/o/helidon-ai-hol.zip
unzip helidon-ai-hol.zip
cd helidon-ai-hol
```

You may now *proceed to the lab 2*.

## Acknowledgements

* **Author** -  Dmitry Kornilov
* **Contributors** - Ankit Pandey, Sid Joshi, Daniel Kec
* **Last Updated By/Date** - Daniel Kec, March 2025
