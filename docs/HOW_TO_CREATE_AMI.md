## Creating a Log Export Container AWS AMI 
1. Go to the EC2 management panel and click on **Launch instances**.

2. Search for "Ubuntu" and select the latest version.
![image](https://user-images.githubusercontent.com/20745533/158170962-5beb2784-277a-45d4-b30c-94a7a1511ed1.png)

3. Select your Instance Type and click on **Next: Configure Instance Details**.

4. This is the most important step. You can enter custom configurations or leave it with the defaults values, but under the **Advanced Details > User data** field you need to copy and paste the content from the file [ami-cloud-init-user-data.sh](ami-cloud-init-user-data.sh). After that click on **Next: Add Storage**.
![image](https://user-images.githubusercontent.com/20745533/158171270-ebc54d1a-86fc-44a1-8675-8cdd749ecaba.png)

5. Configure your storage or leave it with the default values and click on **Next: Add Tags**.

6. Add tags if you want and click on **Next: Configure Security Group**.

7. Now, with the option "Create a new security group" selected, click on **Add Rule** and configure it as follows:
- Type: Custom TCP Rule
- Port range: 5140
- Source: here you need to enter the IP address from the host that will send logs to your instance, but in this example we're going to configure it as "Anywhere", so anyone could send logs to this instance (not recommended). After that click on **Review and Launch**.
![image](https://user-images.githubusercontent.com/20745533/158177046-5ef48134-6bf4-49c8-a90e-2d8bf84a1704.png)

8. Take a look at everything and if it seems fine just click on the **Launch** button.

9. Configure your key pair for accessing the instance and click on **Launch instances**.

10. Now you need to SSH into the created container to keep track of the setup progress.

11. After logging into the container, enter the following command to see in real time the logs generated from the setup process:
> $ tail -f /var/log/cloud-init-output.log

This step will take a while and you will know that it has finished when the "PLAY RECAP" message appears (see image below).
![image](https://user-images.githubusercontent.com/20745533/158178473-e57209a0-32c5-48a1-99e2-8a455e7f4f16.png)

After that Log Export Container should be up and running.

12. Now we need to clean the container in order to generate the AMI. We need to get rid of any credentials and disable root login. To do that you need to run the [clean-up-credentials.sh](build-utils/clean-up-credentials.sh) script inside the container:
> $ sudo /clean-up-credentials.sh

13. Now you can exit the container and go back to the EC2 management console.

14. Right click on the container and click on **Image and templates > Create image**.
![image](https://user-images.githubusercontent.com/20745533/158180602-df3021dc-09ca-415c-9abc-0166128410c7.png)

15. Enter a name for your AMI and a description. After that click on **Create image**.

And that's it. You have successfully created a Log Export Container AMI.
