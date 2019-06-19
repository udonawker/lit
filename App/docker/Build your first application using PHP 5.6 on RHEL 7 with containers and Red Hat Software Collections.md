[Build your first application using PHP 5.6 on RHEL 7 with containers and Red Hat Software Collections](https://developers.redhat.com/articles/using-php-56-rhel-7-containers-and-red-hat-software-collections/ "Build your first application using PHP 5.6 on RHEL 7 with containers and Red Hat Software Collections")<br/>

<pre>
Get started building PHP 5.6 applications in docker containers on Red Hat Enterprise Linux in under 15 minutes.

Introduction and Prerequisites
In this tutorial, you will learn how to start building PHP 5.6 applications in docker containers on Red Hat Enterprise Linux. In order to build and run containers you will first install docker on your Red Hat Enterprise Linux 7 system. You will use the PHP 5.6 container image from Red Hat Software Collections (RHSCL) 2.2 as the basis for your containerized application.

You will need a system running Red Hat Enterprise Linux 7 Server with a current Red Hat subscription that allows you to download software and updates from Red Hat. Developers can get a no-cost Red Hat Enterprise Linux Developer Suite subscription for development purposes by registering and downloading through developers.redhat.com.

If you encounter difficulties at any point, see Troubleshooting and FAQ.

 
1. Prepare your system
5 minutes

In this step, you will configure your system to build and run docker containers. In the process, you will add the necessary software repositories, then verify that your system has a current Red Hat subscription and is able to receive updates from Red Hat. Your system needs to be already registered with Red Hat.

First, you will enable two Red Hat software repositories that are disabled by default. Instructions are provided for both the command line (CLI) and graphical user interface (GUI).

Using the Red Hat Subscription Manager GUI
Red Hat Subscription Manager can be started from the System Tools group of the Applications menu. Alternatively, you can start it from the command prompt by typing subscription-manager-gui.

Select Repositories from the System menu of the subscription manager. In the list of repositories, check the Enabled column for rhel-7-server-optional-rpms and rhel-7-server-extras-rpms. After clicking, it might take several seconds for the check mark to appear in the enabled column.

Using subscription-manager from the command line
You can add or remove software repositories from the command line using the subscription-manager tool. Start a Terminal window if you don’t already have one open. Use su to become the root user. Use subscription-manager --list option to to view the available software repositories.

$ su -
# subscription-manager repos --list
Enable the two additional repositories:

# subscription-manager repos --enable rhel-7-server-extras-rpms
# subscription-manager repos --enable rhel-7-server-optional-rpms
Install docker and start the docker daemon
In the next step you will:

Update your system with any available software updates

Install docker and a few additional rpms using yum

Configure the docker daemon to start at boot time

Start the docker daemon

If you don’t have a root Terminal window open, start a Terminal window and become the root user with su.

Now download and install any available updates by running yum update. If updates are available, yum will list them and ask if it is OK to proceed.

$ su -
# yum update
Install docker and necessary additional rpms:

# yum install docker device-mapper-libs device-mapper-event-libs
Enable the docker daemon to start at boot time and start it now:

# systemctl enable docker.service
# systemctl start docker.service
Now verify that the docker daemon is running:

# systemctl status docker.service
Your system is now ready to build and run docker-formatted containers. If you encounter difficulties at any point, see Troubleshooting and FAQ.

 
2. Run your first container
5 minutes

This step will download and install PHP 5.6 using a container image from the Red Hat container registry, a repository of container images. Installing the PHP 5.6 container image will make PHP 5.6 available for use by other containers on your system. Because containers run in isolated environments, your host system will not be altered by the installation. You must use docker commands to use or view the container’s content.

The commands shown in this section can be used to download and install other containers, like application containers you build. Containers can specify that they require other containers to be installed, which can happen automatically. For example, you can specify in the Dockerfile that is used to describe and build your container that your application requires PHP 5.6. Then, when someone installs your container, their system will automatically download the required PHP 5.6 container directly from the Red Hat container registry.

The PHP 5.6 container image is part of RHSCL, which provides the latest development technologies for Red Hat Enterprise Linux. Access to the RHSCL is included with many Red Hat Enterprise Linux (RHEL) subscriptions. For more information about which subscriptions include RHSCL, see How to use Red Hat Software Collections (RHSCL) or Red Hat Developer Toolset (DTS).

If you don’t have a root Terminal window open, start a Terminal window and become the root user with su.

To download and install the PHP 5.6 container image, use the following command:

# docker pull registry.access.redhat.com/rhscl/php-56-rhel7
The docker images command lists the container images that are present on your system:

# docker images
The list will include those images you’ve downloaded and any containers previously installed on your system.

Now start a bash shell to have a look around inside a container that uses the PHP 5.6 container image. The shell prompt changes, which is an indication that you are typing at the shell inside the container. A ps -ef shows the only thing running inside the container is bash and ps. Type exit to leave the container’s bash shell.

# docker run -it rhscl/php-56-rhel7 /bin/bash
bash-4.2$ which php
/opt/rh/rh-php56/root/usr/bin/php
bash-4.2$ php -v
PHP 5.6.5 (cli) (built: Feb 16 2016 05:49:30)
bash-4.2$ pwd
/opt/app-root/src
bash-4.2$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
default      1     0  0 20:10 ?        00:00:00 /bin/bash
default     14     1  0 20:10 ?        00:00:00 ps -ef
bash-4.2$ exit
The prior docker run command created a container to run your command, keep any state, and isolate it from the rest of the system. You can view the list of running containers with docker ps. To see all of the containers that have been created, including those that have exited, use docker ps -a.

You can restart the container that was created above with docker start. Containers are referred to by name. Docker will automatically generate a name if you don’t provide one. Once the container has been restarted, docker attach will let you interact with the shell running inside of it. See the following example:

# docker ps -a
CONTAINER ID        IMAGE                         COMMAND                CREATED              STATUS                          PORTS               NAMES
84458ca538fb        rhscl/php-56-rhel7   "container-entrypoin   About a minute ago   Exited (0) About a minute ago                       determined_mayer
# docker start determined_mayer
determined_mayer
# docker attach determined_mayer
At this point you are connected to the running shell inside the container. When you attach you won’t see the command prompt, so hit Enter to get it to print another one.

bash-4.2$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
default      1     0  0 14:44 ?        00:00:00 /bin/bash
default     11     1  0 14:45 ?        00:00:00 ps -ef
bash-4.2$ exit
Since the only process in the container, bash, was told to exit the container will no longer be running. This can be verified with docker ps -a. Containers that are no longer needed can be cleaned up with docker rm <container-name>.

# docker rm determined_mayer
To see what other container images are available in the Red Hat container registry, use one or more of the following searches:

# docker search registry.access.redhat.com/rhscl
# docker search registry.access.redhat.com/openshift3
# docker search registry.access.redhat.com/rhel
# docker search registry.access.redhat.com/jboss
If you need help, see Troubleshooting and FAQ.

 
3. Build Hello World in a container
5 minutes

In this step, you will create a tiny Hello World container that uses PHP 5.6 as a web server. Once created, the container can be run on other systems that have docker installed. You will need to create several files in an empty directory using your favorite editor, including a Dockerfile that describes the container. You don’t need to be running under the root user to create the files, but you will need root privileges to run the docker commands.

First, create an empty directory, and then create a file named Dockerfile with the following contents, but change the MAINTAINER line to have your name and email address:

Dockerfile

FROM rhscl/php-56-rhel7

MAINTAINER Your Name "your-email@example.com"

EXPOSE 8000

COPY . /opt/app-root/src

CMD /bin/bash -c 'php -S 0.0.0.0:8000'
Create the file index.php with the following contents:

index.php

<?php
print "Hello, Red Hat Developers World from PHP " . PHP_VERSION . "\n";
?>
Now build the container image using docker build. You will need to be root using su or sudo in the directory you created that contains Dockerfile and index.php.

# docker build -t myname/phpweb .
You can see the container image that was created using the following command:

# docker images
Now run the container using docker run. The PHP container will create a tiny web server that listens on port 8000 inside the container. The run command will map port 8000 on the host machine to port 8000 inside the container.

# docker run -d -p 8000:8000 --name helloweb myname/phpweb`
The run command returns a unique ID for the container, which you can ignore. To check that the container is running, use docker ps. The output should show a container named helloweb that is running the myname/phpweb container image you created.

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                              NAMES
c7885aa23773        myname/phpweb    "container-entrypoint"   6 seconds ago       Up 4 seconds        0.0.0.0:8000->8000/tcp, 8080/tcp   helloweb
Use curl to access the PHP web server:

# curl http://localhost:8000/
Hello, Red Hat Developers Worldfrom PHP 5.6.5!
To view the logs from the running container use docker logs <container-name>:

# docker logs helloweb
When you are done, stop the running container:

# docker stop helloweb
The helloweb container will be retained until you remove it with docker rm. You can restart the container with docker start helloweb. Note: A subsequent docker run will generate an error if a container with the same name already exists.

You can view information about a container using docker inspect:

# docker inspect myname/phpweb
The output is a JSON structure that is easily readable. The Config section has details of the container’s runtime environment such as environment variables and default command. Note that much of the information in the container’s configuration was inherited from the parent container, which in this case is the PHP 5.6 runtime container.

Finally, when the application container images you create are ready, you can distribute them by pushing them to a public or private container registry. Your containers will then be available to install on other systems using docker pull.

Want to know more about what you can do with RHEL?
Become a Red Hat developer: developers.redhat.com
Red Hat delivers the resources and ecosystem of experts to help you be more productive and build great solutions. Register for free at developers.redhat.com.

Follow the Red Hat Developer Blog
https://developers.redhat.com/blog/

Troubleshooting and FAQ
My system is unable to download updates from Red Hat.

Your system must be registered with Red Hat using subscription-manager register. You need to have a current Red Hat subscription.

As a developer, how can I get a no-cost Red Hat Enterprise Linux subscription?

When you register and download Red Hat Enterprise Linux Server through developers.redhat.com, a no-cost Red Hat Enterprise Linux Developer Suite subscription will be automatically added to your account. We recommend you follow our Getting Started Guide which covers downloading and installing Red Hat Enterprise Linux on a physical system or virtual machine (VM) using your choice of VirtualBox, VMware, Microsoft Hyper-V, or Linux KVM/Libvirt.

How do I tell if there is a container image available that has a newer version of PHP?

How can I see what other container images are available?

I can’t find the container mentioned in this tutorial, how can I tell if the name changed?

To see what other containers are available in the Red Hat container registry, use one or more of the following searches:

# docker search registry.access.redhat.com/rhscl
# docker search registry.access.redhat.com/openshift3
# docker search registry.access.redhat.com/rhel
# docker search registry.access.redhat.com/jboss
I can’t find the docker rpm.

yum is unable to find the docker rpm.

When I try to install docker, yum gives the error No package docker available.

The docker rpm is in the rhel-7-server-extras-rpms software repository. It is only available for the server version of Red Hat Enterprise Linux. The rhel-7-server-extras-rpms repository is disabled by default. See the first step in this tutorial for information on enabling additional software repositories.

Where can I learn more about delivering applications with Linux containers?

If you haven’t already joined the Red Hat Developers program, sign up at developers.redhat.com. Membership is free.
Recommended Practices for Container Development and many other container articles are available from the Red Hat Customer Portal.
If you are a Red Hat Technology Partner, visit the Container Zone at the Red Hat Connect for Technology Partners web site.

Last updated: August 17, 2018
</pre>
