<h1 align=center>
	<b>Mandatory</b>
</h1>

<p align=center>
	<b>Inception</b> is a project that aims for us to broaden our knowledge on system administration. We need to virtualize several Docker images, creating them in a personal virtual machine. Each service should run in a different container, but all of them should be called from a docker-compose.yml file and be connected to a single docker-network.
</p>
<p align=center>
	In order to start this task we must choose between 2 available images: <b>Alpine Linux</b> or <b>Debian</b>. I consider Debian to be the obvious choise, for reasons that will be explained later on.
</p>


---
<h2 align=center> Index </h2>
<h3 align="center"><b>
	<a href="#PreReq">Pre-Requisites</a>
	<span> • </span>
	<a href="#Docker">What is Docker?</a>
	<span> • </span>
	<a href="#Virtual">Virtual Machines VS. Containers</a>
	<span> • </span>
	<a href="#Images">Alpine Linux or Debian?</a>
</b></h3>

---

<h2 id="PreReq">
Pre-Requisites
</h2>

<p> The project will be run entirely on a Virtual Machine, so the initial setup consists of only two downloadables:

- <a href="https://www.virtualbox.org/wiki/Downloads">VirtualBox</a>: VirtualBox is a general-purpose full virtualizer, aimed at enabling users to run multiple operating systems in virtual machines. For this project, we will be using VirtualBox to run a Ubuntu system on top of our own OS.
- <a href="https://ubuntu.com/download/desktop">Ubuntu</a>: Ubuntu is an open-source operating system that runs from the desktop, to the cloud, to all your internet connected things. We will be using Ubuntu inside our VirtualBox to run the project.

I will not be covering the installation of these two, as they are pretty straightforward. If you have any issues, you can find plenty of tutorials online.

Once you have your Virtual Machine up and running, you will need to install Docker. To do so, you can follow the steps below:

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

Now that Docker is installed, we can start working on the project, but first, let's contextualize a bit.

</p>

---

<h2 id="Docker">
What is Docker?
</h2>

Docker is a containerization platform that allows you to package, distribute, and run applications and their dependencies in isolated environments known as **containers**. Containers provide a consistent and efficient way to deploy and manage software, making it easier to develop, ship, and run applications across different computing environments.

![Docker](screenshots/docker.png)

### Key Concepts

1. **Containerization**:
Containerization is the process of encapsulating an application and its dependencies into a single, standalone package called a container. Containers are lightweight, portable, and consistent, ensuring that an application runs consistently regardless of the underlying infrastructure.

2. **Docker Engine**:
Docker Engine is the core component of Docker. It consists of the Docker daemon (dockerd) and the Docker command-line interface (docker). The Docker daemon manages containers, images, networks, and storage, while the CLI allows users to interact with Docker.

3. **Images**:
An image is a read-only template that contains everything needed to run an application, including code, libraries, and dependencies. Images are the basis for creating containers. They are often built from a set of instructions defined in a Dockerfile, which specifies how to assemble the image.

4. **Containers**:
A container is a runnable instance of an image. Containers are isolated from each other and from the host system, ensuring that applications and their dependencies do not interfere with one another. Containers can be created, started, stopped, and deleted using Docker commands.

5. **Registry**:
A registry is a centralized repository for Docker images. The most commonly used registry is the public Docker Hub, but you can also set up private registries for storing and sharing custom images.

6. **Compose**:
Docker Compose is a tool for defining and running multi-container applications. It uses a YAML file to define the services, networks, and volumes required for an application, simplifying the management of complex applications with multiple interconnected containers.

### How Docker Works

Docker uses a client-server architecture. The Docker client communicates with the Docker daemon, which is responsible for managing containers and images. Here's how the process typically works:

**Image Creation**: Developers create Docker images by writing Dockerfiles, which specify the application's environment and dependencies. These images are built using the docker build command.

**Image Distribution**: Docker images can be stored in registries, such as Docker Hub. Images can be publicly accessible or private, depending on your needs.

**Containerization**: Users create containers from images using the docker run command. Each container is an isolated instance of the image, running as a process on the host system.

**Runtime Isolation**: Containers are isolated from each other and from the host OS using containerization technologies like namespaces and cgroups. This isolation ensures that containers do not interfere with each other and have their own file systems, network configurations, and process spaces.

**Resource Management**: Docker allows you to control the resources allocated to containers, such as CPU and memory limits, ensuring fair resource utilization on the host system.

**Networking**: Docker provides networking capabilities, allowing containers to communicate with each other and with the external world. Containers can be connected to user-defined networks for isolated communication.

**Storage**: Docker provides mechanisms for managing persistent data within containers using volumes. Volumes can be used to store and share data between containers and the host system.

### Advantages of Docker

**Portability**: Containers can run consistently across different environments, from development laptops to production servers, reducing "it works on my machine" issues.

**Efficiency**: Containers are lightweight and share the host OS kernel, leading to faster startup times and reduced resource overhead compared to traditional virtualization.

**Isolation**: Containers provide process and file system isolation, ensuring that applications do not interfere with each other.

**Scalability**: Docker's ease of orchestration with tools like Kubernetes enables easy scaling of applications to handle increased workloads.

**Version Control**: Docker images can be versioned, allowing you to roll back to previous versions if needed.

**Collaboration**: Docker Hub and private registries facilitate collaboration by allowing teams to share and distribute images.

### Use Cases

Docker is widely used in various scenarios, including:

**Microservices**: Docker is a popular choice for building and deploying microservices-based architectures.

**DevOps**: Docker simplifies the deployment and management of applications, making it a valuable tool in DevOps workflows.

**Continuous Integration/Continuous Deployment (CI/CD)**: Docker containers can be integrated into CI/CD pipelines to ensure consistent testing and deployment environments.

**Legacy Application Modernization**: Docker can containerize legacy applications, making them easier to manage and migrate to modern infrastructure.

**Development Environments**: Developers can use Docker to create consistent development environments, eliminating "works on my machine" issues.

Docker has revolutionized the way applications are developed, deployed, and managed, making it a crucial technology in modern software development and infrastructure management. Its versatility, efficiency, and ease of use have made it a fundamental tool for building and running applications in a containerized world.

---

<h2 id="Virtual">
Virtual Machines VS. Containers
</h2>

Containers and traditional virtualization are both technologies used to isolate and manage computing resources, but they have fundamental differences in how they achieve this isolation and manage resources. 

![VM vs Docker](screenshots/containers-virtualmachine.jpg)

### 1. Isolation Mechanism:

**Docker Containers**: Docker uses containerization, a lightweight form of virtualization. Containers share the host OS kernel but maintain separate user spaces. They isolate processes and file systems, making them efficient and fast to start. However, they do not provide complete OS-level isolation.

**Virtual Machines (VMs)**: Virtualization creates full-fledged virtual machines that run guest operating systems on a hypervisor. VMs are isolated at the hardware level, and each VM has its own kernel and resources. This complete isolation provides stronger security but comes at the cost of higher resource overhead.

### 2. Resource Utilization:

**Docker Containers**: Containers are highly efficient in terms of resource utilization. They share the host OS kernel, which reduces resource overhead. This efficiency makes Docker containers suitable for running multiple lightweight containers on a single host.

**Virtual Machines (VMs)**: VMs require more resources since each VM runs a full OS, including its own kernel. This results in higher memory and CPU overhead, making them less resource-efficient compared to containers.

### 3. Portability:

**Docker Containers**: Docker containers are highly portable. They package applications and their dependencies into a single container image, which can run consistently across different environments. This portability reduces compatibility issues and simplifies application deployment.

**Virtual Machines (VMs)**: VMs are less portable than containers. Moving VMs between different hypervisors or cloud providers can be challenging due to differences in hardware and virtualization formats. VMs often require more extensive configuration and conversion.

### 4. Startup Time:

**Docker Containers**: Containers start quickly because they share the host OS kernel and require fewer initialization steps. This fast startup time is essential for dynamic scaling and rapid application deployment.

**Virtual Machines (VMs)**: VMs typically have longer startup times because they need to boot a complete OS. This can result in slower application deployment and scaling.

### 5. Security:

**Docker Containers**: Containers offer process and file system isolation but share the same kernel as the host OS. While this provides a good level of isolation for most use cases, it may be less secure than VMs in situations where strong isolation is required.

**Virtual Machines (VMs)**: VMs provide stronger security through hardware-level isolation. Each VM has its own kernel, reducing the risk of vulnerabilities in one VM affecting others. This makes VMs a preferred choice for scenarios with stringent security requirements.

### 6. Use Cases:

**Docker Containers**: Docker containers are well-suited for microservices architectures, DevOps practices, and situations where lightweight, scalable, and portable deployment is essential.

**Virtual Machines (VMs)**: VMs are preferred for running legacy applications, hosting multiple operating systems on a single physical server, and situations requiring strict isolation or compliance with regulatory standards.

In summary, Docker containers and virtualization offer different approaches to resource isolation and management. Docker provides lightweight, efficient containerization for modern application deployment, while virtualization offers stronger isolation but with higher resource overhead. The choice between the two depends on your specific use case, resource requirements, and security considerations. In many cases, organizations use both Docker containers and VMs in a complementary fashion to meet various application deployment needs.

---

<h2 id="Images">
Alpine Linux or Debian?
</h2>



Both Alpine Linux and Debian are popular choices for building Docker containers, and each has its own set of advantages and disadvantages. The choice between them depends on your specific requirements and preferences.

### Alpine Linux:

![Alpine](screenshots/alpine_linux.png) 

#### Pros:

- **Size**: Alpine Linux is known for its small image size. It's extremely lightweight, with minimal packages installed by default. This makes Alpine a popular choice for containers when minimizing image size is crucial.

- **Security**: Due to its minimalistic nature, Alpine tends to have a smaller attack surface, which can enhance security. It uses the musl libc instead of glibc, which can have some security benefits.

- **Package Manager**: Alpine uses the **apk** package manager, which is simple and effective for managing packages within containers.


#### Cons:

- **Compatibility**: Some software that expects a full glibc environment might not work properly on Alpine without adjustments.

- **Limited package availability**: The Alpine package repositories may not have as extensive a selection as Debian.

### Debian:

![Debian](screenshots/debian.png)

#### Pros:

- **Stability**: Debian is known for its stability and wide package availability. It has a long history of being a reliable choice for various server applications.

- **Compatibility**: Because Debian uses the glibc standard C library, it's more compatible with software that expects a traditional Linux environment.

- **Package Manager**: Debian uses **apt** as its package manager, which is highly versatile and widely used.

#### Cons:

- **Larger image size**: Debian images are typically larger than Alpine images, which can lead to longer image pull times and increased storage requirements.
Slightly higher resource usage due to the larger image size.

### General Purposes and Use Cases:

- **Alpine**: Alpine is an excellent choice when you need minimalism, especially for microservices or single-purpose containers. It's ideal for situations where image size and security are paramount, such as in edge computing or container orchestration platforms like Kubernetes.

- **Debian**: Debian is a versatile choice for a wide range of use cases. It's suitable for applications that require compatibility with a variety of software, and its extensive package repository makes it a solid choice for general-purpose containers, especially in traditional server environments.

Ultimately, the choice between Alpine and Debian comes down to your specific requirements, including image size, compatibility, and the software you need to run in your containers.

Considering all of this, I chose to use **Debian** for my project, for two main reasons:

- **Versatility**: From the get go, I had every intention on doing all Bonus parts. Debian provides more compatibility between different and broader features.
- **Documentation**: Say what you want, but Debian has been, overtime, more used elsewhere and, therefore, more documentated. You can find just about anything for Debian troubleshooting, which makes this whole ordeal much easier.
