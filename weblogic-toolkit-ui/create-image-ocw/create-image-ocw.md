# Create an Auxiliary Image and Push it into the Oracle Container Image Registry

## Introduction

**Primary Image** - The image containing the Oracle Fusion Middleware software. It is used as the basis of all containers that run WebLogic Servers for the domain.

**Auxiliary Image** - The image that contains Application archive, WDT Model and WDT variable files.  At runtime, the auxiliary image’s content is merged with the primary image’s content.
 ![Image Structure](images/image-structure.png)

In this Lab, we use the WebLogic server **12.2.1.4-slim-ol8** image as the Primary Image. Also, we create an auxiliary image and push it to the Oracle Container Image Registry repository using the pre-generated authentication token. 

Estimated Time: 10 minutes

Watch the video below for a quick walk-through of the lab.
[Creation of Images for the OKE on OCI](videohub:1_y5o56oe5)

### Objectives

In this lab, you will:

* Create an Auxiliary Image and push the image to Oracle Cloud Container Image Registry.

## Task 1: Prepare the Auxiliary Image and Push the Auxiliary Image  

In this task, we are creating an Auxiliary image, which we will push to the Oracle Cloud Container Registry.


1. Click **Image** and then in image section click **Auxiliary Image**. We have prefilled the values for you. You need to replace **tag** with your username. For example, user1/user2.
      ![image tag](images/image-tag.png)

      >  Auxiliary image tag contains Endpoint for the Region, Tenancy Namespace and OCIR Registry Name respectively. 
 
 

2. We have prefilled the values for **Auxiliary Image Registry Push Username** and **Auxiliary Image Registry Push Password**. These details are required for pushing the auxiliary image in OCI registry.
    ![Auxiliary Image Details](images/auxiliary-image-details.png)

      >  We have created one shared user for all the participants. **Auxiliary Image Registry Push Username** is formed with tenancy namespace and registed username of shared user. **Auxiliary Image Registry Push Password** is formed with OCI authentication token. 


3. Click **Create Auxiliary Image**.
      ![Create Auxiliary Image](images/create-auxiliary-image.png)

4. As we already prepared the model in the previous lab, so click on **No**.
      ![Prepare Model](images/prepare-model.png)

5. Select **Downloads** folder where we want to save **WebLogic Deployer** and click **Select** as shown.
      ![WDT Location](images/wdt-location.png)

6. Once Auxiliary images is successfully created, On **Create Auxiliary Image Complete** window, click **Ok**.
      ![Auxiliary Created](images/auxiliary-created.png)
      > **For your information only:**<br>
      > An auxiliary image is domain-specific. The auxiliary image contains the data that defines the domain.

7. Click **Push Auxiliary Image** to push the image in the repository inside your Oracle Cloud Container Image Registry.
      ![Push Auxiliary](images/push-auxiliary.png)

8. Once image is successfully pushed, On **Push Image Complete** window, click **Ok**. 
      ![Auxiliary Pushed](images/auxiliary-pushed.png)


 
## Acknowledgements

* **Author** -  Ankit Pandey
* **Contributors** - Sid Joshi , Maciej Gruszka
* **Last Updated By/Date** - Ankit Pandey, July 2024