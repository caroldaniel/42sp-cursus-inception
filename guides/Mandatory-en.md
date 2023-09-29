<h1 align=center>
	<b>Mandatory</b>
</h1>

<p align=center>
	<b>Inception</b> is a project that aims for us to broaden our knowledge on system administration. We need to virtualize several Docker images, creating them in a personal virtual machine. Each service should run in a different container, but all of them should be called from a docker-compose.yml file and be connected to a single docker-network.
</p>
<p align=center>
	In order to start this task we must choose between 2 available images: <b>Alpine Linux</b> or <b>Debian</b>. I consider Debian to be the obvious choise, for reasons that will be explained later on. But first, let's contextualize. 
</p>


---
<h2 align=center> Index </h2>
<h3 align="center"><b>
	<a href="#Docker">What is Docker?</a>
	<span> • </span>
	<a href="#Virtual">Virtual Machines and Containers</a>
	<span> • </span>
	<a href="#Images">Choosing our image: Alpine Linux or Debian?</a>
	<span> • </span>
	<a href="#PreReq">Pre-Requisites</a>
	<span> • </span>
	<a href="#DockerCompose">Docker Compose</a>
	<span> • </span>
	<a href="#Requirements">Requirements</a>
	<span> • </span>
</b></h3>

---

<h2 id="Docker">
What is Docker?
</h2>

![Docker](screenshots/docker.png)

Docker is a type virtualization application that gives you the ability to run thousands of so-called **containers** in a single machine. 

To better understand what a container is, think about it as a **lightweight virtual machine**. It is a self-contained package of software that includes everything needed to run it: code, runtime, system tools, system libraries, and settings. Containers isolate software from its surroundings, for example, differences between development and staging environments and help reduce conflicts between teams running different software on the same infrastructure.

Docker containers are based on **images**. An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization. For example, you may build an image which is based on the **ubuntu** image, but installs the Apache web server and your application, as well as the configuration details needed to make your application run.

Containers are sandboxed from one another and from the host machine. Docker provides tools for container creation, image handling, and management, as well as a way to keep everything together using **docker-compose**.

The idea is that you can package your application with everything it needs to run, and ship it as a single package. This ensures that your application will always run the same, regardless of the environment it is running in. 

Docker gives you and your peers the stability necessary to run the exact same code on laptops, data center VMs, and production cloud instances, guaranteeing fast and reliable deployments, testing, and continuous integration across multiple platforms.

---

<h2 id="Virtual">
Virtual Machines and Containers
</h2>

As you may have realized, Docker and Virtual Machines are pretty similar in their purpose, but they are not the same thing. To make things easier, let's discuss their main differences and purposes, as well as each of their pros and cons.

**Virtual machines (VMs)** and **Containers** both allow you to run applications in isolated environments, as well as depend on vitualization technology and secondary images. However, the way they interact with the host OS and the resources they use are different.

**VMs** run on a physical machine using a hypervisor, which is a piece of software that emulates the underlying hardware. The hypervisor allocates resources to each VM, including memory, CPU, storage, and networking. Each VM has its own OS, and the hypervisor manages interactions between the VMs and the host OS.

**Containers**, on the other hand, run on a single OS kernel. They share the host OS kernel and resources with other containers, making them lightweight and fast to start. This is important: Containers do **not** have their own OS. What they have is a set of binaries and libraries that run in isolation, on top of the host OS. They are isolated at the **process** level, and each container has its own file system. This makes them more portable and efficient than VMs.

![VM vs Docker](screenshots/containers-virtualmachine.jpg)

Does that mean my Docker image must be of the same OS as my host OS? Not necessarily. Docker images can be of any OS, but they will always run on top of the host OS kernel, so they will need to be compatible with it. For example, you can run a Debian image on top of an Ubuntu host OS, but you cannot run a Windows image on top of a Linux host OS. Linux and Windows use different kernels, so they are not compatible. However, you can run - albeit with some limitations - a CentOS image on top of an Ubuntu host OS, because they both use the Linux kernel.

So this is the first distinction we need to make: **Docker Images** and **VM images** are **not** the same thing. Docker images are not full-fledged OS images, they are just a set of binaries and libraries that run on top of the host OS kernel. VM images, on the other hand, are full-fledged OS images, with their own kernel and resources.

With everything that has been said, it looks like Containers are much more suitable for most use-case scenarios, but that is not always the case.

VMs are more suitable for running applications that require all of the host OS resources and functionality, such as Windows applications. They are also more suitable for running applications that require a full OS, such as Windows Server or Linux Server. VMs are also more suitable for running applications that require a **high level of security** and **isolation** from other applications, such as banking applications.

Containers, on the other hand, are more suitable for running applications that require less resources and functionality from the host OS, such as web applications. They are also more suitable for running applications that require a high level of **portability** and **scalability**, such as microservices. Containers are also more suitable for running applications that require a high level of performance, such as high-traffic web applications.

They choice between VMs and Containers depends on your specific requirements and preferences. This project, for example, is a perfect use-case scenario for Docker, as we will be running several applications that require less resources and functionality from the host OS, such as web applications, and that require a high level of portability and scalability, such as microservices.

---

<h2 id="Images">
Choosing our image: Alpine Linux or Debian?
</h2>

For this project, we will need to choose two images: one for our Virtual Machine (that will be our Docker host OS) and one for our Docker containers. The host OS image will be used to run our Virtual Machine, and the Docker image will be used to run our containers.

As it was detailed before, Docker images not necessarily need to be of the same OS as the host OS. However, they will always run on top of the host OS kernel, so they will need to be compatible with it.

Even though we can, in theory, choose different Linux OS for each, for better compatibility we will opt for the same distribution for both. For this project, we have two options: **Alpine Linux** or **Debian**.

Both Alpine Linux and Debian are popular choices for building Docker containers, and each has its own set of advantages and disadvantages. The choice between them depends on your specific requirements and preferences.

### Alpine Linux:

![Alpine](screenshots/alpine_linux.png)


| Pros | Cons |
| :---: | :---: |
| **Size**: Alpine Linux is known for its small image size. It's extremely lightweight, with minimal packages installed by default. This makes Alpine a popular choice for containers when minimizing image size is crucial. | **Compatibility**: Some software that expects a full glibc environment might not work properly on Alpine without adjustments. |
| **Security**: Due to its minimalistic nature, Alpine tends to have a smaller attack surface, which can enhance security. It uses the musl libc instead of glibc, which can have some security benefits. | **Limited package availability**: The Alpine package repositories may not have as extensive a selection as Debian. |
| **Package Manager**: Alpine uses the **apk** package manager, which is simple and effective for managing packages within containers. |  |

### Debian:

![Debian](screenshots/debian.png)

| Pros | Cons |
| :---: | :---: |
| **Stability**: Debian is known for its stability and wide package availability. It has a long history of being a reliable choice for various server applications. | **Larger image size**: Debian images are typically larger than Alpine images, which can lead to longer image pull times and increased storage requirements. |
| **Compatibility**: Because Debian uses the glibc standard C library, it's more compatible with software that expects a traditional Linux environment. | **Slightly higher resource usage**: Due to the larger image size, Debian images may use slightly more resources than Alpine images. |
| **Package Manager**: Debian uses **apt** as its package manager, which is highly versatile and widely used. |  |

### General Purposes and Use Cases:

- **Alpine**: Alpine is an excellent choice when you need minimalism, especially for microservices or single-purpose containers. It's ideal for situations where image size and security are paramount, such as in edge computing or container orchestration platforms like Kubernetes.

- **Debian**: Debian is a versatile choice for a wide range of use cases. It's suitable for applications that require compatibility with a variety of software, and its extensive package repository makes it a solid choice for general-purpose containers, especially in traditional server environments.

Ultimately, the choice between Alpine and Debian comes down to your specific requirements, including image size, compatibility, and the software you need to run in your containers.

Considering all of this, I chose to use **Debian** for my project, for two main reasons:

- **Versatility**: From the get go, I had every intention on doing all Bonus parts. Debian provides more compatibility between different and broader features.
- **Documentation**: Say what you want, but Debian has been, overtime, more used elsewhere and, therefore, more documentated. You can find just about anything for Debian troubleshooting, which makes this whole ordeal much easier.

<h2 id="PreReq">
Pre-Requisites
</h2>

Now, let's prepare to the fun part. Before we can start working on the project, though, we need to set up our environment, and that said environment consists of a Virtual Machine and Docker installed on it.

For this, the initial setup consists of only two downloadables:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads): VirtualBox is a general-purpose full virtualizer, aimed at enabling users to run multiple operating systems in virtual machines. For this project, we will be using VirtualBox to run a Debian system on top of our own OS.
- [Debian](https://www.debian.org/distrib/netinst): Debian is an open-source operating system that runs from the desktop, to the cloud, to all your internet connected things. We will be using Debian inside our VirtualBox to run the project.

I will not be covering the installation of these two, as they are pretty straightforward. If you have any issues, you can find plenty of tutorials online.

Once you have your Virtual Machine up and running with your Debian OS, you will need to install Docker. To do so, you can follow the steps below:

1. Update and upgrade your system:

```bash
sudo apt-get update && sudo apt-get upgrade
```

2. Install Docker:

```bash
sudo apt-get install docker.io
```

3. Check if Docker is running:

```bash
sudo systemctl status docker
```

4. If it is not running, start it:

```bash
sudo systemctl start docker
```

System should be up and running. Now, let's get to the project itself. Brace yourselves, 'cause this is a long one.

---

<h2 id="DockerCompose">
Docker Compose
</h2>

![Docker Compose](screenshots/docker-compose.jpg)

Let's imagine the following scenario: you need to deploy an application. This application is composed of several services, such as a web server, a database, a cache, and so on (Hipotetically, of course, not at all like your project should be).

To set up this application, you need to install and configure each service individually, making sure that each one is properly configured and that they are all connected to each other. This can be a very time-consuming and error-prone process, especially if you need to deploy the application multiple times, for example, in different environments.

This is where **Docker Compose** comes in. Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a simple file to describe how your application should be built and run, and then you can run a single command to create and start all the services from your configuration. Amazing right?

Remember that: Docker Compose is your friend.

The core concept of understanding System Administration is that you need to be able to **automate** everything. This is called **Infrastructure as Code**. You need to be able to write a script that will do everything for you, so that you can just run it and have everything set up and running. Docker Compose is a tool that will help you do just that.

So now, let's understand how Docker Compose works.

### YAML

Docker Compose uses a YAML file. But what is YAML?

**YAML** is a human-readable data serialization language. In summary, it is a way to represent data structures in a way that is easy to read and write for humans. It is commonly used for configuration files, but could be used in many applications where data is being stored or transmitted.

YAML is a superset of JSON, which means that any valid JSON file is also a valid YAML file. However, YAML uses indentation instead of brackets to define data structures, which makes it simpler and easier to read.

Example of YAML syntax:

```yaml
# This is a comment

key: value # This is a key-value pair

list: # This is a list
  - item1
  - item2
  - item3

dictionary: # This is a dictionary
  key1: value1
  key2: value2
  key3: value3

list_of_dicts: # This is a list of dictionaries
  - key1: value1
	key2: value2
	key3: value3
  - key1: value1
	key2: value2
	key3: value3
  - key1: value1
	key2: value2
	key3: value3
```

YAML is a very simple and easy to learn language. You can find more information about YAML [here](https://yaml.org/).

### Docker Compose File

Docker Compose uses a YAML file called **docker-compose.yml** to define the services that make up your application. You can then use the **docker-compose** command to create and start all the services from your configuration.

The docker-compose.yml file is divided into **services**. Each service is a container that will run a specific application. For example, you can have a service that runs a web server, another service that runs a database, and so on.

Each service has a set of properties that define how it should be built and run. These properties include the name of the image to use, the ports to expose, the volumes to mount, etc.

Docker Compose file example:

```yaml
version: "3.9" # Version of the docker-compose file

services: # List of services
  service1: # Service 1
	image: image1 # Image to use
	ports: # Ports to expose
	  - "80:80"
	  - "443:443"
	volumes: # Volumes to mount
	  - volume1
	  - volume2
	networks: # Networks to connect to
	  - network1
	  - network2
  service2: # Service 2
	image: image2 # Image to use
	ports: # Ports to expose
	  - "80:80"
	  - "443:443"
	volumes: # Volumes to mount
	  - volume1
	  - volume2
	networks: # Networks to connect to
	  - network1
	  - network2
  service3: # Service 3
	image: image3 # Image to use
	ports: # Ports to expose
	  - "80:80"
	  - "443:443"
	volumes: # Volumes to mount
	  - volume1
	  - volume2
	networks: # Networks to connect to
	  - network1
	  - network2
  service4: # Service 4
	image: image4 # Image to use
	ports: # Ports to expose
	  - "80:80"
	  - "443:443"
	volumes: # Volumes to mount
	  - volume1
	  - volume2
	networks: # Networks to connect to
	  - network1
	  - network2
```

To get a full list of all the properties that can be used in a docker-compose.yml file, you can check the [official documentation](https://docs.docker.com/compose/compose-file/).

### Repository Structure

Your `docker-compose.yml` file should be in the root of your repository. Each service should be in its own sub-folder, and each sub-folder should have its own `Dockerfile` (To be explained below).

To run your docker-compose.yml file, you can use the following command:

```bash
docker-compose up
```
However, we will be using a Makefile to run our docker-compose.yml file, as it will make our lives much easier. More on that later on.

The tree structure of your application configuration will look something like this:

```bash
.
├── Makefile
├── docker-compose.yml
├── service1
│   └── Dockerfile
├── service2
│   └── Dockerfile
├── service3
│   └── Dockerfile
└── service4
	└── Dockerfile
```

### Dockerfile

A **Dockerfile** is a text document that contains all the commands a user could call on the command line to assemble an image. Using `docker build` users can create an automated build that executes several command-line instructions in succession.

Dockerfiles adhere to a specific format and use a specific set of instructions. You can find more information about Dockerfiles [here](https://docs.docker.com/engine/reference/builder/).

Dockerfiles are used to build Docker images. Each service in your docker-compose.yml file will use a Dockerfile to build its image.

Dockerfile example:

```dockerfile
FROM debian:buster # Base image to use

RUN apt-get update && apt-get install -y package1 package2 package3 # Install packages

COPY srcs/ / # Copy files from host to container

RUN chmod 777 / # Change permissions

CMD ["executable", "param1", "param2"] # Run command
```

To each service in this project, we will be using a Dockerfile to build its image. We're gonna go through each one of them, but first, let's understand the project's requirements.

---

<h2 id="Requirements">
Requirements
</h2>