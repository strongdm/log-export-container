---
layout: default
title: How to use Custom AMI
parent: Deploy LEC
nav_order: 5
---
## Creating a Log Export Container AWS AMI
1. Go to the EC2 management panel and click on **Launch instances**.

2. Click on the "My AMIs" tab and select your Log Export Container AMI (see [How to create an AMI](docs/HOW_TO_CREATE_AMI.md)).
![image](https://user-images.githubusercontent.com/20745533/158184010-c5fe8fc2-afd7-4f9d-9b87-fec72a16b381.png)

3. Select your Instance Type and click on **Next: Configure Instance Details**.

4. In this step you need to provide the Log Export Container configuration environment variables. To do that you will need to follow the template from [ami-variables-user-data.sh.example](ami-variables-user-data.sh.example). Copy the content from the file, paste it into **Advanced Details > User data** field and modify it with your desired configurations.

In the following example we're going to configure a dummy [Mongo output](docs/CONFIGURE_MONGO.md) and enable [SSH Events Decoding](docs/CONFIGURE_SSH_DECODE.md) following the template.
![image](https://user-images.githubusercontent.com/20745533/158190367-645eac78-28cb-476d-82dd-9f0484bf76b3.png)

After adding your environment variables, click on **Next: Add Storage**.

5. Configure your storage or leave it with the default values and click on **Next: Add Tags**.

6. Add tags if you want and click on **Next: Configure Security Group**.

7. In this step you can select an existing security group (as long there is a TCP port accessible on 5140) or create a new one as follows:

With the option "Create a new security group" selected, click on **Add Rule** and enter:
- Type: Custom TCP Rule
- Port range: 5140
- Source: here you need to enter the IP address from the machine that will send logs to your instance, but in this example we're going to configure it as "Anywhere", so anyone could send logs to this instance (not recommended).
![image](https://user-images.githubusercontent.com/20745533/158177046-5ef48134-6bf4-49c8-a90e-2d8bf84a1704.png)

Also be aware that the SSH Rule by default allows connections from anywhere, and you might want to change that to a specific IP address.

 After that click on **Review and Launch**.
 
8. Take a look at everything and if it seems fine just click on the **Launch** button.

9. Configure your key pair for accessing the instance and click on **Launch instances**.

10. Now you can SSH into the created instance and take a look at the incoming logs by entering the following command:
> $ journalctl -u log-export-container.service -f

And that's it. You have successfully created and configured a Log Export Container instance from the Log Export Container AMI.
